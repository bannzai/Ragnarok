import Foundation

public class TestFunctionCallExprUsingTryKeyword: TestDatable {
    public static func file() -> String {
        return #file
    }
    func example() throws {
        let test = TestFunctionDeclUsingThrows()
        try test.noArgumentUsingThrowsKeyword()
        try test.oneArgumentUsingThrowsKeyword(argument1: 1)
        try test.multipleArgumentUsingThrowsKeyword(argument1: 1, argument2: "string")
    }
}
