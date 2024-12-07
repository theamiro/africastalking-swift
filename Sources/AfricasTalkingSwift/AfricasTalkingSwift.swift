// The Swift Programming Language
// https://docs.swift.org/swift-book

final public class AfricasTalkingSwift: Sendable {
    private let atAirtimeService: AirtimeService
    private let atUserService: UserService
    private let atSMSService: SMSService

    public init(username: inout String, apiKey: String, environment: Environment = .production) {
        username = environment == .sandbox ? Constants.sandboxUsername : username
        self.atAirtimeService = ATAirtimeService(networkClient: NetworkClient(apiKey: apiKey),
                                                 username: username,
                                                 apiKey: apiKey,
                                                 environment: environment)
        self.atUserService = ATUserService(networkClient: NetworkClient(apiKey: apiKey),
                                           username: username,
                                           apiKey: apiKey,
                                           environment: environment)
        self.atSMSService = ATSMSService(networkClient: NetworkClient(apiKey: apiKey),
                                         username: username,
                                         apiKey: apiKey,
                                         environment: environment)
    }

    // SMS Service
    public func sendBulkSMS(message: SMS) async throws -> SMSResponse {
        try await atSMSService.sendBulkSMS(message: message)
    }

    public func sendPremiumSMS(message: SMS) async throws -> SMSResponse {
        try await atSMSService.sendPremiumSMS(message: message)
    }

    // USER
    public func fetchUserData() async throws -> UserResponse {
        try await atUserService.fetchUserData()
    }

    // AIRTIME
    public func sendAirtime(recipients: [Recipient]) async throws -> AirtimeResponse {
        try await atAirtimeService.sendAirtime(recipients: recipients)
    }
}
