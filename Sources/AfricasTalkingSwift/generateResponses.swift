//
//  generateResponses.swift
//  AfricasTalkingSwift
//
//  Created by Michael Amiro on 09/12/2024.
//

import Foundation

func generateSampleResponses(_ resource: String, withExtension `extension`: String = "json") -> Data {
    guard let url = Bundle.module.url(forResource: resource, withExtension: `extension`) else {
        return Data()
    }
    do {
        return try Data(contentsOf: url)
    } catch {
        log.error("Error loading \(resource).json: \(error.localizedDescription)")
        return Data()
    }
}
