// The Swift Programming Language
// https://docs.swift.org/swift-book

final public class AfricasTalkingSwift {
    @MainActor public static let shared = AfricasTalkingSwift()
    public var atAirtimeService: AirtimeService
    public var atUserService: UserService
    public var atSMSService: SMSService

    private init(atAirtimeService: AirtimeService = ATAirtimeService(username: "username"),
                 atUserService: UserService = ATUserService(), atSMSService: SMSService = ATSMSService()) {
        self.atAirtimeService = atAirtimeService
        self.atUserService = atUserService
        self.atSMSService = atSMSService
    }
}
