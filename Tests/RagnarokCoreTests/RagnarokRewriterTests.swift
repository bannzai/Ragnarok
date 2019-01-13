import XCTest
import class Foundation.Bundle
@testable import RagnarokCore

final class RagnarokRewriterTests: XCTestCase {
    func testFormattedForFunctionCallExpr() throws {
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
                let rewriter = try RagnarokRewriter(path: input)
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
                let rewriter = try RagnarokRewriter(path: input)
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
                let rewriter = try RagnarokRewriter(path: input)
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
                let rewriter = try RagnarokRewriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }
            
            try XCTContext.runActivity(named: "Test visit of TestFunctionCallExprUsingTryKeyword") { (activity) in
                let input = URL(string: TestFunctionCallExprUsingTryKeyword.file())!
                let expected = """
import Foundation

public class TestFunctionCallExprUsingTryKeyword: TestDatable {
    public static func file() -> String {
        return #file
    }
    func example() throws {
        let test = TestFunctionDeclUsingThrows()
        try test.noArgumentUsingThrowsKeyword()
        try test.oneArgumentUsingThrowsKeyword(argument1: 1)
        try test.multipleArgumentUsingThrowsKeyword(
            argument1: 1,
            argument2: "string"
        )
    }
}

"""
                let rewriter = try RagnarokRewriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }
            
            try XCTContext.runActivity(named: "Test visit of TestFunctionCallExprforDiscardAssignment") { (activity) in
                let input = URL(string: TestFunctionCallExprforDiscardAssignment.file())!
                let expected = """
import Foundation

public class TestFunctionCallExprforDiscardAssignment: TestDatable {
    public static func file() -> String {
        return #file
    }
    func example() {
        let test = TestFunctionDeclHasReturnType()
        _ = test.noArgumentHasReturnKeyword()
        _ = test.oneArgumentHasReturnKeyword(argument: 1)
        _ = test.twoArgumentHasReturnKeyword(
            argument1: 1,
            argument2: "string"
        )
    }
}

"""
                let rewriter = try RagnarokRewriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }

        }
    }
    
    func testFormattedForFunctionDecl() throws {
        try XCTContext.runActivity(named: "Test visit of FunctionDeclSyntax") { (activity) in
            try XCTContext.runActivity(named: "Test visit of TestFunctionDeclHasClosureArgument") { (activity) in
                let input = URL(string: TestFunctionDeclHasClosureArgument.file())!
                let expected = """
import Foundation

public class TestFunctionDeclHasClosureArgument: TestDatable {
    public static func file() -> String {
        return #file
    }
    func closureNoEscaping(closure: () -> Void) {
        
    }
    func closureEscaping(closure: @escaping () -> Void) {
        
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

"""
                let rewriter = try RagnarokRewriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }
            
            try XCTContext.runActivity(named: "Test visit of TestFunctionDeclHasReturnType") { (activity) in
                let input = URL(string: TestFunctionDeclHasReturnType.file())!
                let expected = """
import Foundation

public class TestFunctionDeclHasReturnType: TestDatable {
    public static func file() -> String {
        return #file
    }
    func noArgumentHasReturnKeyword() -> Int? {
        return 1
    }
    func oneArgumentHasReturnKeyword(argument: Int) -> Int? {
        return 1
    }
    func twoArgumentHasReturnKeyword(
        argument1: Int,
        argument2: String
        ) -> Int? {
        return 1
    }
}

"""
                let rewriter = try RagnarokRewriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }
            
            try XCTContext.runActivity(named: "Test visit of TestFunctionDeclNoReturn") { (activity) in
                let input = URL(string: TestFunctionDeclNoReturn.file())!
                let expected = """
import Foundation

public class TestFunctionDeclNoReturn: TestDatable {
    public static func file() -> String {
        return #file
    }
    func noArgumentNoReturn() {
        
    }
    func oneArgumentNoReturn(argument: Int) {
        
    }
    func twoArgumentNoReturn(
        argument1: Int,
        argument2: String
        ) {
        
    }
}

"""
                let rewriter = try RagnarokRewriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }
            
            try XCTContext.runActivity(named: "Test visit of TestFunctionDeclUsingThrows") { (activity) in
                let input = URL(string: TestFunctionDeclUsingThrows.file())!
                let expected = """
import Foundation

public class TestFunctionDeclUsingThrows: TestDatable {
    public static func file() -> String {
        return #file
    }
    func noArgumentUsingThrowsKeyword() throws {
        
    }
    func oneArgumentUsingThrowsKeyword(argument1: Int) throws {
        
    }
    func multipleArgumentUsingThrowsKeyword(
        argument1: Int,
        argument2: String
        ) throws {
        
    }
}

"""
                let rewriter = try RagnarokRewriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }

            try XCTContext.runActivity(named: "Test visit of TestFunctionDeclMultipleLabel") { (activity) in
                let input = URL(string: TestFunctionDeclMultipleLabel.file())!
                let expected = """
import Foundation

public class TestFunctionDeclMultipleLabel: TestDatable {
    public static func file() -> String {
        return #file
    }
    
    func oneArgument(label1 argument1: Int) {
        
    }
    func multipleArgument(
        label1 argument1: Int,
        label2 argument2: String
        ) {
        
    }
}

"""
                let rewriter = try RagnarokRewriter(path: input)
                XCTAssertEqual(try rewriter.formatted(), expected)
            }


        }
    }
}
