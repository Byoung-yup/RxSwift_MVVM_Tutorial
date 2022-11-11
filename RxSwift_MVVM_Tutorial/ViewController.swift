//
//  ViewController.swift
//  RxSwift_MVVM_Tutorial
//
//  Created by 김병엽 on 2022/11/10.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private var viewModel = ViewModel()
    private var bag = DisposeBag()
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.view.frame, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UserTableViewCell.nib, forCellReuseIdentifier: UserTableViewCell.identifier)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationTitle()
        let addBtn = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTap))
        self.navigationItem.rightBarButtonItem = addBtn
        view.addSubview(tableView)
        viewModel.fetchUsers()
        bindTableView()
    }
    
    func configureNavigationTitle(){
        self.title = "Users"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Copperplate", size: 21) ?? UIFont()]
    }
    
    @objc func addTap() {
        let user = User(userID: 48954, id: 4534, title: "CodeLib", body: "RxSwift Crud")
        self.viewModel.addUser(user: user)
    }

    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: bag)
        viewModel.users.bind(to: tableView.rx.items(cellIdentifier: UserTableViewCell.identifier)) { (row, item, cell) in
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = "\(item.id)"
            cell.selectionStyle = .none
        }.disposed(by: bag)
        
        tableView.rx.itemSelected.subscribe { indexPath in
            let alert = UIAlertController(title: "Node", message: "Edit", preferredStyle: .alert)
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "Edit", style: .default) { _ in
                let textField = alert.textFields![0] as UITextField
                self.viewModel.editUser(title: textField.text!, index: indexPath.row)
            })
            DispatchQueue.main.async {
                self.present(alert, animated: false)
            }
        }.disposed(by: bag)
        
        tableView.rx.itemDeleted.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            self.viewModel.deleteUser(index: indexPath.row)
        }.disposed(by: bag)
    }
}

extension ViewController: UITableViewDelegate {}

