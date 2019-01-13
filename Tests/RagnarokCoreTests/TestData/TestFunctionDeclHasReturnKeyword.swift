import Foundation

public class TestFunctionDeclHasReturnType {
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
