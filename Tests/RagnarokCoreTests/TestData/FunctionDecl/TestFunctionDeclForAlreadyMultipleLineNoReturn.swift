import Foundation

public class TestFunctionDeclForAlreadyMultipleLineNoReturn: TestDatable {
    public static func file() -> String {
        return #file
    }
    func noArgumentNoReturn() {
        
    }
    func oneArgumentNoReturn(
        argument: Int
        ) {
        
    }
    func twoArgumentNoReturn(
        argument1: Int,
        argument2: String
        ) {
        
    }
}

func globalOneArgumentNoReturn(
    argument: Int
    ) {
    
}
func globalTwoArgumentNoReturn(
    argument1: Int,
    argument2: String
    ) {
    
}
