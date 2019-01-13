//
//  TestFunctionDeclHasClosureArgument.swift
//  RagnarokCoreTests
//
//  Created by Yudai.Hirose on 2019/01/13.
//

import Foundation

public class TestFunctionDeclHasClosureArgument {
    func closureNoEscaping(closure: () -> Void) {
        
    }
    func closureEscaping(closure: @escaping () -> Void) {
        
    }
    func twoClosureNoEscaping(closure1: () -> Void, closure2: () -> Void) {
        
    }
    func twoClosureEscaping(closure1: @escaping () -> Void, closure2: @escaping () -> Void) {
        
    }
}
