//
//  RagnarokRewriter.swift
//  RagnarokCore
//
//  Created by Yudai.Hirose on 2019/01/13.
//

import Foundation
import SwiftSyntax

public protocol Rewriter {
    func rewrite() throws
}

public protocol RewriterComponent: Rewriter {
    init(path url: URL) throws
}

public class RagnarokRewriter: SyntaxRewriter, Rewriter {
    public let rewriters: [RewriterComponent]
    
    public init(rewriters: [RewriterComponent.Type], path: URL) throws {
        self.rewriters = try rewriters.map { try $0.init(path: path) }
    }
    
    public func rewrite() throws {
        try rewriters.forEach { try $0.rewrite() }
    }
}

