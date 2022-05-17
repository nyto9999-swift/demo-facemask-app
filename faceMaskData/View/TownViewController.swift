////
////  TownViewController.swift
////  faceMaskData
////
////  Created by 宇宣 Chen on 2022/5/17.
////
//
//import UIKit
//
//class TownViewController: UIViewController {
//    
//    var towns = [String]()
//    
//    var tableView:UITableView = {
//        let tableview = UITableView()
//        tableview.allowsMultipleSelection = true
//        tableview.translatesAutoresizingMaskIntoConstraints = false
//        tableview.register(UITableViewCell.self,
//                           forCellReuseIdentifier: "cell")
//        return tableview
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        navigationItem.rightBarButtonItem =
//            UIBarButtonItem(title: "Done",
//                            style: .plain,
//                            target: self,
//                            action: #selector(tappedSave))
//        
//        
//        setupViews()
//        setupConstraints()
//    }
//    @objc func tappedSave() {
//        
//    }
//    
//    func setupViews() {
//        view.backgroundColor = .white
//        tableView.delegate   = self
//        tableView.dataSource = self
//        view.addSubview(tableView)
//    }
//    
//    func setupConstraints() {
//        tableView.pin(to: view)
//    }
//}
//extension TownViewController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return towns.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        var content = cell.defaultContentConfiguration()
//        
//        content.text = towns[indexPath.row]
//        
//        cell.contentConfiguration = content
//        return cell
//    }
//    
//    
//    
//}
