//
//  RegisterUserResponse.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 26.10.24.
//

import Foundation

struct RegisterUserResponse: Codable {
    let success: Bool
    let user_id: Int?
    let message: String
    let fails: [String: [String]]?
}
