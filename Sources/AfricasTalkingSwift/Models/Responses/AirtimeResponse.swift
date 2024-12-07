//
//  AirtimeResponse.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 07/12/2024.
//

import Foundation

public struct AirtimeResponse: Decodable, Sendable {
    public let errorMessage: String
    public let numSent: Int
    public let totalAmount: String
    public let totalDiscount: String
    public let responses: [RecipientResponse]
}

public struct RecipientResponse: Decodable, Sendable {
    public let phoneNumber: String
    public let errorMessage: String
    public let amount: String
    public let status: String
    public let requestId: String
    public let discount: String
}
