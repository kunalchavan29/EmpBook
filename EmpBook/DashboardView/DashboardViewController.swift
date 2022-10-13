//
//  DashboardViewController.swift
//  EmpBook
//
//  Created by A118830248 on 11/10/22.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: DashboardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EmpBook"
        if viewModel == nil {
            viewModel = DashboardViewModel(repository: UserRepository(service: EmployeeService()))
        }
        setupUI()
        setupBinding()
        viewModel.getEmployees()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.backgroundColor
        setupNavbar()
        setupTableView()
    }
    
    private func setupBinding() {
        viewModel.reloadCallBack = { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.tableView.reloadData()
        }
        
        viewModel.apiError = { [weak self] message in
            self?.tableView.refreshControl?.endRefreshing()
            self?.showAlert(title: "Error", message: message)
        }
    }
}

extension DashboardViewController {
    private func setupNavbar() {
        let sort = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(didSelectSort))
        let filter = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didSelectFilter))
        self.navigationItem.rightBarButtonItems = [sort, filter]
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.leftBarButtonItems = [logout]
    }
    
    @objc func logout() {
        viewModel.logout()
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing:LoginViewController.self)) else {return}
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
    
    @objc func didSelectSort() {
        let alert = UIAlertController(title: "Sort By", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Name", style: .default , handler:{ (UIAlertAction)in
            self.viewModel.sort(type: .name)
        }))
        
        alert.addAction(UIAlertAction(title: "Date", style: .default , handler:{ (UIAlertAction)in
            self.viewModel.sort(type: .date)
        }))
        
        alert.addAction(UIAlertAction(title: "Salary", style: .default , handler:{ (UIAlertAction)in
            self.viewModel.sort(type: .salary)
        }))
        
        alert.addAction(UIAlertAction(title: "Address", style: .default, handler:{ (UIAlertAction)in
            self.viewModel.sort(type: .address)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction) in }))
        
        present(alert, animated: true, completion: {})
    }
    
    @objc func didSelectFilter() {
        let alert = UIAlertController(title: "Filter", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "0-50K", style: .default , handler:{ (UIAlertAction)in
            self.viewModel.filter(type: .case0To50k)
        }))
        
        alert.addAction(UIAlertAction(title: "51-1.5L", style: .default , handler:{ (UIAlertAction)in
            self.viewModel.filter(type: .case50kTo150k)
        }))
        
        alert.addAction(UIAlertAction(title: "above 1.5L", style: .default , handler:{ (UIAlertAction)in
            self.viewModel.filter(type: .caseAbove150K)
        }))
        
        alert.addAction(UIAlertAction(title: "Reset", style: .default , handler:{ (UIAlertAction)in
            self.viewModel.filter(type: .reset)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in }))
        
        self.present(alert, animated: true, completion: {})
    }
    
    private func setupTableView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 130
    }
    
    @objc func refreshTable() {
        tableView.refreshControl?.beginRefreshing()
        viewModel.getEmployees()
    }
}

extension DashboardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EmployeeTableViewCell.self), for: indexPath) as! EmployeeTableViewCell
        cell.employee = viewModel.dataSource[indexPath.row]        
        return cell
    }
}

extension DashboardViewController: UITableViewDelegate {}

