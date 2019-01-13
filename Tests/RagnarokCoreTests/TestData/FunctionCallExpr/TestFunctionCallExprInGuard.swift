import Foundation

public class TestFunctionCallExprInGuard: TestDatable {
    public static func file() -> String {
        return #file
    }
    public func example() {
        let test = TestFunctionDeclHasReturnType()
        
        guard let a = Optional(test.noArgumentHasReturnKeyword()) else {
            return
        }
        guard let b = Optional(test.oneArgumentHasReturnKeyword(argument: 1)) else {
            return
        }
        guard let c = Optional(test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "string")) else {
            return
        }
        
        print(a,b,c)
    }
}
