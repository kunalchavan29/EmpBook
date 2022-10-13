//
//  DatabaseManager.swift
//  EmpBook
//
//  Created by A118830248 on 11/10/22.
//

import Foundation
import CoreData
import UIKit

protocol StorageProtocol {
    func saveLoginResponse(response: LoginResponse) throws
    func saveEmployees(response: [Employee]) throws
}

final class DatabaseManager: StorageProtocol {
    private init() {}
    
    static let shared = DatabaseManager()
    private lazy var context: NSManagedObjectContext = {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }()
    
    var refreshToken: String?
    var accessToken: String?
    
    func isUserLoggedIn() throws -> Bool {
        let request = UserMO.fetchRequest()
        request.returnsObjectsAsFaults = false
        let users = try context.fetch(request)
        return !users.isEmpty
    }
    
    func logOut() {
        resetAllCoreData()
    }
    
    func saveLoginResponse(response: LoginResponse) throws {
        resetAllCoreData()
        refreshToken = response.refresh
        accessToken = response.access
        let loginMO = LoginResponseMO(context: context)
        loginMO.accessToken = response.access
        loginMO.refreshToken = response.refresh
        
        let userMO = UserMO(context: context)
        userMO.firstName = response.user?.firstName
        userMO.lastName = response.user?.lastName
        userMO.email = response.user?.email
        loginMO.user = userMO
        
        try context.save()
    }
    
    func saveEmployees(response: [Employee]) throws {
        resetEmployeesData()
        for val in response {
            var employeeMO = EmployeeMO(context: context)
            employeeMO = val.mapToMO(employeeMO: employeeMO)
        }
        try context.save()
    }
    
    func getEmployees() -> [Employee] {
        let request = EmployeeMO.fetchRequest()
        do {
            let employees = try context.fetch(request)
            var employee = Employee()
            let result = employees.map({ employee.mapFromMO(employee: $0) })
            return result
        } catch {
            print(error)
            return []
        }
    }
    
    private func resetEmployeesData() {
        do {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeMO")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            try self.context.execute(deleteRequest)
        } catch {
            print(error)
        }
    }
    
    private func resetAllCoreData() {
        do {
            let entityNames = persistentContainer.managedObjectModel.entities.map({ $0.name!})
            try entityNames.forEach { [weak self] entityName in
                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
                try self?.context.execute(deleteRequest)
            }
            try context.save()
        } catch {
            print(error)
        }
    }
}
