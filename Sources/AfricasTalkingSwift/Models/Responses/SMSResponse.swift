//
//  SMSResponse.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 07/12/2024.
//

import Foundation

public struct SMSResponse: Decodable, Sendable {
    public let SMSMessageData: MessageData
    public struct MessageData: Decodable, Sendable {
        public let Message: String
        public let Recipients: [SMSRecipient]
    }
    public struct SMSRecipient: Decodable, Sendable {
        public let statusCode: SMSStatusCode
        public let number: String
        public let status: String
        public let cost: String
        public let messageId: String
    }
}

public enum SMSStatusCode: Int, Decodable, Sendable {
    case processed = 100
    case sent = 101
    case queued = 102
    case riskHold = 401
    case invalidSenderId = 402
    case invalidPhoneNumber = 403
    case unsupportedNumberType = 404
    case insufficientBalance = 405
    case userInBlacklist = 406
    case couldNotRoute = 407
    case doNotDisturbRejection = 409
    case internalServerError = 500
    case gatewayError = 501
    case rejectedByGateway = 502
    
    var localizedDescription: String {
        switch self {
            case .processed:
                return "Message processed successfully."
            case .sent:
                return "Message sent successfully."
            case .queued:
                return "Message queued for delivery."
            case .riskHold:
                return "Message flagged for risk review."
            case .invalidSenderId:
                return "Invalid sender ID."
            case .invalidPhoneNumber:
                return "Invalid phone number."
            case .unsupportedNumberType:
                return "Unsupported number type."
            case .insufficientBalance:
                return "Insufficient account balance."
            case .userInBlacklist:
                return "Recipient is in the blacklist."
            case .couldNotRoute:
                return "Message could not be routed."
            case .doNotDisturbRejection:
                return "Message rejected due to DND settings."
            case .internalServerError:
                return "Internal server error occurred."
            case .gatewayError:
                return "Error with the gateway."
            case .rejectedByGateway:
                return "Message rejected by the gateway."
        }
    }
}
