import Foundation

public class TestFunctionDeclHasReturnType: FunctionDeclTestDatable {
    public static func file() -> String {
        return #file
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
