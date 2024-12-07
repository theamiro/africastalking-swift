//
//  AirtimeResponse.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 07/12/2024.
//

import Foundation

struct AirtimeResponse: Decodable, Sendable {
    let errorMessage: String
    let numSent: Int
    let totalAmount: String
    let totalDiscount: String
    let responses: [RecipientResponse]
}

struct RecipientResponse: Decodable, Sendable {
    let phoneNumber: String
    let errorMessage: String
    let amount: String
    let status: String
    let requestId: String
    let discount: String
}
