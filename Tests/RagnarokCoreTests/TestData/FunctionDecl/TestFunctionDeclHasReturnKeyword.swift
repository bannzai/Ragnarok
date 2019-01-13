import Foundation

public class TestFunctionDeclHasReturnType: TestDatable {
    public static func file() -> String {
        return #file
    }
    public static func expected() -> String {
        let expected = """
import Foundation

public class TestFunctionCallExprNoReturn: TestDatable {
    public static func file() -> String {
        return #file
    }
    public func example() {
        let test = TestFunctionDeclNoReturn()
        test.noArgumentNoReturn()
        test.oneArgumentNoReturn(argument: 1)
        test.twoArgumentNoReturn(
            argument1: 1,
            argument2: "2"
        )
    }
}

"""
        return expected
    }
    func noArgumentHasReturnKeyword() -> Int {
        return 1
    }
    func oneArgumentHasReturnKeyword(argument: Int) -> Int {
        return 1
    }
    func twoArgumentHasReturnKeyword(argument1: Int, argument2: String) -> Int {
        return 1
    }
}
