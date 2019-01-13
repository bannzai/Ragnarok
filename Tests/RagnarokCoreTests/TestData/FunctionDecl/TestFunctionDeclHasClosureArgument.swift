import Foundation

public class TestFunctionDeclHasClosureArgument: TestDatable {
    public static func file() -> String {
        return #file
    }
    public static func expected() -> String {
        let expected = """
import Foundation

public class TestFunctionCallExprNoReturn: TestDatable {
    public static func file() -> String {
        return #file
    }
    public func example() {
        let test = TestFunctionDeclNoReturn()
        test.noArgumentNoReturn()
        test.oneArgumentNoReturn(argument: 1)
        test.twoArgumentNoReturn(
            argument1: 1,
            argument2: "2"
        )
    }
}

"""
        return expected
    }
    func closureNoEscaping(closure: () -> Void) {
        
    }
    func closureEscaping(closure: @escaping () -> Void) {
        
    }
    func twoClosureNoEscaping(closure1: () -> Void, closure2: () -> Void) {
        
    }
    func twoClosureEscaping(closure1: @escaping () -> Void, closure2: @escaping () -> Void) {
        
    }
}
