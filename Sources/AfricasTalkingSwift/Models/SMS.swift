//
//  SMS.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 07/12/2024.
//

import Foundation

public struct SMS: Encodable, Sendable {
    public var username: String?
    public let message: String
    public let senderId: String = ""
    public let phoneNumbers: [String]

    public init(message: String, phoneNumbers: [String]) {
        self.message = message
        self.phoneNumbers = phoneNumbers.map { $0.addingPercentEncoding(withAllowedCharacters: .decimalDigits) ?? $0 }
    }
}
