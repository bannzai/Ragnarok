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

    private func parentIndent(token: Syntax) -> Int {
        guard let parent = token.parent else {
            return 0
        }
        return indent(from: parent)
    }
    
    private func indent(from token: Syntax) -> Int {
        return token.leadingTrivia?.sourceLength.columnsAtLastLine ?? 0
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
        return Const.additionalIndent
    }

    public override func visit(_ token: TokenSyntax) -> Syntax {
        func lineBreakForLeftParen(token: TokenSyntax) -> Syntax {
            let isFunctionalSyntax = token.parent is FunctionCallExprSyntax || token.parent is FunctionDeclSyntax
            guard isFunctionalSyntax else {
                return token
            }
            
            return token
                .withTrailingTrivia(
                    Trivia(
                        arrayLiteral: .newlines(1), .spaces((parentIndent(token: token) + additionalIndent))
                    )
            )
            
        }
        
        func lineBreakForRightParen(token: TokenSyntax) -> Syntax {
            let isFunctionalSyntax = token.parent is FunctionCallExprSyntax || token.parent is FunctionDeclSyntax
            guard isFunctionalSyntax else {
                return token
            }
            
            return token
                .withLeadingTrivia(
                    token
                        .leadingTrivia
                        .appending(.newlines(1))
                        .appending(.spaces(parentIndent(token: token)))
            )
        }
        
        func lineBreakForComma(token: TokenSyntax) -> Syntax {
            let isFunctionalSyntax = token.parent is FunctionCallArgumentSyntax
            guard isFunctionalSyntax else {
                return token
            }
            
            var baseIndent: Int = parentIndent(token: token)
            if let functionIdentifier = findParent(from: token, to: FunctionCallExprSyntax.self) {
                baseIndent = indent(from: functionIdentifier)
            }
            
            return token
                .withTrailingTrivia(
                    token
                        .trailingTrivia
                        .appending(.newlines(1))
                        .appending(.spaces(baseIndent + additionalIndent))
            )
        }
        
        func removeLineBreakForFunctionLabel(token: TokenSyntax) -> Syntax {
            guard
                let parent = token.parent as? FunctionCallArgumentSyntax,
                let functionCallExprParent = findParent(from: parent, to: FunctionCallExprSyntax.self),
                let functionCallExprParentFirstChild = functionCallExprParent.children.first(where: { (syntax) in
                    return syntax.leadingTrivia != nil
                }),
                let functionCallLeadingTrivia = functionCallExprParentFirstChild.leadingTrivia
                else {
                    assertionFailure()
                    return token
            }

            let isOnlyOneFunctionArgument = parent
                .children
                .compactMap { $0 as? TokenSyntax }
                .filter { token in
                    switch token.tokenKind {
                    case .comma:
                        return true
                    case _:
                        return false
                    }
                }
                .isEmpty
            
            if isOnlyOneFunctionArgument {
                return token
            }

            let indent = functionCallLeadingTrivia.sourceLength.columnsAtLastLine + additionalIndent
            return token
                .withLeadingTrivia(
                    Trivia(arrayLiteral: .newlines(1), .spaces(indent))
            )
        }
        
        switch token.tokenKind {
//        case .leftParen:
//            return lineBreakForLeftParen(token: token)
        case .rightParen:
            return lineBreakForRightParen(token: token)
//        case .comma:
//            return lineBreakForComma(token: token)
        case .identifier where token.parent is FunctionCallArgumentSyntax:
            return removeLineBreakForFunctionLabel(token: token)
        case _:
            return super.visit(token)
        }
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
        static let additionalIndent = 4
    }
}
