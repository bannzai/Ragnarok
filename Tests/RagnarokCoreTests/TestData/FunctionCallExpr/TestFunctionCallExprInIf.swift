import Foundation

public class TestFunctionCallExprInIf: TestDatable {
    public static func file() -> String {
        return #file
    }
    public func example() {
        let test = TestFunctionDeclHasReturnType()
        if let a = Optional(test.noArgumentHasReturnKeyword()) {
            print(a)
        }
        if let b = Optional(test.oneArgumentHasReturnKeyword(argument: 1)) {
            print(b)
        }
        if let c = Optional(test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "string")) {
            print(c)
        }
    }
}
