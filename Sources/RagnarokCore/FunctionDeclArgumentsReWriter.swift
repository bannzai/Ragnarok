import Foundation
import SwiftSyntax

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
    
    // MARK: - SyntaxRewriter
    public override func visit(_ node: ParameterClauseSyntax) -> Syntax {
        if node.parameterList.count <= 1 {
            return super.visit(node)
        }
        
        guard let functionalParentSyntax = findParent(
            from: node,
            to: FunctionDeclSyntax.self
            ) else {
                return super.visit(node)
        }
        
        func makeSyntax(node: FunctionParameterListSyntax) -> FunctionParameterListSyntax {
            var newParameterList = node
            let indent = parentIndent(syntax: node) + Const.indent * 2
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
        
        let indent = parentIndent(syntax: functionalParentSyntax) + Const.indent
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
        
        func makeSyntax(
            node: FunctionCallArgumentListSyntax,
            mostLeadingIndent: Int
            ) -> FunctionCallArgumentListSyntax {
            var newParameterList = node
            let indent = mostLeadingIndent + Const.indent
            for (offset, parameter) in node.enumerated() {
                var newParamter = parameter
                
                let isLast = (offset + 1) == node.endIndex
                switchIsLast: switch isLast {
                case false:
                    let comma = SyntaxFactory.makeCommaToken(trailingTrivia: [.newlines(1), .spaces(indent)])
                    newParamter = newParamter.withTrailingComma(comma)
                case true:
                    break switchIsLast
                }
                
                switchParameterLabel: switch newParamter.label {
                case .none:
                    break switchParameterLabel
                case .some(let label):
                    newParamter = newParamter.withLabel(label.withoutTrivia())
                }
                
                newParameterList = newParameterList.replacing(
                    childAt: offset,
                    with: newParamter
                )
            }
            
            return newParameterList
        }
        
        var baseIndent = indent(from: node)
        var adjustmentRightParenIndent = 0
        if let inFunction = findParent(from: node, to: FunctionCallExprSyntax.self) {
            baseIndent = indent(from: inFunction)
        }
        if let forDiscardAssignmentExpr = findParent(from: node, to: ExprListSyntax.self) {
            baseIndent = indent(from: forDiscardAssignmentExpr)
        }
        if let inVariableDecl = findParent(from: node, to: VariableDeclSyntax.self) {
            baseIndent = indent(from: inVariableDecl)
        }
        if let inReturn = findParent(from: node, to: ReturnStmtSyntax.self) {
            baseIndent = indent(from: inReturn)
        }
        if let inGuard = findParent(from: node, to: GuardStmtSyntax.self) {
            baseIndent = indent(from: inGuard)
            adjustmentRightParenIndent = Const.indent
        }
        if let inIf = findParent(from: node, to: IfStmtSyntax.self) {
            baseIndent = indent(from: inIf)
        }
        if let forTryKeyword = findParent(from: node, to: TryExprSyntax.self) {
            baseIndent = indent(from: forTryKeyword)
        }
        
        var newNode = node
        
        newNode = newNode.withArgumentList(
            makeSyntax(
                node: node.argumentList,
                mostLeadingIndent: baseIndent
            )
        )
        
        if let leftParen = newNode.leftParen {
            newNode = newNode
                .withLeftParen(
                    leftParen
                        .withTrailingTrivia(
                            Trivia(arrayLiteral: .newlines(1), .spaces(baseIndent + Const.indent)
                            )
                    )
            )
        }
        
        if let rightParen = newNode.rightParen {
            newNode = newNode
                .withRightParen(
                    rightParen
                        .withLeadingTrivia(
                            Trivia(arrayLiteral: .newlines(1), .spaces(baseIndent + adjustmentRightParenIndent)
                            )
                    )
            )
        }
        
        return newNode
    }
}

// MARK: - Interface
extension FunctionDeclArgumentsReWriter {
    public func exec() throws {
        let parsedList = try paths
            .map(SyntaxTreeParser.parse)
            .map(visit)

        try zip(parsedList, paths).forEach { parsed, path in
            try parsed.description.write(to: path, atomically: true, encoding: .utf8)
        }
    }
}


// MARK: - Const
extension FunctionDeclArgumentsReWriter {
    struct Const {
        static let indent = 4
    }
}

// MARK: - Private
private extension FunctionDeclArgumentsReWriter {
    private func parentIndent(syntax: Syntax) -> Int {
        guard let parent = syntax.parent else {
            return 0
        }
        return indent(from: parent)
    }
    
    private func indent(from syntax: Syntax) -> Int {
        return syntax.leadingTriviaLength.columnsAtLastLine
    }
    
    func findParent<T: Syntax>(from syntax: Syntax, to goalType: T.Type) -> T? {
        guard let next = syntax.parent else {
            return nil
        }
        
        if let target = next as? T {
            return target
        }
        
        return findParent(from: next, to: goalType)
    }
}
