//
//  ViewController.swift
//  faceMaskData
//
//  Created by 宇宣 Chen on 2022/5/13.
//

import UIKit
import CoreData

class ViewController: UIViewController,PassFilteredDataDelegate {

    var local = CoreDataController.shared
    var sentences = [faceMaskDataDailySentence]()
    var faceMasks:[faceMaskDataFaceMasks]?
    
    lazy var containerView: UIStackView = {
        let view  = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    lazy var sentenceView = SentenceView(dailySentence: sentences)
    
    lazy var tableView:UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.faceMasks = local.fetchFaceMasks(showAll: false)
        self.sentences = local.fetchDailySentences()
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        view.backgroundColor = .white
        tableView.delegate   = self
        tableView.dataSource = self
        
        let barItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(tappedFilterButton))
        self.navigationItem.rightBarButtonItem = barItem
        
        view.addSubview(containerView)
        containerView.addArrangedSubview(sentenceView)
        containerView.addArrangedSubview(tableView)
    }
    
    func setupConstraints(){
        containerView.pin(to: view)
    }
    
    @objc func tappedFilterButton() {
        
        let townVC = TownViewController()
        townVC.delegate = self
        self.navigationController?.pushViewController(townVC, animated: true)
    }
    
    func TownControllerResponse(towns: [String]) {
        local.fileterdFaceMasks(byTown: towns) { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let masks):
                    self.faceMasks = masks
                    self.tableView.reloadData()
                case .failure(_):
                    print("fail filteredmask")
            }
        }
    }
    
}

//MARK: TableView
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return faceMasks.count
        return faceMasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = "口罩數量： \(faceMasks?[indexPath.row].quantity ?? 0)"
        content.secondaryText = "地區： \(faceMasks?[indexPath.row].town ?? "未知")"
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "刪除") { [weak self] action, view, handler in
            
            guard let strongSelf = self else { return }
            
            let town = strongSelf.faceMasks?[indexPath.row].town ?? ""
            
            strongSelf.local.updateFaskMask(town: town)
            strongSelf.faceMasks = strongSelf.local.fetchFaceMasks(showAll: false)
            
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
            
            handler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}


