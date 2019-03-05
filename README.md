# Ragnarok
Remake of destiny.

## Introduction
**Ragnarok** rewrite swift file library.  
If you have `TestFunctionCallExprInGuard.swift`  

```swift
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
        guard let c = test.twoArgumentHasReturnKeyword(argument1: 1, argument2: "string") else {
            return
        }

        print(a,b,c)
    }
}
```

And execute **Ragnarok**.  
```bash
$ ragnarok ./TestFunctionCallExprInGuard.swift
```

You can see that each line of a function with two or more arguments is followed by a carriage return.  
It can be said that remake of destiny.  

```swift
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
```

## Why Ragnarok??
This project for I wanted to use [SwiftSyntax](https://github.com/apple/swift-syntax) with curiosity.  
The name Ragnarok has no meaning. I just took it for saying. Same as `remake of destiny`.  
The **Ragnarok** godparent is [gaopin](https://github.com/gaopin1534). [Reference](https://twitter.com/gaopin1534/status/1080711008237154304)

## License
**Ragnarok** is available under the MIT license.   
See the [LICENSE](./LICENSE) file for more info.    
