import Foundation
import RagnarokCore

print("start --- ")
let arguments = ProcessInfo.processInfo.arguments
print(arguments)
let path = arguments[1]
print("path: \(path)")

do {
    try FunctionDeclArgumentsReWriter(path: path).exec()
} catch {
    print(error.localizedDescription)
    exit(1)
}

exit(0)
