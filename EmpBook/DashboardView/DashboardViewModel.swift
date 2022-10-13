//
//  DashboardViewModel.swift
//  EmpBook
//
//  Created by A118830248 on 11/10/22.
//

import Foundation

enum SortType {
    case name
    case address
    case salary
    case date
}

enum SalaryRange {
    case case0To50k
    case case50kTo150k
    case caseAbove150K
    case reset
}

class DashboardViewModel {
    private var repository: UserRepositoryProtocol
    var employees: [Employee] = [] {
        didSet {
            dataSource = employees
        }
    }
    var reloadCallBack: (() -> Void)?
    var apiError: ((String) -> Void)?
    var viewState: ((LoginState) -> Void)?
    
    var dataSource: [Employee] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadCallBack?()
            }
        }
    }
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func getEmployees() {
        viewState?(.loading)
        DispatchQueue.global().async { [weak self] in
            self?.repository.getEmployees { result in
                DispatchQueue.main.async { self?.viewState?(.ready) }
                switch result {
                case .success(let response):
                    self?.employees = response
                    DispatchQueue.main.async { self?.reloadCallBack?() }
                case .failure(let error):
                    DispatchQueue.main.async { self?.apiError?(error.localizedDescription) }
                }
            }
        }
    }
    
    func sort(type: SortType) {
        DispatchQueue.global().async { [weak self] in
            let employees = self?.employees ?? []
            switch type {
            case .name:
                self?.dataSource = employees.sorted(by: { $0.firstName ?? "" < $1.firstName ?? "" })
            case .address:
                self?.dataSource = employees.sorted(by: { $0.address ?? "" < $1.address ?? "" })
            case .salary:
                self?.dataSource = employees.sorted(by: { $0.salary?.toDigits ?? 0 < $1.salary?.toDigits ?? 0 })
            case .date:
                self?.dataSource = employees.sorted(by: { $0.dateFromString > $1.dateFromString })
            }
        }
    }
    
    func filter(type: SalaryRange) {
        DispatchQueue.global().async {[weak self] in
            let employees = self?.employees ?? []
            switch type {
            case .case0To50k:
                self?.dataSource = employees.filter({ $0.salary?.toDigits ?? 0 >= 0 && $0.salary?.toDigits ?? 0 <= 50000 })
            case .case50kTo150k:
                self?.dataSource = employees.filter({ $0.salary?.toDigits ?? 0 > 50000 && $0.salary?.toDigits ?? 0 <= 150000 })
            case .caseAbove150K:
                self?.dataSource = employees.filter({ $0.salary?.toDigits ?? 0 > 150000 })
            case .reset:
                self?.dataSource = employees
            }
        }
    }
    
    func logout() {
        DispatchQueue.global().async {[weak self] in
            self?.repository.logout()
        }
    }
}

extension String {
    var toDigits: Double? {
        return Double(self)
    }
}
