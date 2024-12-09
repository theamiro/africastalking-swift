import XCTest
@testable import AfricasTalkingSwift

final class AirtimeServiceTests: XCTestCase {
    var sut: AirtimeService!

    var username: String = ""

    override func setUp() {
        super.setUp()
        sut = configureTest(&username)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSendingAirtime() async {
        let recipients = [Recipient(phoneNumber: "+254706664400", amount: "KES 2.00")]
        do {
            let response = try await sut.sendAirtime(recipients: recipients)
            XCTAssertEqual(response.errorMessage, "None")
            XCTAssertEqual(response.numSent, 1)
        } catch {
            XCTFail("Send airtime request failing")
            log.error("\(error.localizedDescription)")
        }
    }

    private func configureTest(_ username: inout String, apiKey: String = "key") -> AirtimeService {
        let networkClient = NetworkClient(apiKey: apiKey, stubClosure: .immediatelyStub)
        return ATAirtimeService(networkClient: networkClient, username: username, apiKey: apiKey, environment: .production)
    }
}
