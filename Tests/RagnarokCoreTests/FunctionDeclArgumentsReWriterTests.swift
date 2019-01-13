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
    func example() {
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
            
            try XCTContext.runActivity(named: "Test visit of TestFunctionCallExprInGuard") { (activity) in
                let input = URL(string: TestFunctionCallExprInGuard.file())!
                let expected = """
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
        guard let c = test.twoArgumentHasReturnKeyword(
            argument1: 1,
            argument2: "string"
            ) else {
            return
        }
        
        print(
            a,
            b,
            c
        )
    }
}

"""
                let rewriter = try FunctionDeclArgumentsReWriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }
            
            try XCTContext.runActivity(named: "Test visit of TestFunctionCallExprInIf") { (activity) in
                let input = URL(string: TestFunctionCallExprInIf.file())!
                let expected = """
import Foundation

public class TestFunctionCallExprInIf: TestDatable {
    public static func file() -> String {
        return #file
    }
    func example() {
        let test = TestFunctionDeclHasReturnType()
        if let a = test.noArgumentHasReturnKeyword() {
            print(a)
        }
        if let b = test.oneArgumentHasReturnKeyword(argument: 1) {
            print(b)
        }
        if let c = test.twoArgumentHasReturnKeyword(
            argument1: 1,
            argument2: "string"
            ) {
            print(c)
        }
    }
}

"""
                let rewriter = try FunctionDeclArgumentsReWriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }
            
            try XCTContext.runActivity(named: "Test visit of TestFunctionCallExprSubstituteVariable") { (activity) in
                let input = URL(string: TestFunctionCallExprSubstituteVariable.file())!
                let expected = """
import Foundation

public class TestFunctionCallExprSubstituteVariable: TestDatable {
    public static func file() -> String {
        return #file
    }
    func example() {
        let test = TestFunctionDeclHasReturnType()
        let a = test.noArgumentHasReturnKeyword()
        let b = test.oneArgumentHasReturnKeyword(argument: 1)
        let c = test.twoArgumentHasReturnKeyword(
            argument1: 1,
            argument2: "string"
        )
        
        print(
            a!,
            b!,
            c!
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
