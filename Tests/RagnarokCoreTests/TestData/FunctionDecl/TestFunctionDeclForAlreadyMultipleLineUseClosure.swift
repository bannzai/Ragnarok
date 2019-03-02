import Foundation

public class TestFunctionDeclForAlreadyMultipleLineUseClosure: TestDatable {
    public static func file() -> String {
        return #file
    }
    func closureNoEscaping(
        closure: () -> Void
        ) {
        
    }
    func closureEscaping(
        closure: @escaping () -> Void
        ) {
        
    }
    func twoClosureNoEscaping(
        closure1: () -> Void,
        closure2: () -> Void
        ) {
        
    }
    func twoClosureEscaping(
        closure1: @escaping () -> Void,
        closure2: @escaping () -> Void
        ) {
        
    }
}
