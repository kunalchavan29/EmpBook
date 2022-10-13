//
//  LoginViewModel.swift
//  EmpBook
//
//  Created by A118830248 on 10/10/22.
//

import Foundation

enum LoginState {
    case ready
    case loading
}

class LoginViewModel {
    var service: LoginServiceProtocol
    var storage: StorageProtocol
    var loginSucceed = false
    var loginSuccess: (() -> Void)?
    var loginError: ((String) -> Void)?
    var loginState: ((LoginState) -> Void)?
    
    init(service: LoginServiceProtocol, storage: StorageProtocol) {
        self.service = service
        self.storage = storage
    }
    
    func login(email: String, password: String) {
        loginState?(.loading)
        service.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async { self?.loginState?(.ready) }
            switch result {
            case .success(let loginResponse):
                self?.loginSucceed = true
                self?.cacheLoginResponse(loginResponse: loginResponse)
                DispatchQueue.main.async { self?.loginSuccess?() }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { self?.loginError?(error.localizedDescription) }
            }
        }
    }
    
    private func cacheLoginResponse(loginResponse: LoginResponse) {
        do {
            try storage.saveLoginResponse(response: loginResponse)
        } catch {
            print(error)
        }
    }
}
