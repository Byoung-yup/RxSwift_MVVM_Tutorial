//
//  ViewModel.swift
//  RxSwift_MVVM_Tutorial
//
//  Created by 김병엽 on 2022/11/10.
//

import Foundation
import RxSwift
import Differentiator

class ViewModel {
    var users = BehaviorSubject(value: [SectionModel(model: "", items: [User]())])
    
    func fetchUsers() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode([User].self, from: data)
                let sectionUser = SectionModel(model: "First", items: [User(userID: 0, id: 1, title: "CodeLib", body: "Youtube Demo")])
                let secondSection = SectionModel(model: "Second", items: responseData)
                self.users.on(.next([sectionUser, secondSection]))
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func addUser() {
        guard var sections = try? users.value() else { return }
        var currentSection = sections[0]
        currentSection.items.append(User(userID: 0, id: 1, title: "Add Unit", body: "Youtube Demo"))
        sections[0] = currentSection
        self.users.onNext(sections)
    }
    
    func deleteUser(indexPath: IndexPath) {
        guard var sections = try? users.value() else { return }
        var currentSection = sections[indexPath.section]
        currentSection.items.remove(at: indexPath.row)
        sections[indexPath.section] = currentSection
        self.users.on(.next(sections))
    }
    
    func editUser(title: String, indexPath: IndexPath) {
        guard var sections = try? users.value() else { return }
        var currentSection = sections[indexPath.section]
        currentSection.items[indexPath.row].title = title
        sections[indexPath.section] = currentSection
        self.users.onNext(sections)
    }
}
