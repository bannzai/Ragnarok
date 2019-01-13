import Foundation

public class TestFunctionDeclNoReturn: TestDatable {
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
    func noArgumentNoReturn() {
        
    }
    func oneArgumentNoReturn(argument: Int) {
        
    }
    func twoArgumentNoReturn(argument1: Int, argument2: String) {
        
    }
}
