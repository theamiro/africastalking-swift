//
//  Recipient.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 07/12/2024.
//

import Foundation

public struct Recipient: Encodable, Sendable {
    public let phoneNumber: String
    public let amount: String

    public init(phoneNumber: String, amount: String) {
        self.phoneNumber = phoneNumber
        self.amount = amount
    }
}
