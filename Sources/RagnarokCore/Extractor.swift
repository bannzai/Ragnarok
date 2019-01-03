import Foundation
import SwiftSyntax

public protocol FileFinder {
    func isNotExists(at path: String) -> Bool
}

public struct FileFinderImpl: FileFinder {
    public func isNotExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
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
    
    public override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        print("node.attributes: \(node.attributes)")
        print("node.attributes.debugDescription: \(node.attributes.debugDescription)")
        print("node.modifiers: \(node.modifiers)")
        print("node.modifiers.debugDescription: \(node.modifiers.debugDescription)")
        print("node.funcKeyword: \(node.funcKeyword)")
        print("node.identifier: \(node.identifier)")
        print("node.genericParameterClause: \(node.genericParameterClause)")
        print("node.genericParameterClause.debugDescription: \(node.genericParameterClause.debugDescription)")
        print("node.signature: \(node.signature)")
        print("node.genericWhereClause: \(node.genericWhereClause)")
        print("node.genericWhereClause.debugDescription: \(node.genericWhereClause.debugDescription)")
        print("node.body: \(node.body)")
        print("node.body.debugDescription: \(node.body.debugDescription)")
        return node
    }
}

