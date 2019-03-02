import Foundation
import SwiftSyntax

public class RagnarokRewriter: SyntaxRewriter {
    public let path: URL
    
    convenience public init(path urlString: String) throws {
        try self.init(path: URL.init(fileURLWithPath: urlString))
    }
    
    public init(path url: URL) throws {
        path = url
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
        
        let baseIndent = parentIndent(syntax: functionalParentSyntax)
        var numberOfLineBreakForClauseLeftParen = 1
        var numberOfIndentForClauseLeftParen = baseIndent + Const.indent
        
        func makeSyntax(node: FunctionParameterListSyntax) -> FunctionParameterListSyntax {
            var newParameterList = node
            
            let indent = parentIndent(syntax: node) + Const.indent * 2

            for (offset, parameter) in node.enumerated() {
                var newParamter = parameter
                
                let isAlreadyLineBreak = newParamter.leadingTrivia?.contains(where: { (piece) -> Bool in
                    switch piece {
                    case .newlines:
                        return true
                    case _:
                        return false
                    }
                }) ?? false
                let lineBreakCount: Int = isAlreadyLineBreak ? 0 : 1
                let trailingIndent: Int = isAlreadyLineBreak ? 0 : indent

                let isFirst = offset == node.startIndex
                if isFirst && isAlreadyLineBreak {
                    numberOfLineBreakForClauseLeftParen = 0
                    numberOfIndentForClauseLeftParen = 0
                }
                
                let isLast = (offset + 1) == node.endIndex
                switchIsLast: switch isLast {
                case false:
                    switch newParamter.ellipsis {
                    case let ellipsis? where ellipsis.text == ",":
                        // It is bugs for SwiftSyntax
                        // https://bugs.swift.org/browse/SR-9797
                        // https://github.com/apple/swift/pull/22214
                        let comma = SyntaxFactory.makeCommaToken(trailingTrivia: [.newlines(lineBreakCount), .spaces(trailingIndent)])
                        newParamter = newParamter.withEllipsis(comma)
                    case _:
                        let comma = SyntaxFactory.makeCommaToken(trailingTrivia: [.newlines(lineBreakCount), .spaces(trailingIndent)])
                        newParamter = newParamter.withTrailingComma(comma)
                    }
                case true:
                    break switchIsLast
                }

                switchFirstName: switch parameter.firstName {
                case .none:
                    break switchFirstName
                case .some(let firstName):
                    newParamter = newParamter.withFirstName(firstName)
                }
                
                newParameterList = newParameterList.replacing(
                    childAt: offset,
                    with: newParamter
                )
            }
            return newParameterList
        }
        
        var newNode = node

        newNode = newNode.withParameterList(
            makeSyntax(
                node: node.parameterList
            )
        )
        
        let leftParen = newNode.leftParen
        newNode = newNode
            .withLeftParen(
                leftParen
                    .withTrailingTrivia(
                        Trivia(arrayLiteral: .newlines(numberOfLineBreakForClauseLeftParen), .spaces(numberOfIndentForClauseLeftParen)
                        )
                )
        )
        
        let rightParen = newNode.rightParen
        newNode = newNode
            .withRightParen(
                rightParen
                    .withLeadingTrivia(
                        Trivia(arrayLiteral: .newlines(1), .spaces(baseIndent + Const.indent)
                        )
                )
        )

        return newNode
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
            adjustmentRightParenIndent = Const.indent
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
extension RagnarokRewriter {
    public func formatted() throws -> String {
        return visit(try SyntaxTreeParser.parse(path)).description
    }
    
    public func exec() throws {
        try formatted().write(to: path, atomically: true, encoding: .utf8)
    }
}


// MARK: - Const
extension RagnarokRewriter {
    struct Const {
        static let indent = 4
    }
}

// MARK: - Private
private extension RagnarokRewriter {
    private func parentIndent(syntax: Syntax) -> Int {
        guard let parent = syntax.parent else {
            return indent(from: syntax)
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
