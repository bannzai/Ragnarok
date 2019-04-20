import Foundation

public class TestFunctionCallExprNestedFunction: TestDatable {
    public static func file() -> String {
        return #file
    }
    
    func a() {
        
    }

    func example() {
        let test = TestFunctionDeclHasReturnType()
        print(test.noArgumentHasReturnKeyword()!)
        print(test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "2")!, test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "2")!, test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "2")!)
    }
}
