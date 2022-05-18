import UIKit
import CoreData

class ViewController: UIViewController,PassFilteredDataDelegate {

    var local = CoreDataController.shared
    var sentences:[faceMaskDataDailySentence]?
    var faceMasks:[faceMaskDataFaceMasks]?
    
    var containerView: UIStackView = {
        let view  = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    lazy var sentenceView = SentenceView(dailySentence: sentences!)
    
    var tableView:UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        local.fetchFaceMasks(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let masks):
                    self.faceMasks = masks
                case .failure(let error):
                    print(error)
            }
        })
        self.sentences = local.fetchDailySentences()
        if local.fetchDailySentences() == nil {
            self.sentenceView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    //delegate
    func TownControllerResponse(towns: [String]) {
        local.setIsFilteredMask(byTown: towns) { [weak self] result in
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
        return faceMasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = "口罩數量： \(faceMasks?[indexPath.row].quantity ?? 0)"
        content.secondaryText = "地區： \(faceMasks?[indexPath.row].town ?? "無資料")"
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "刪除") { [weak self] action, view, handler in
            guard let self = self else { return }
    
            let town = self.faceMasks?[indexPath.row].town
            print(town!)
            self.local.deleteFaceMask(town: town!)
            self.local.fetchFaceMasks { result in
                switch result {
                    case .success(let masks):
                        self.faceMasks = masks
                    case .failure(let error):
                        print(error)
                }
            }
            self.tableView.reloadData()
            handler(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
