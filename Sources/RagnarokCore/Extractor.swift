import Foundation
import SwiftSyntax

public protocol FileFinder {
    func isNotExists(at path: String) -> Bool
}

public struct FileFinderImpl: FileFinder {
    public func isNotExists(at path: String) -> Bool {
        return !FileManager.default.fileExists(atPath: path)
    }
    
    public func noArgument() {
        
    }
    
    public func singleArgumentFunc(fuga: Int) {
        
    }
    
    public func oneline(fuga: String, piyo: Int) {
        
    }
    
    public func multipleline(
        firstName secondName: String,
        firstNameForSecondArgument: Int
        ) {
        
    }
    
    func hasReturnValue() -> Void {
        
    }
    
    func hasReturnValue(fuga: String, piyo: Int) -> Void {
        
    }
    
    func ellipseFunctionPattern(_ fuga: String, _ piyo: Int) {
        
    }
    
    func ellipseVariablePattern(fuga: String, piyo: Int) {
        
    }
    
    func trailingClosurePattern(fuga: String, piyo: Int, closure: () -> Void) {
        
    }

    public init() {
        multipleline(
            
            firstName: "",
            
            firstNameForSecondArgument: 0
        )
        
        multipleline(
            firstName: "",
            firstNameForSecondArgument: 0
        )
        
        let one = oneline(fuga: "string", piyo: 0)
        let multi = multipleline(
            firstName: "",
            firstNameForSecondArgument: 0
        )
        
        let _ = oneline(fuga: "string", piyo: 0)
        _ = multipleline(
            firstName: "",
            firstNameForSecondArgument: 0
        )
        _ = ellipseVariablePattern(fuga: "", piyo: 1)

        singleArgumentFunc(fuga: 1)
        oneline(fuga: "", piyo: 0)
        noArgument()
        hasReturnValue()
        hasReturnValue(fuga: "", piyo: 1)
        ellipseFunctionPattern("", 1)
        
        trailingClosurePattern(fuga: "", piyo: 1) {
            
        }
        
        [1].reduce(2) { (result, element)  in
            return result + element
        }

        [1].reduce(2, { (result, element)  in
            return result + element
        })
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
    
    var additionalIndent: Int {
        return Const.indent
    }

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
        
        func makeSyntax(
            node: FunctionCallArgumentListSyntax,
            mostLeadingIndent: Int
            ) -> FunctionCallArgumentListSyntax {
            var newParameterList = node
            let indent = mostLeadingIndent + additionalIndent
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
            adjustmentRightParenIndent = additionalIndent
        }
        if let inIf = findParent(from: node, to: IfStmtSyntax.self) {
            baseIndent = indent(from: inIf)
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
                            Trivia(arrayLiteral: .newlines(1), .spaces(baseIndent + additionalIndent)
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

extension FunctionDeclArgumentsReWriter {
    struct Const {
        static let indent = 4
    }
}
