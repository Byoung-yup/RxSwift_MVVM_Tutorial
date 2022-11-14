//
//  LoginViewController.swift
//  RxSwift_MVVM_Tutorial
//
//  Created by 김병엽 on 2022/11/14.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    lazy var textFieldEmail: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Enter Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    lazy var textFieldPassword: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Enter Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(clickedLoginBtn), for: .touchUpInside)
        return btn
    }()
    
    var bag = DisposeBag()
    let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        createObservables()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(textFieldEmail)
        view.addSubview(textFieldPassword)
        view.addSubview(loginBtn)
        
        NSLayoutConstraint.activate([
            textFieldEmail.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldEmail.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textFieldEmail.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            textFieldPassword.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldPassword.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textFieldPassword.topAnchor.constraint(equalTo: textFieldEmail.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            
            loginBtn.topAnchor.constraint(equalTo: textFieldPassword.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            loginBtn.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            loginBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func createObservables() {
        textFieldEmail.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.email).disposed(by: bag)
        textFieldPassword.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.password).disposed(by: bag)
        
        loginViewModel.isValidInput.bind(to: loginBtn.rx.isEnabled).disposed(by: bag)
        loginViewModel.isValidInput.subscribe(onNext: { [weak self] isValid in
            guard let self = self else { return }
            self.loginBtn.backgroundColor = isValid ? .systemBlue : .systemRed
        }).disposed(by: bag)
    }
    
    @objc func clickedLoginBtn(_ sender: UIButton) {
        
    }
    
    
}

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
