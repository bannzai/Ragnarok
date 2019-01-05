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
        fuga: String,
        piyo: Int
        ) {
        
    }

    public init() {
        
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
    
    public override func visit(_ node: FunctionParameterListSyntax) -> Syntax {
        if node.totalLength.newlines != 0 {
            return node
        }
        
        var newNode = node
        for (offset, parameter) in node.enumerated() {
            switch parameter.trailingComma {
            case .none:
                continue
            case .some:
                let comma = SyntaxFactory.makeCommaToken()
                let commaWithNewline = comma.withTrailingTrivia(Trivia(pieces: [.newlines(0)]))
                let newParameter = parameter.withTrailingComma(commaWithNewline)
                newNode = node.replacing(childAt: offset, with: newParameter)
            }
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

