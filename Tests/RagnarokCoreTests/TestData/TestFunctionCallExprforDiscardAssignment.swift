import Foundation

public class TestFunctionCallExprforDiscardAssignment {
    func example() {
        let test = TestFunctionDeclHasReturnType()
        _ = test.noArgumentHasReturnKeyword()
        _ = test.oneArgumentHasReturnKeyword(argument: 1)
        _ = test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "string")
    }
}
