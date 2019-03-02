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

private func globalOneArgumentNoReturn(argument: Int) {
    
}
private func globalTwoArgumentNoReturn(argument1: Int, argument2: String) {
    
}
private func globalThreeArgumentNoReturn(argument1: Int, argument2: String, argument3: String) {
    
}

