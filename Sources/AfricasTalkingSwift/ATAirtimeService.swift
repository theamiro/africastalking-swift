//
//  ATAirtimeService.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 05/12/2024.
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

enum AFNetworkError: LocalizedError {
    case invalidURL
    case invalidResponseCode
    case encodingError
}

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

extension String {
    func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
    
}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
     */
    func appendingQueryParameters(_ parametersDictionary : Dictionary<String, String>) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}

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
