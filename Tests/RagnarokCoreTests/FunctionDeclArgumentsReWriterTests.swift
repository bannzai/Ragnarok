import XCTest
import class Foundation.Bundle
@testable import RagnarokCore

final class FunctionDeclArgumentsReWriterTests: XCTestCase {
    func testFormatted() throws {
        try XCTContext.runActivity(named: "Test visit of FunctionCallExprSyntax") { (activity) in
            try XCTContext.runActivity(named: "Test visit of TestFunctionCallExprNoReturn") { (activity) in
                let input = URL(string: TestFunctionCallExprNoReturn.file())!
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
                let rewriter = try FunctionDeclArgumentsReWriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }
        }
    }
}
