import Foundation
import SwiftSyntax

public protocol FileFinder {
    func isNotExists(at path: String) -> Bool
}

public struct FileFinderImpl: FileFinder {
    public func isNotExists(at path: String) -> Bool {
        return !FileManager.default.fileExists(atPath: path)
    }
    
    public func oneline(fuga: String, piyo: Int) {
        
    }
    
    public func multipleline(
        firstName secondName: String,
        firstNameForSecondArgument: Int
        ) {
        
    }

    public init() {
        multipleline(
            firstName: "",
            firstNameForSecondArgument: 0
        )
        let _ = multipleline(
            firstName: "",
            firstNameForSecondArgument: 0
        )
        
        oneline(fuga: "", piyo: 0)
    }
}

public enum RagnarokCoreErrorType: Error {
    case missingFilePath(path: String)
    
    var localizedDescription: String {
        switch self {
        case .missingFilePath(let path):
            return "Can not find swift file at \(path)"
        }
    }
}

public class FunctionDeclArgumentsReWriter: SyntaxRewriter {
    public let paths: [URL]
    
    public init(path: String, fileManager: FileFinder = FileFinderImpl()) throws {
        if fileManager.isNotExists(at: path) {
            throw RagnarokCoreErrorType.missingFilePath(path: path)
        }
        
        paths = [URL.init(fileURLWithPath: path)]
    }
    
    public init(paths rawURLPaths: [String], fileManager: FileFinder = FileFinderImpl()) throws {
        if let notExistsPath = rawURLPaths.first(where: fileManager.isNotExists(at:)) {
            throw RagnarokCoreErrorType.missingFilePath(path: notExistsPath)
        }

        paths = rawURLPaths.map(URL.init(fileURLWithPath:))
    }
    
    public func done() {
        let sourceFile = try! SyntaxTreeParser.parse(paths.first!)
        let result = visit(sourceFile)
        print("result: " + result.description)
    }

//    public override func visit(_ node: ParameterClauseSyntax) -> Syntax {
//        print("node: ParameterClauseSyntax: \(node.parameterList.totalLength)")
//        if node.parameterList.totalLength.newlines == 1 {
//            node.parameterList.replacing(childAt: Int, with: FunctionParameterSyntax(<#T##build: (inout FunctionParameterSyntaxBuilder) -> Void##(inout FunctionParameterSyntaxBuilder) -> Void#>))
//        }
//        return node
//    }
    
    private func findFunctionalParent(syntax: Syntax) -> Syntax? {
        switch syntax.parent {
        case .none:
            return nil
        case let function as FunctionDeclSyntax:
            return function
        case let function as FunctionCallExprSyntax:
            print("expr: \(function)")
            return function
        case .some(let other):
            return findFunctionalParent(syntax: other)
        }
    }
    
    private func baseIndent(syntax: Syntax) -> Int {
        return findFunctionalParent(syntax: syntax)?.leadingTrivia?.sourceLength.columnsAtLastLine ?? 0
    }

    public override func visit(_ node: ParameterClauseSyntax) -> Syntax {
        if !(node.isDecl || node.isExpr) {
            return node
        }
        guard let functionalParentSyntax = findFunctionalParent(syntax: node) else {
            return node
        }
        
        let indent = baseIndent(syntax: functionalParentSyntax)
        let leadingTrivia = node
            .rightParen
            .leadingTrivia
            .appending(.newlines(1))
            .appending(.spaces(indent))

        func makeSyntax(node: FunctionParameterListSyntax) -> FunctionParameterListSyntax {
            var newParameterList = node
            let indent = baseIndent(syntax: node) + 4
            for (offset, parameter) in node.enumerated() {
                var newParameter = parameter
                
                switchFirstName: switch newParameter.firstName {
                case .none:
                    break switchFirstName
                case .some(let firstName):
                    let leadingTrivia = firstName
                        .leadingTrivia
                        .appending(.newlines(1))
                        .appending(.spaces(indent))
                    
                    newParameter = newParameter.withFirstName(firstName.withLeadingTrivia(leadingTrivia))
                    newParameterList = newParameterList.replacing(childAt: offset, with: newParameter)
                }
            }
            
            return newParameterList
        }
        
        return node
            .withParameterList(makeSyntax(node: node.parameterList))
            .withRightParen(node.rightParen.withLeadingTrivia(leadingTrivia))
        
//        return node.withRightParen(node.rightParen.withLeadingTrivia(leadingTrivia))
    }
    
//    public override func visit(_ node: FunctionParameterSyntax) -> Syntax {
//        if node.totalLength.newlines != 0 {
//            return node
//        }
//
//        guard let trailingComma = node.trailingComma else {
//            return node
//        }
//
//        let syntax = trailingComma.withTrailingTrivia(Trivia(
//            pieces: [.newlines(1)]
//        ))
//        return node.withTrailingComma(syntax)
//    }

//    public override func visit(_ node: ParameterClauseSyntax) -> Syntax {
//        node.parent as? FunctionDeclSyntax
//    }
    
//    public override func visit(_ node: FunctionParameterListSyntax) -> Syntax {
//        if node.totalLength.newlines != 0 {
//            return node
//        }
//
//        let text = node
//            .description
//            .replacingOccurrences(of: "\n", with: "")
//            .components(separatedBy: ",")
//            .joined(separator: "\n")
//
//        let syntax: FunctionParameterListSyntax!
//
//        FunctionParameterSyntax { (builder) in
//            builder.use
//        }
//
//        node.replacing(childAt: <#T##Int#>, with: FunctionParameterSyntax)
//
//
//        return node
//    }
}

