//
//  ATAirtimeService.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 05/12/2024.
//

import Foundation

protocol AirtimeService: Sendable {
    @Sendable func sendAirtime(recipients: [Recipient]) async throws -> AirtimeResponse
}

final class ATAirtimeService: AirtimeService {
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

    func sendAirtime(recipients: [Recipient]) async throws -> AirtimeResponse {
        let bodyParameters = [
            "recipients": "[{\"phoneNumber\":\"+2547706664400\",\"amount\":\"KES 5.00\"}]",
            "maxNumRetry": "1",
            "username": username,
        ]
        let body = bodyParameters.queryParameters.data(using: .utf8, allowLossyConversion: true)
        return try await networkClient.request(url: environment.AIRTIME_URL,
                                               method: .POST,
                                               body: body,
                                               sampleData: generateSampleResponses("airtimeResponse"),
                                               type: AirtimeResponse.self)
    }
}
