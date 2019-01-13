import Foundation

public class TestFunctionDeclUsingThrows: TestDatable {
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
    func noArgumentUsingThrowsKeyword() throws {
        
    }
    func oneArgumentUsingThrowsKeyword(argument1: Int) throws {
        
    }
    func multipleArgumentUsingThrowsKeyword(argument1: Int, argument2: String) throws {
        
    }
}
