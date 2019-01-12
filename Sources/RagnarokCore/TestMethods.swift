//
//  TestMethods.swift
//  RagnarokCore
//
//  Created by Yudai.Hirose on 2019/01/12.
//

import Foundation

class Test {
    
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
