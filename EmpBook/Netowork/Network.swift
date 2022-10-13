//
//  NetworkConstants.swift
//  EmpBook
//
//  Created by A118830248 on 11/10/22.
//

import Foundation

struct NetworkConstant {
    static let baseUrl = "https://api.equation.consolebit.com/api"
}

public enum CustomError: Error {
    case noData
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData:
            return NSLocalizedString("Invalid response", comment: "")
        }
    }
}

enum APIRoute {
    case login(loginRequest: [String: Any])
    case getEmployees
    
    var method: String {
        switch self {
        case .login:
            return "POST"
        case .getEmployees:
            return "GET"
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/v1/auth/login/"
        case .getEmployees:
            return "/v1/testing/employee/"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .login(let loginRequest):
            return loginRequest
        case .getEmployees:
            return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        
        let url = try (NetworkConstant.baseUrl + path).toURL()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
                
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = DatabaseManager.shared.accessToken {
            urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        }
        
        if let parameters = parameters {
            switch method {
            case "GET":
                urlRequest = try queryEncode(urlRequest, with: parameters)
            default:
                urlRequest = try jsonEncode(urlRequest, with: parameters)
            }
        }
        return urlRequest
    }
}

public func queryEncode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {
    guard let parameters = parameters else { return urlRequest }
    var urlRequest = urlRequest
    
    var components = URLComponents()
    components.queryItems = parameters.map {
         URLQueryItem(name: $0, value: "\($1)")
    }
    let encoded = components.url
    urlRequest.url = encoded
    return urlRequest
}

public func jsonEncode(_ urlRequest: URLRequest, with parameters: [String: Any]?) throws -> URLRequest {
    guard let parameters = parameters else { return urlRequest }
    var urlRequest = urlRequest

    do {
        let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        urlRequest.httpBody = data
    } catch {
        throw error
    }
    return urlRequest
}

extension String {
    public func toURL() throws -> URL {
        guard let url = URL(string: self) else { throw  NetworkErrors.InvalidURL }
        return url
    }
}

enum NetworkErrors: Error {
    case InvalidURL
    case InvalidResponse
}
