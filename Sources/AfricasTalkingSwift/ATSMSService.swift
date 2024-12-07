//
//  ATSMSService.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 06/12/2024.
//

import Foundation

public protocol SMSService {
    func sendBulkSMS(message: SMS) async throws
    func sendPremiumSMS(message: SMS) async throws
}

public struct SMS: Encodable, Sendable {
    public let username: String = "username"
    public let message: String
    public let senderId: String = ""
    public let phoneNumbers: [String]

    public init(message: String, phoneNumbers: [String]) {
        self.message = message
        self.phoneNumbers = phoneNumbers.map { $0.addingPercentEncoding(withAllowedCharacters: .decimalDigits) ?? $0 }
    }
}

public final class ATSMSService: SMSService {
    public func sendBulkSMS(message: SMS) async throws {
        guard let url = URL(string: "https://api.africastalking.com/version1/messaging/bulk") else {
            throw AFNetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("token", forHTTPHeaderField: "apiKey")
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
        guard let url = URL(string: "https://api.africastalking.com/version1/messaging") else {
            throw AFNetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("token", forHTTPHeaderField: "apiKey")

        let parameters: [String: String] = [
            "username": "username",
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
