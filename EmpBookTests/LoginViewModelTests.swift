//
//  LoginViewModelTests.swift
//  EmpBookTests
//
//  Created by A118830248 on 13/10/22.
//

import XCTest
@testable import EmpBook

class LoginViewModelTests: XCTestCase {

    var sut: LoginViewModel!
    let mockService = MockLoginService()
    let mockStorage = MockStorage()
    
    override func setUp() {
        super.setUp()
        sut = LoginViewModel(service: mockService, storage: mockStorage)
    }

    func testLoginSuccess() throws {
        //given
        mockService.isSuccess = true
        
        sut.loginSuccess = {
            //then
            XCTAssertTrue(self.sut.loginSucceed, "value should true")
        }
        
        //when
        sut.login(email: "abcd", password: "pqr")
    }
    
    func testLoginFailure() throws {
        //given
        mockService.isSuccess = false
        let input = CustomError.noData
        mockService.error = input
        
        sut.loginError = { errorMessage in
            //then
            XCTAssertEqual(errorMessage, input.localizedDescription, "value should match")
        }
        
        //when
        sut.login(email: "abcd", password: "pqrs")
    }

}

class MockLoginService: LoginServiceProtocol {
    
    var loginResponse: LoginResponse = LoginResponse(access: "abcd")
    var error: Error = CustomError.noData
    var isSuccess = false
    
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        if isSuccess {
            completion(.success(loginResponse))
        } else {
            completion(.failure(error))
        }
    }
}

class MockStorage: StorageProtocol {
    
    var isSuccess = false
    
    func saveLoginResponse(response: LoginResponse) throws {
    }
    
    func saveEmployees(response: [Employee]) throws {
    }
    
}
