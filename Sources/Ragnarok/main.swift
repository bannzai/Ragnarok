import Foundation
import RagnarokCore

print("start --- ")
let arguments = ProcessInfo.processInfo.arguments
print(arguments)
let path = arguments[1]
print("path: \(path)")

try! FunctionDeclArgumentsReWriter(path: path).exec()

exit(0)
