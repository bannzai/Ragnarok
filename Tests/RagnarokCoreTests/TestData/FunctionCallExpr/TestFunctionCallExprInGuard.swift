//
//  TestFunctionCallExprInGuard.swift
//  RagnarokCoreTests
//
//  Created by Yudai.Hirose on 2019/01/13.
//

import Foundation

public class TestFunctionCallExprInGuard {
    func example() {
        let test = TestFunctionDeclHasReturnType()
        
        guard let a = Optional(test.noArgumentHasReturnKeyword()) else {
            return
        }
        guard let b = Optional(test.oneArgumentHasReturnKeyword(argument: 1)) else {
            return
        }
        guard let c = Optional(test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "string")) else {
            return
        }
        
        print(a,b,c)
    }
}
