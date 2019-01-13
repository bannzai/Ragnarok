import Foundation

public class TestFunctionCallExprNoReturn {
    func example() {
        let test = TestFunctionDeclNoReturn()
        test.noArgumentNoReturn()
        test.oneArgumentNoReturn(argument: 1)
        test.twoArgumentNoReturn(argument1: 1, argument2: "2")
    }
}
