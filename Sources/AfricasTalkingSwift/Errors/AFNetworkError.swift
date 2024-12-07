//
//  AFNetworkError.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 07/12/2024.
//

import Foundation

enum AFNetworkError: LocalizedError {
    case invalidURL
    case invalidResponseCode
    case encodingError
    case custom(_ message: String)
}
