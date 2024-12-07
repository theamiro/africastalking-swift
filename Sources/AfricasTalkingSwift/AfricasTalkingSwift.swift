// The Swift Programming Language
// https://docs.swift.org/swift-book

final public class AfricasTalkingSwift {
    public var atAirtimeService: AirtimeService
    public var atUserService: UserService
    public var atSMSService: SMSService

    public init(username: String, apiKey: String) {
        self.atAirtimeService = ATAirtimeService(username: username, apiKey: apiKey)
        self.atUserService = ATUserService(username: username, apiKey: apiKey)
        self.atSMSService = ATSMSService(username: username, apiKey: apiKey)
    }
}
