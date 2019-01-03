import Foundation
import RagnarokCore

print("start --- ")
let arguments = ProcessInfo.processInfo.arguments
print(arguments)
let path = arguments.first!

try! FunctionDeclArgumentsReWriter(path: path).done()
