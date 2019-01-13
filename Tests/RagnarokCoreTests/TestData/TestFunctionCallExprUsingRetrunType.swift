import Foundation

public class TestFunctionCallExprSubstituteVariable {
    func example() {
        let test = TestFunctionDeclHasReturnType()
        let a = test.noArgumentHasReturnKeyword()
        let b = test.oneArgumentHasReturnKeyword(argument: 1)
        let c = test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "string")
        
        print(a,b,c)
    }
}
