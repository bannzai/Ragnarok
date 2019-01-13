import Foundation

public class TestFunctionCallExprUsingTryKeyword: FunctionCallExprTestDatable {
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
    
    public func example() throws {
        let test = TestFunctionDeclUsingThrows()
        try test.noArgumentUsingThrowsKeyword()
        try test.oneArgumentUsingThrowsKeyword(argument1: 1)
        try test.multipleArgumentUsingThrowsKeyword(argument1: 1, argument2: "string")
    }
}
