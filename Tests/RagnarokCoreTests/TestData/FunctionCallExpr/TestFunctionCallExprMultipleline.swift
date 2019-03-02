import Foundation

public class TestFunctionCallExprMultipleline: TestDatable {
    public static func file() -> String {
        return #file
    }
    func example() {
        let test = TestFunctionDeclHasReturnType()
        _ = test.noArgumentHasReturnKeyword()
        _ = test.oneArgumentHasReturnKeyword(
            argument: 1
        )
        _ = test.twoArgumentHasReturnKeyword(
            argument1: 1,
            argument2: "string"
        )
    }
}
