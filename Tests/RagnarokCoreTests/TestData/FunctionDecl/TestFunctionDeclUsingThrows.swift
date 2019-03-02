import Foundation


public class TestFunctionDeclNoReturn: TestDatable {
    public static func file() -> String {
        return #file
    }
    func noArgumentNoReturn() {
        
    }
    func oneArgumentNoReturn(argument: Int) {
        
    }
    func twoArgumentNoReturn(argument1: Int, argument2: String) {
        
    }
}
public class TestFunctionDeclUsingThrows: TestDatable {
    public static func file() -> String {
        return #file
    }
    func noArgumentUsingThrowsKeyword() throws {
        
    }
    func oneArgumentUsingThrowsKeyword(argument1: Int) throws {
        
    }
    func multipleArgumentUsingThrowsKeyword(argument1: Int, argument2: String) throws {
        
    }
}
