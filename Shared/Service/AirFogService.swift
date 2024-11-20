//
//  AirFogService.swift
//  AirGuard (iOS)
//
//  Created by Leonid Liadveikin on 04.11.24.
//

import Foundation

actor AirFogService {
    
    let apiKey: String = "104d5355-f202-4793-afa9-c30c8b946303"
    let baseURL: String = "https://airfog-backend.onrender.com/relay-ble"
    
    private lazy var jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    func fetchAirFog() async throws -> AirFog {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = ["x-api-key": apiKey]
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(AirFog.self, from: data)
    }
    
    func postAirFog(_ airFog: AirFog) async throws {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try jsonEncoder.encode(airFog)
        request.allHTTPHeaderFields = ["x-api-key": apiKey]
        let (data, _) = try await URLSession.shared.data(for: request)
        print(String(data: data, encoding: .utf8))
    }
}
