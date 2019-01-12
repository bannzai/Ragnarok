//
//  FileFinder.swift
//  RagnarokCore
//
//  Created by Yudai.Hirose on 2019/01/12.
//

import Foundation

public protocol FileFinder {
    func isNotExists(at path: String) -> Bool
}


public struct FileFinderImpl: FileFinder {
    public func isNotExists(at path: String) -> Bool {
        return !FileManager.default.fileExists(atPath: path)
    }
    
    public init() {
        
    }
}
