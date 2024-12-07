//
//  DecodingErrorHandler.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 05/12/2024.
//

import Foundation

func handleDecodingError(_ error: DecodingError) {
    switch error {
        case .typeMismatch(let type, let context):
            log.error("Type mismatch error: Expected type \(type) at \(context.codingPath). \(context.debugDescription)", metadata: [
                "type": .string(String(describing: type)),
                "codingPath": .string(context.codingPath.map(\.stringValue).joined(separator: ".")),
                "description": .string(context.debugDescription)
            ])
        case .valueNotFound(let type, let context):
            log.error("Value not found: Expected value of type \(type) at \(context.codingPath). \(context.debugDescription)", metadata: [
                "type": .string(String(describing: type)),
                "codingPath": .string(context.codingPath.map(\.stringValue).joined(separator: ".")),
                "description": .string(context.debugDescription)
            ])
        case .keyNotFound(let key, let context):
            log.error("Key not found: Missing key '\(key.stringValue)' at \(context.codingPath). \(context.debugDescription)", metadata: [
                "key": .string(key.stringValue),
                "codingPath": .string(context.codingPath.map(\.stringValue).joined(separator: ".")),
                "description": .string(context.debugDescription)
            ])
        case .dataCorrupted(let context):
            log.error("Data corrupted: \(context.debugDescription) at \(context.codingPath).", metadata: [
                "codingPath": .string(context.codingPath.map(\.stringValue).joined(separator: ".")),
                "description": .string(context.debugDescription)
            ])
        @unknown default:
            log.error("Unknown decoding error: \(error.localizedDescription)", metadata: [
                "description": .string(error.localizedDescription)
            ])
    }
}
