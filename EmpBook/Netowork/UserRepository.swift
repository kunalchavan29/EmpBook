//
//  UserRepository.swift
//  EmpBook
//
//  Created by A118830248 on 12/10/22.
//

import Foundation

protocol UserRepositoryProtocol {
    func getEmployees(completion: @escaping (Result<[Employee], Error>) -> Void)
    func logout()
}

class UserRepository: UserRepositoryProtocol {
    var service: EmployeeServiceProtocol
    
    init(service: EmployeeServiceProtocol) {
        self.service = service
    }
    
    func getEmployees(completion: @escaping (Result<[Employee], Error>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            completion(.success(DatabaseManager.shared.getEmployees()))
        } else {
            service.getEmployees { [weak self] result in
                switch result {
                case .success(let employee):
                    completion(.success(employee.results ?? []))
                    self?.saveEmployeeToDatabase(employees: employee.results ?? [])
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func saveEmployeeToDatabase(employees: [Employee]) {
        do {
            try DatabaseManager.shared.saveEmployees(response: employees)
        } catch {
            print(error)
        }
    }
    
    func logout() {
        DatabaseManager.shared.logOut()
    }
}
