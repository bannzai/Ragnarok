//
//  TestDatable.swift
//  RagnarokCoreTests
//
//  Created by Yudai.Hirose on 2019/01/13.
//

import Foundation

public protocol TestDatable {
    static func file() -> String
    static func expected() -> String
    
    func example()
}
