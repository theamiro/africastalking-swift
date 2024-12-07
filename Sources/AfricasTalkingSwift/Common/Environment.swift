//
//  Environment.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 05/12/2024.
//
import Foundation

public enum Environment: Sendable {
    case sandbox
    case production

    private var baseURL: String {
        switch self {
            case .sandbox:
                return "https://api.sandbox.africastalking.com/version1"
            case .production:
                return "https://api.africastalking.com/version1"
        }
    }

    var AIRTIME_URL: URL {
        URL(string: "\(baseURL)/airtime/send")!
    }

    var SMS_URL: URL {
        URL(string: "\(baseURL)/messaging/bulk")!
    }

    var PREMIUM_SMS_URL: URL {
        URL(string: "\(baseURL)/messaging")!
    }

    var USER_URL: URL {
        URL(string: "\(baseURL)/user")!
    }
}

enum Constants {
    static let sandboxUsername = "sandbox"
}
