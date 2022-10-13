//
//  Employee.swift
//  EmpBook
//
//  Created by A118830248 on 11/10/22.
//

import Foundation
import CoreData
// MARK: - Welcome
struct EmployeeResponse: Codable {
    let count: Int
    let results: [Employee]?
}

// MARK: - Result
struct Employee: Codable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var email: String?
    var dob, hireDate: String?
    var address: String?
    var city: String?
    var zipCode: String?
    var country: String?
    var phone: String?
    var photo: String?
    var salary: String?
    var designation: String?
    var organizationName: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, dob
        case hireDate = "hire_date"
        case address, city
        case zipCode = "zip_code"
        case country, phone, photo, salary, designation
        case organizationName = "organization_name"
        case status
    }
}

extension Employee {
    var fullName: String {
        return (firstName ?? "") + (lastName ?? "")
    }
    
    static  let dateFormatter: DateFormatter = {
        let formatter =  DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
    
    var dateFromString: Date  {
        let  dateString = hireDate ?? ""
        return  Employee.dateFormatter.date(from: dateString) ?? Date.distantPast
    }
}

extension Employee {
    func mapToMO(employeeMO: EmployeeMO) -> EmployeeMO {
        employeeMO.id = Int64(self.id ?? 0)
        employeeMO.firstName = self.firstName
        employeeMO.lastName = self.lastName
        employeeMO.email = self.email
        employeeMO.dob = self.dob
        employeeMO.hireDate = self.hireDate
        employeeMO.address = self.address
        employeeMO.city = self.city
        employeeMO.photo = self.photo
        employeeMO.salary = self.salary
        employeeMO.status = self.status
        return employeeMO
    }
    
    mutating func mapFromMO(employee: EmployeeMO) -> Employee {
        self.id = Int(employee.id)
        self.firstName = employee.firstName
        self.lastName = employee.lastName
        self.email = employee.email
        self.dob = employee.dob
        self.hireDate = employee.hireDate
        self.address = employee.address
        self.city = employee.city
        self.photo = employee.photo
        self.salary = employee.salary
        self.status = employee.status
        return self
    }
}
