import Foundation

public class TestFunctionDeclDefaultArgument: TestDatable {
    public static func file() -> String {
        return #file
    }
    
    func oneArgument(argument1: Int = 1) {
        
    }
    func multipleArgument(argument1: Int = 1, argument2: String = "string") {
        
    }
}


