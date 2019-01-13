import Foundation

public class TestFunctionDeclNoReturn: FunctionDeclTestDatable {
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
