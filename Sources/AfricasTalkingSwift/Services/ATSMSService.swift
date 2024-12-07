//
//  ATSMSService.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 06/12/2024.
//

import Foundation

protocol SMSService: Sendable {
    func sendBulkSMS(message: SMS) async throws -> SMSResponse
    func sendPremiumSMS(message: SMS) async throws -> SMSResponse
}

final class ATSMSService: SMSService {
    private let username: String
    private let apiKey: String
    private let environment: Environment
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient, username: String, apiKey: String, environment: Environment) {
        self.username = username
        self.apiKey = apiKey
        self.environment = environment
        self.networkClient = networkClient
    }

    func sendBulkSMS(message: SMS) async throws -> SMSResponse {
        var messageRequest = message
        messageRequest.username = username
        let body = try JSONEncoder().encode(messageRequest)
        return try await networkClient.request(url: environment.SMS_URL,
                                               method: .POST,
                                               body: body,
                                               task: .jsonEncoded,
                                               type: SMSResponse.self)
    }

    public func sendPremiumSMS(message: SMS) async throws -> SMSResponse {
        let body = [
            "username": username,
            "to": message.phoneNumbers.joined(separator: ","),
            "message": message.message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? message.message,
            "from": "username"
        ].map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)
        return try await networkClient.request(url: environment.PREMIUM_SMS_URL,
                                               method: .POST,
                                               body: body,
                                               task: .urlFormEncoded,
                                               type: SMSResponse.self)
    }
}
