//
//  EmployeeService.swift
//  EmpBook
//
//  Created by A118830248 on 11/10/22.
//

import Foundation
protocol EmployeeServiceProtocol {
    func getEmployees(completion: @escaping (Result<EmployeeResponse, Error>) -> Void)
}

class EmployeeService: EmployeeServiceProtocol {
    func getEmployees(completion: @escaping (Result<EmployeeResponse, Error>) -> Void) {
        do {
            let request = try APIRoute.getEmployees.asURLRequest()
            APIManager.shared.performRequest(request: request, responseType: EmployeeResponse.self,  completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
}
