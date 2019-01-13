//
//  TestDatable.swift
//  RagnarokCoreTests
//
//  Created by Yudai.Hirose on 2019/01/13.
//

import Foundation

public protocol TestDatable {
    static func file() -> String
}

public protocol FunctionDeclTestDatable: TestDatable {
    
}

public protocol FunctionCallExprTestDatable: TestDatable {
    static func expected() -> String
}
