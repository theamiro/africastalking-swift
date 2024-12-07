//
//  ATAirtimeService.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 05/12/2024.
//

import Foundation

public protocol AirtimeService {
    var username: String { get }
    func sendAirtime(recipients: [Recipient]) async throws
}

final class ATAirtimeService: AirtimeService {
    var username: String
    var apiKey: String

    public init(username: String, apiKey: String) {
        self.username = username
        self.apiKey = apiKey
    }

    func sendAirtime(recipients: [Recipient]) async throws {
        guard let url = URL(string: "https://api.sandbox.africastalking.com/version1/airtime/send") else {
            throw AFNetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "apiKey")

        let bodyParameters = [
            "recipients": "[{\"phoneNumber\":\"+2547706664400\",\"amount\":\"KES 5.00\"}]",
            "maxNumRetry": "1",
            "username": username,
        ]
        let bodyString = bodyParameters.queryParameters
        request.httpBody = bodyString.data(using: .utf8, allowLossyConversion: true)
        log.info("\(request.curlString)")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            if let errorResponse = String(data: data, encoding: .utf8) {
                log.error("\(errorResponse)")
                return
            } else {
                return
            }
        }
        log.info("\(String(describing: String(data: data, encoding: .utf8)))")
        do {
            let airtimeResponse = try JSONDecoder().decode(AirtimeResponse.self, from: data)
            log.info("\(airtimeResponse)")
        } catch {
            if let decodingError = error as? DecodingError {
                handleDecodingError(decodingError)
            } else {
                throw error
            }
        }
    }
}
