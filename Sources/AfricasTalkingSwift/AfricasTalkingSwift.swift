// The Swift Programming Language
// https://docs.swift.org/swift-book

final public class AfricasTalkingSwift: Sendable {
    private let atAirtimeService: AirtimeService
    private let atUserService: UserService
    private let atSMSService: SMSService

    public init(username: String, apiKey: String, environment: Environment = .production) {
        self.atAirtimeService = ATAirtimeService(username: username, apiKey: apiKey, environment: environment)
        self.atUserService = ATUserService(username: username, apiKey: apiKey, environment: environment)
        self.atSMSService = ATSMSService(username: username, apiKey: apiKey, environment: environment)
    }

    // SMS Service
    public func sendBulkSMS(message: SMS) async {
        do {
            try await atSMSService.sendBulkSMS(message: message)
        } catch {
            log.error("\(error.localizedDescription)")
        }
    }

    public func sendPremiumSMS(message: SMS) async {
        do {
            try await atSMSService.sendPremiumSMS(message: message)
        } catch {
            log.error("\(error.localizedDescription)")
        }
    }

    // USER
    public func fetchUserData() async {
        do {
            try await atUserService.fetchUserData()
        } catch {
            log.error("\(error.localizedDescription)")
        }
    }

    // AIRTIME
    public func sendAirtime(recipients: [Recipient]) async {
        do {
            try await atAirtimeService.sendAirtime(recipients: recipients)
        } catch {
            log.error("\(error.localizedDescription)")
        }
    }
}
