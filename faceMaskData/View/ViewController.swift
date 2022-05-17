//
//  ViewController.swift
//  faceMaskData
//
//  Created by 宇宣 Chen on 2022/5/13.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
//    var sentences = [faceMaskDataDailySentence]()
    var towns = [String]()
    var faceMasks:[faceMaskDataFaceMasks]?
//    var faceMasks = [faceMaskDataFaceMasks]()
    
    
    lazy var containerView: UIStackView = {
        let view  = UIStackView()
        view.axis = .vertical
        return view
    }()
    
//    lazy var sentenceView = SentenceView(dailySentence: sentences)
    
    lazy var tableView:UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    init(faceMaskData: [faceMaskDataFaceMasks]?) {
        super.init(nibName: nil, bundle: nil)
        self.faceMasks = faceMaskData
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
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
//        containerView.addArrangedSubview(sentenceView)
        containerView.addArrangedSubview(tableView)
    }
    func setupConstraints(){
        containerView.pin(to: view)
    }
    
    @objc func tappedFilterButton() {
//        let townVC = TownViewController()
//        townVC.towns = towns
//        self.navigationController?.pushViewController(townVC, animated: true)
//
        print(self.faceMasks?.count)
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
            
            let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
            let predicate = NSPredicate(format: "town = %@", "\(strongSelf.faceMasks?[indexPath.row].town ?? "")")
            request.predicate = predicate
            request.fetchLimit = 1
            
            do {
                let objects = try context.fetch(request)
                for object in objects {
                    context.delete(object)
                    
                }
                try context.save()
                
                strongSelf.towns = strongSelf.towns.filter { $0 != strongSelf.faceMasks?[indexPath.row].town }
                strongSelf.faceMasks?.remove(at: indexPath.row)
            }
            catch {
                print("error")
            }
            
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


