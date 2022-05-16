//
//  ViewController.swift
//  faceMaskData
//
//  Created by 宇宣 Chen on 2022/5/13.
//

import UIKit
import CoreData
 
class ViewController: UIViewController {
    
    var faceMasks:[faceMaskDataFaceMasks]?
    var sentences:[faceMaskDataDailySentence]?
        
    var containerView: UIStackView = {
        let view  = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    lazy var sentenceView = SentenceView(sentence: sentences?[0].sentence, author: sentences?[0].author)
    
    var tableView:UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    init(faceMaskData: [faceMaskDataFaceMasks]? , dailySentenceData: [faceMaskDataDailySentence]? ) {
        super.init(nibName: nil, bundle: nil)
        self.faceMasks = faceMaskData
        self.sentences = dailySentenceData
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @objc func tappedFilterButton() {print("tapped")}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: TableView
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        let deleteAction = UIContextualAction(style: .normal, title: "刪除") { action, view, handler in
              //coredata delete
              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }
              handler(true)
          }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

 
