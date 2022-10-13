//
//  LoginViewController.swift
//  EmpBook
//
//  Created by A118830248 on 10/10/22.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel = LoginViewModel(service: LoginService(), storage: DatabaseManager.shared)
        }
        view.backgroundColor = UIColor.backgroundColor
        emailTextField.text = "test@example.com"
        passwordTextField.text = "testing@example"
        setupBinding()
    }
}

extension LoginViewController {
    fileprivate func setupBinding() {
        viewModel.loginSuccess = { [weak self] in
            self?.navigateToDashboard()
        }
        
        viewModel.loginError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
        
        viewModel.loginState = { [weak self] state in
            switch state {
            case .ready:
                self?.loginButton.isEnabled = true
            case .loading:
                self?.loginButton.isEnabled = false
            }
        }
    }
    
    @IBAction func didSelectLogin(sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(title: "Error", message: "Please enter valid data")
            return
        }
        viewModel.login(email: email, password: password)
    }
    
    func navigateToDashboard() {
        guard let viewController = storyboard?.instantiateViewController(withIdentifier: String.init(describing: DashboardViewController.self)) else { return }
        let navigationController = UINavigationController(rootViewController: viewController)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}
