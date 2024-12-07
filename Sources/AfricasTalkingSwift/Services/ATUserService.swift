//
//  ATUserService.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 05/12/2024.
//

import Foundation
import Logging

protocol UserService: Sendable {
    func fetchUserData() async throws -> UserResponse
}

final class ATUserService: UserService {
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

    func fetchUserData() async throws -> UserResponse {
        let parameters = [URLQueryItem(name: "username", value: username)]
        return try await networkClient.request(url: environment.USER_URL,
                                               task: .queryParameters(parameters),
                                               type: UserResponse.self)
    }
}
