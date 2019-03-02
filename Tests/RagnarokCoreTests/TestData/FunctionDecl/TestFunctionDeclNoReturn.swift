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

func globalSinglelineOneArgumentNoReturn(argument: Int) {
    
}
func globalSinglelineTwoArgumentNoReturn(argument1: Int, argument2: String) {
    
}

