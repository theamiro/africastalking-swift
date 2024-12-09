//
//  NetworkClient.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 07/12/2024.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
}

enum StubClosure {
    case never
    case immediatelyStub
}

final class NetworkClient: Sendable {
    private let apiKey: String
    private let stubClosure: StubClosure

    init(apiKey: String, stubClosure: StubClosure = .never) {
        self.apiKey = apiKey
        self.stubClosure = stubClosure
    }

    func request<T>(url: URL,
                    method: HTTPMethod = .GET,
                    body: Data? = nil,
                    sampleData: Data = Data(),
                    task: NetworkTask = .urlFormEncoded,
                    type: T.Type) async throws -> T where T: Decodable {
        var request = URLRequest(url: url)
        switch task {
        case .urlFormEncoded:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .jsonEncoded:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .queryParameters(let queryItems):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            guard let updatedURL = components?.url else {
                throw AFNetworkError.invalidURL
            }
            request = URLRequest(url: updatedURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }

        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        request.setValue(apiKey, forHTTPHeaderField: "apiKey")

        switch method {
            case .GET: break
            default: request.httpBody = body
        }

        log.info("\(request.curlString)")

        var responseData: Data
        switch stubClosure {
            case .never:
                let (data, response) = try await URLSession.shared.data(for: request)
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    if let errorResponse = String(data: data, encoding: .utf8) {
                        log.error("\(errorResponse)")
                        throw AFNetworkError.custom(errorResponse)
                    } else {
                        log.error("An error occurred")
                        throw AFNetworkError.custom("An error occurred")
                    }
                }
                responseData = data
            case .immediatelyStub:
                responseData = sampleData
        }
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: responseData)
            log.info("\(decodedData)")
            return decodedData
        } catch {
            if let decodingError = error as? DecodingError {
                handleDecodingError(decodingError)
                throw AFNetworkError.custom(decodingError.localizedDescription)
            } else {
                throw error
            }
        }
    }
}


enum NetworkTask {
    case urlFormEncoded
    case jsonEncoded
    case queryParameters([URLQueryItem])
}
