//
//  AirFog.swift
//  AirGuard (iOS)
//
//  Created by Leonid Liadveikin on 04.11.24.
//

import Foundation

struct AirFog: Codable {
    let deviceId: UUID
    let macAddress: String?
    let location: AirLocation
    let advertisementData: Data
}

// MARK: - Location
struct AirLocation: Codable {
    let latitude, longitude: Double
}
