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

    private func parentIndent(syntax: Syntax) -> Int {
        guard let parent = syntax.parent else {
            return 0
        }
        return indent(from: parent)
    }
    
    private func indent(from syntax: Syntax) -> Int {
        return syntax.leadingTrivia?.sourceLength.columnsAtLastLine ?? 0
    }
    
    
    func findParent<T: Syntax>(from syntax: Syntax, to goalType: T.Type) -> T? {
        if let target = syntax as? T {
            return target
        }
        
        guard let next = syntax.parent else {
            return nil
        }

        return findParent(from: next, to: goalType)
    }
    
    var additionalIndent: Int {
        return Const.indent
    }
    
//    public override func visit(_ node: FunctionParameterListSyntax) -> Syntax {
//        let isNotMultipleFunctionArgument = node
//            .children
//            .compactMap({ $0 as? TokenSyntax })
//            .filter { token in
//                switch token.tokenKind {
//                case .comma:
//                    return true
//                case _:
//                    return false
//                }
//            }
//            .isEmpty
//
//        if isNotMultipleFunctionArgument {
//            return super.visit(node)
//        }
//
//        guard let parent = findParent(from: node, to: FunctionDeclSyntax.self) else {
//            assertionFailure()
//            return super.visit(node)
//        }
//
//
//        var newParameterList = node
//        let baseIndent = indent(from: parent)
//        for (offset, parameter) in node.enumerated() {
//            let isLast = (offset + 1) == node.endIndex
//            switch isLast {
//            case false:
//                let comma = SyntaxFactory
//                    .makeCommaToken()
//                    .withTrailingTrivia(
//                        Trivia(
//                            arrayLiteral: .newlines(1), .spaces(baseIndent + additionalIndent)
//                        )
//                )
//
//                newParameterList = newParameterList.replacing(
//                    childAt: offset,
//                    with: parameter.withTrailingComma(comma)
//                )
//            case true:
//                let comma = SyntaxFactory
//                    .makeCommaToken()
//                    .withTrailingTrivia(
//                        Trivia(
//                            arrayLiteral: .newlines(1), .spaces(baseIndent + additionalIndent)
//                        )
//                )
//                //                parameter
//                //                    .withTrailingComma(<#T##newChild: TokenSyntax?##TokenSyntax?#>)
//            }
//        }
//
//
//        return super.visit(node)
//    }
    
    
    
    public override func visit(_ node: ParameterClauseSyntax) -> Syntax {
        if node.parameterList.count <= 1 {
            return super.visit(node)
        }
        
        guard let functionalParentSyntax = findParent(from: node, to: FunctionDeclSyntax.self) else {
            return super.visit(node)
        }
        
        func makeSyntax(node: FunctionParameterListSyntax) -> FunctionParameterListSyntax {
            var newParameterList = node
            let indent = parentIndent(syntax: node) + additionalIndent * 2
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
        
        let indent = parentIndent(syntax: functionalParentSyntax) + additionalIndent
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

    
    public override func visit(_ node: FunctionCallExprSyntax) -> ExprSyntax {
        if node.argumentList.count <= 1 {
            return super.visit(node)
        }
        
        func makeSyntax(node: FunctionCallArgumentListSyntax) -> FunctionCallArgumentListSyntax {
            var newParameterList = node
            let indent = parentIndent(syntax: node) + additionalIndent
            for (offset, parameter) in node.enumerated() {
                let isLast = (offset + 1) == node.endIndex
                switchIsLast: switch isLast {
                case false:
                    let comma = SyntaxFactory.makeCommaToken(trailingTrivia: [.newlines(1), .spaces(indent)])
                    newParameterList = newParameterList.replacing(
                        childAt: offset,
                        with: parameter.withTrailingComma(comma)
                    )
                case true:
                    break switchIsLast
                }
            }
            
            return newParameterList
        }
        
        let baseIndent = parentIndent(syntax: node)
        var newNode = node.withArgumentList(makeSyntax(node: node.argumentList))
        if let leftParen = node.leftParen {
            let leftParenTrivia = leftParen
                .trailingTrivia
                .reduce(Trivia(pieces: []), { (result, piece)  in
                    switch piece {
                    case .newlines:
                        return result
                    case _:
                        return result.appending(piece)
                    }
                })
                .appending(.newlines(1))
                .appending(.spaces(baseIndent + additionalIndent))
            newNode = newNode.withLeftParen(leftParen.withTrailingTrivia(leftParenTrivia))
        }
        
        if let rightParen = node.rightParen {
            let rightParenTrivia = rightParen
                .leadingTrivia
                .reduce(Trivia(pieces: []), { (result, piece)  in
                    switch piece {
                    case .newlines:
                        return result
                    case _:
                        return result.appending(piece)
                    }
                })
                .appending(.newlines(1))
                .appending(.spaces(baseIndent))
            
            newNode = newNode.withRightParen(rightParen.withLeadingTrivia(rightParenTrivia))
        }
        return newNode
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

extension FunctionDeclArgumentsReWriter {
    struct Const {
        static let indent = 4
    }
}
