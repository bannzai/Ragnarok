import Foundation

public class TestFunctionDeclHasEllipsis: TestDatable {
    public static func file() -> String {
        return #file
    }
    
    func oneArgument(argument1: Int...) {
        
    }
    func multipleArgument(argument1: Int..., argument2: String) {
        
    }
}
