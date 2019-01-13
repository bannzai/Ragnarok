import Foundation

public class TestFunctionCallExprInGuard: TestDatable {
    public static func file() -> String {
        return #file
    }
    func example() {
        let test = TestFunctionDeclHasReturnType()
        
        guard let a = test.noArgumentHasReturnKeyword() else {
            return
        }
        guard let b = test.oneArgumentHasReturnKeyword(argument: 1) else {
            return
        }
        guard let c = test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "string") else {
            return
        }
        
        print(a,b,c)
    }
}
