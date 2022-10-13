//
//  LoginService.swift
//  EmpBook
//
//  Created by A118830248 on 10/10/22.
//

import Foundation

protocol LoginServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void)
}

class LoginService: LoginServiceProtocol {
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        do {
            let request = try APIRoute.login(loginRequest: ["email": email, "password": password]).asURLRequest()
            APIManager.shared.performRequest(request: request, responseType: LoginResponse.self,  completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}

final class APIManager {
    
    private init() {}
    
    static let shared = APIManager()
    
    func performRequest<T: Decodable>(request: URLRequest, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("bad response: \(error ?? URLError(.badServerResponse))")
                return completion(.failure(error ?? URLError(.badServerResponse)))
            }
            guard 200 ..< 300 ~= response.statusCode else {
                print("statusCode != 2xx; \(response.statusCode)")
                return completion(.failure(NetworkErrors.InvalidResponse))
            }
            guard !data.isEmpty else {
                return completion(.failure(NetworkErrors.InvalidResponse))
            }
            do {
                let decoded = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decoded))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
