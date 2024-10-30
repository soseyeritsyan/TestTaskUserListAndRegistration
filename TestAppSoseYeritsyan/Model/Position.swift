//
//  Position.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 26.10.24.
//


struct Position: Codable, Equatable {
    let id: Int
    let name: String
}

struct GetPositionsResponse: Codable {
    let success: Bool
    let positions: [Position]?
    let message: String?
}
