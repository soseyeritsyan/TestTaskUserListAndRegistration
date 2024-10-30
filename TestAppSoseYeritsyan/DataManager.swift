//
//  DataManager.swift
//  TestAppSoseYeritsyan
//
//  Created by sose yeritsyan on 26.10.24.
//

import UIKit


class DataManager {
    private let baseUrl = "https://frontend-test-assignment-api.abz.agency/api/v1"
    private let positionPath = "/positions"
    private let registerPath = "/users"
    private let tokenPath = "/token"
    
    static let shared = DataManager()
    
    func fetchUsers(url: String? = nil, page: Int = 1, count: Int = 6, completion: @escaping (Result<UsersResponse, Error>) -> Void) {
        let urlString: String
        if let url = url {
            urlString = url
        } else {
            urlString = "https://frontend-test-assignment-api.abz.agency/api/v1/users?page=\(page)&count=\(count)"
        }

        guard let requestURL = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                let usersResponse = try JSONDecoder().decode(UsersResponse.self, from: data)
                completion(.success(usersResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    
    func getPositions(completion: @escaping (Result<GetPositionsResponse, Error>) -> Void) {
        // Define the URL
        let urlString = baseUrl + positionPath
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create a data task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                let decoder = JSONDecoder()
                let response = try decoder.decode(GetPositionsResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the task
        task.resume()
    }
    
    func registerUser(
        name: String,
        email: String,
        phone: String,
        positionID: Int,
        photo: UIImage,
        completion: @escaping (Result<RegisterUserResponse, Error>) -> Void
    ) {
        getToken { result in
            switch result {
            case .success(let token):
                self.performRegistration(
                    name: name,
                    email: email,
                    phone: phone,
                    positionID: positionID,
                    photo: photo,
                    token: token,
                    completion: completion
                )
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func performRegistration(
        name: String,
        email: String,
        phone: String,
        positionID: Int,
        photo: UIImage,
        token: String,
        completion: @escaping (Result<RegisterUserResponse, Error>) -> Void
    ) {
        // Define the URL
        let urlString = baseUrl + registerPath
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the multipart form data body
        let boundary = UUID().uuidString
        var body = Data()
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "Token")
        
        
        // Append form fields
        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "phone": phone,
            "position_id": "\(positionID)"
        ]
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Append the photo
        if let imageData = photo.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // Create a data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(jsonString)")
                }
                let decoder = JSONDecoder()
                let response = try decoder.decode(RegisterUserResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the task
        task.resume()
    }

    

    
    private func getToken(completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = baseUrl + tokenPath
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tokenResponse = try decoder.decode(TokenResponse.self, from: data)
                if let token = tokenResponse.token, tokenResponse.success {
                    completion(.success(token))
                } else {
                    let errorMessage = tokenResponse.success ? "Token not found" : "Failed to fetch token"
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
    }
}
