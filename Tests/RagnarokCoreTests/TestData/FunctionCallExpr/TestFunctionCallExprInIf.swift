import Foundation

public class TestFunctionCallExprInIf: TestDatable {
    public static func file() -> String {
        return #file
    }
    func example() {
        let test = TestFunctionDeclHasReturnType()
        if let a = test.noArgumentHasReturnKeyword() {
            print(a)
        }
        if let b = test.oneArgumentHasReturnKeyword(argument: 1) {
            print(b)
        }
        if let c = test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "string") {
            print(c)
        }
    }
}
