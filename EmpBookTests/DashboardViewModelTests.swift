//
//  DashboardViewModelTests.swift
//  EmpBookTests
//
//  Created by A118830248 on 10/10/22.
//

import XCTest
@testable import EmpBook

class DashboardViewModelTests: XCTestCase {
    var sut: DashboardViewModel!
    let mock = MockUserRepository()
    
    override func setUp() {
        super.setUp()
        sut = DashboardViewModel(repository: mock)
    }

    func testGetEmployeesSuccess() throws {
        //given
        mock.isSuccess = true
        let input = [Employee(id: 1)]
        mock.employees = input
        
        sut.reloadCallBack = {
            //then
            XCTAssertEqual(self.sut.dataSource.first?.id, input.first?.id, "value should match")
        }
        
        //when
        sut.getEmployees()
    }
    
    func testGetEmployeesFailure() throws {
        //given
        mock.isSuccess = false
        let input = CustomError.noData
        mock.error = input
        
        sut.apiError = { errorMessage in
            //then
            XCTAssertEqual(errorMessage, input.localizedDescription, "value should match")
        }
        
        //when
        sut.getEmployees()
    }

    func testSort() {
        sut.employees = [Employee(firstName:"PQR"), Employee(firstName: "ABC")]
        sut.reloadCallBack = {
            //then
            XCTAssertEqual(self.sut.dataSource.first?.firstName, "ABC", "value should match")
        }
        sut.sort(type: .name)
    }
    
    func testSortByAddress() {
        sut.employees = [Employee(address:"PQR"), Employee(address: "ABC")]
        sut.reloadCallBack = {
            //then
            XCTAssertEqual(self.sut.dataSource.first?.address, "ABC", "value should match")
        }
        sut.sort(type: .address)
    }
    
    func testSortBySalary() {
        sut.employees = [Employee(salary: "70000"), Employee(address: "60000")]
        sut.reloadCallBack = {
            //then
            XCTAssertEqual(self.sut.dataSource.first?.salary, "60000", "value should match")
        }
        sut.sort(type: .salary)
    }
    
    func testSortByHireDate() {
        sut.employees = [Employee(hireDate: "2022-08-10"), Employee(hireDate: "1998-08-09")]
        sut.reloadCallBack = {
            //then
            XCTAssertEqual(self.sut.dataSource.first?.hireDate, "2022-08-09", "value should match")
        }
        sut.sort(type: .date)
    }
}

class MockUserRepository: UserRepositoryProtocol {
    var employees: [Employee] = []
    var error: Error = NSError()
    var isSuccess = false
    
    func getEmployees(completion: @escaping (Result<[Employee], Error>) -> Void) {
        if isSuccess {
            completion(.success(employees))
        } else {
            completion(.failure(error))
        }
    }
    
    func logout() {}
}
