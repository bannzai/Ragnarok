//
//  RagnarokCoreErrorType.swift
//  RagnarokCore
//
//  Created by Yudai.Hirose on 2019/01/12.
//

import Foundation


public enum RagnarokCoreErrorType: Error {
    case missingFilePath(path: String)
    
    var localizedDescription: String {
        switch self {
        case .missingFilePath(let path):
            return "Can not find swift file at \(path)"
        }
    }
}
