//
//  UserResponse.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 05/12/2024.
//

public struct UserResponse: Decodable, Sendable {
    let data: Balance

    enum CodingKeys: String, CodingKey {
        case data = "UserData"
    }
}

public struct Balance: Decodable, Sendable {
    public let balance: String

    public var currency: String {
        "\(balance.split(separator: " ").first!)".uppercased()
    }
}
