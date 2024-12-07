//
//  ATUserService.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 05/12/2024.
//

import Foundation
import Logging

protocol UserService: Sendable {
    func fetchUserData() async throws
}

final class ATUserService: UserService {
    private let username: String
    private let apiKey: String
    private let environment: Environment
    
    init(username: String, apiKey: String, environment: Environment) {
        self.username = username
        self.apiKey = apiKey
        self.environment = environment
    }

    func fetchUserData() async throws {
        var components = URLComponents(url: environment.USER_URL, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "username", value: username)]
        guard let updatedURL = components?.url else {
            throw AFNetworkError.invalidURL
        }
        var request = URLRequest(url: updatedURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "apiKey")

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
        do {
            let airtimeResponse = try JSONDecoder().decode(UserResponse.self, from: data)
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
