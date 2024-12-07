//
//  UserResponse.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 05/12/2024.
//

struct UserResponse: Decodable, Sendable {
    let data: Balance
    
    enum CodingKeys: String, CodingKey {
        case data = "UserData"
    }
}

struct Balance: Decodable, Sendable {
    let balance: String

    var currency: String {
        "\(balance.split(separator: " ").first!)".uppercased()
    }
}
