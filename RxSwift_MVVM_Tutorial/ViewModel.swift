//
//  ViewModel.swift
//  RxSwift_MVVM_Tutorial
//
//  Created by 김병엽 on 2022/11/10.
//

import Foundation
import RxSwift

class ViewModel {
    var users = BehaviorSubject(value: [User]())
    
    func fetchUsers() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                self.users.on(.next(responseData))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func addUser(user: User) {
        guard var users = try? users.value() else { return }
        users.insert(user, at: 0)
        self.users.on(.next(users))
    }
    
    func deleteUser(index: Int) {
        guard var users = try? users.value() else { return }
        users.remove(at: index)
        self.users.on(.next(users))
    }
    
    func editUser(title: String, index: Int) {
        guard var users = try? users.value() else { return }
        users[index].title = title
        self.users.on(.next(users))
    }
}
