//
//  LoginViewModel.swift
//  RxSwift_MVVM_Tutorial
//
//  Created by 김병엽 on 2022/11/14.
//

import Foundation
import UIKit
import RxSwift

class LoginViewModel {
    
    var email: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    var password: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
    
    var isValidEmail: Observable<Bool> {
        email.map { $0.isValidEmail() }
    }
    
    var isValidPassword: Observable<Bool> {
        password.map { password in
            return password.count < 6 ? false : true
        }
    }
    
    var isValidInput: Observable<Bool> {
        Observable.combineLatest(isValidEmail, isValidPassword).map { $0 && $1 }
    }
}

