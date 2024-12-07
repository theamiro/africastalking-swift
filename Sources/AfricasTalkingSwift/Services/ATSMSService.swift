//
//  ATSMSService.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 06/12/2024.
//

import Foundation

protocol SMSService: Sendable {
    func sendBulkSMS(message: SMS) async throws
    func sendPremiumSMS(message: SMS) async throws
}

final class ATSMSService: SMSService {
    private let username: String
    private let apiKey: String
    private let environment: Environment

    init(username: String, apiKey: String, environment: Environment) {
        self.username = username
        self.apiKey = apiKey
        self.environment = environment
    }

    func sendBulkSMS(message: SMS) async throws {
        var request = URLRequest(url: environment.SMS_URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(apiKey, forHTTPHeaderField: "apiKey")
        do {
            let body = try JSONEncoder().encode(message)
            request.httpBody = body
        } catch {
            throw AFNetworkError.encodingError
        }
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
            let airtimeResponse = try JSONDecoder().decode(SMSResponse.self, from: data)
            log.info("\(airtimeResponse)")
        } catch {
            if let decodingError = error as? DecodingError {
                handleDecodingError(decodingError)
            } else {
                throw error
            }
        }
    }
    
    public func sendPremiumSMS(message: SMS) async throws {
        var request = URLRequest(url: environment.PREMIUM_SMS_URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "apiKey")

        let parameters: [String: String] = [
            "username": username,
            "to": message.phoneNumbers.joined(separator: ","),
            "message": message.message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? message.message,
            "from": "username"
        ]

        request.httpBody = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)

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
            let airtimeResponse = try JSONDecoder().decode(SMSResponse.self, from: data)
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
