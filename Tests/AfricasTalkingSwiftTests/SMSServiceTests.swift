//
//  SMSServiceTests.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 09/12/2024.
//

import XCTest
@testable import AfricasTalkingSwift

final class SMSServiceTests: XCTestCase {
    var sut: SMSService!

    var username: String = ""

    override func setUp() {
        super.setUp()
        sut = configureTest(&username)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSendingBulkSMS() async {
        let message = SMS(message: "Hello, world!", phoneNumbers: ["+2546700000000"])
        do {
            let response = try await sut.sendBulkSMS(message: message)
            XCTAssertEqual(response.SMSMessageData.Recipients.count, 1)
            XCTAssertEqual(response.SMSMessageData.Recipients.first?.statusCode, .processed)
        } catch {
            XCTFail("Send airtime request failing")
            log.error("\(error.localizedDescription)")
        }
    }

    private func configureTest(_ username: inout String, apiKey: String = "key") -> SMSService {
        let networkClient = NetworkClient(apiKey: apiKey, stubClosure: .immediatelyStub)
        return ATSMSService(networkClient: networkClient, username: username, apiKey: apiKey, environment: .production)
    }
}
