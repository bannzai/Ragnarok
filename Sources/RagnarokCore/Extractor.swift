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
        print("result: --------- \n " + result.description + "\n --------- ")
    }

    private func findFunctionalParent(syntax: Syntax) -> Syntax? {
        switch syntax.parent {
        case .none:
            return nil
        case let function as FunctionDeclSyntax:
            print("FunctionDeclSyntax: \(function)")
            return function
        case let function as FunctionTypeSyntax:
            print("FunctionTypeSyntax: \(function)")
            return function
        case let identifier as IdentifierExprSyntax where identifier.parent is FunctionCallExprSyntax:
            print("IdentifierExprSyntax: \(identifier)")
            return identifier
        case let function as ClosureExprSyntax:
            print("ClosureExprSyntax: \(function)")
            return function
        case .some(let other):
            return findFunctionalParent(syntax: other)
        }
    }
    
    private func baseIndent(syntax: Syntax) -> Int {
        return findFunctionalParent(syntax: syntax)?.leadingTrivia?.sourceLength.columnsAtLastLine ?? 0
    }
    
    public override func visit(_ token: TokenSyntax) -> Syntax {
        func lineBreakForLeftParent(token: TokenSyntax) -> Syntax {
            let isFunctionalSyntax = token.parent is FunctionCallExprSyntax || token.parent is FunctionDeclSyntax
            guard isFunctionalSyntax else {
                return token
            }
            return token
                .withTrailingTrivia(
                    token
                        .trailingTrivia
                        .appending(
                            .newlines(1)
                    )
            )
        }
        
        func lineBreakForRightParent(token: TokenSyntax) -> Syntax {
            let isFunctionalSyntax = token.parent is FunctionCallExprSyntax || token.parent is FunctionDeclSyntax
            guard isFunctionalSyntax else {
                return token
            }
            return token
                .withLeadingTrivia(
                    token
                        .leadingTrivia
                        .appending(
                            .newlines(1)
                    )
            )
        }
        
        func lineBreakForComma(token: TokenSyntax) -> Syntax {
            let isFunctionalSyntax = token.parent is FunctionCallExprSyntax || token.parent is FunctionDeclSyntax
            guard isFunctionalSyntax else {
                return token
            }
            return token
                .withTrailingTrivia(
                    token
                        .trailingTrivia
                        .appending(
                            .newlines(1)
                    )
            )
        }
        
        switch token.tokenKind {
        case .leftParen:
            return lineBreakForLeftParent(token: token)
        case .rightParen:
            return lineBreakForRightParent(token: token)
        case .comma:
            return lineBreakForComma(token: token)
        case _:
            return super.visit(token)
        }
    }
    
    public override func visit(_ node: ParameterClauseSyntax) -> Syntax {
        if node.parameterList.count == 1 {
            return super.visit(node)
        }
        
        guard let functionalParentSyntax = findFunctionalParent(syntax: node) else {
            return super.visit(node)
        }
        
        let indent = baseIndent(syntax: functionalParentSyntax) + 8
        func makeSyntax(node: FunctionParameterListSyntax) -> FunctionParameterListSyntax {
            var newParameterList = node
            let indent = baseIndent(syntax: node) + 4
            for (offset, parameter) in node.enumerated() {
                switchFirstName: switch parameter.firstName {
                case .none:
                    break switchFirstName
                case .some(let firstName):
                    let leadingTrivia = firstName
                        .leadingTrivia
                        .reduce(Trivia(pieces: []), { (result, piece) in
                            switch piece {
                            case .newlines:
                                return result
                            case _:
                                return result.appending(piece)
                            }
                        })
                        .appending(.newlines(1))
                        .appending(.spaces(indent))
                    
                    newParameterList = newParameterList.replacing(
                        childAt: offset,
                        with: parameter.withFirstName(firstName.withLeadingTrivia(leadingTrivia))
                    )
                }
            }
            
            return newParameterList
        }
        
        let leadingTrivia = node
            .rightParen
            .leadingTrivia
            .reduce(Trivia(pieces: []), { (result, piece) in
                switch piece {
                case .newlines:
                    return result
                case _:
                    return result.appending(piece)
                }
            })
            .appending(.newlines(1))
            .appending(.spaces(indent))

        return node
            .withParameterList(makeSyntax(node: node.parameterList))
            .withRightParen(node.rightParen.withLeadingTrivia(leadingTrivia))
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

