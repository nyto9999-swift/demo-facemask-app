 import UIKit

class TownViewController: UIViewController {
    
    var delegate:PassFilteredDataDelegate?
    var local = CoreDataController.shared
    var faceMasks:[faceMaskDataFaceMasks]?
    
    var tableView:UITableView = {
        let tableview = UITableView()
        tableview.allowsMultipleSelection = true
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems =
        [
            UIBarButtonItem(title: "保存",
                            style: .plain,
                            target: self,
                            action: #selector(tappedSave)),
            UIBarButtonItem(title: "全部",
                        style: .plain,
                        target: self,
                        action: #selector(tappedAll))
        ]
        
        setupViews()
        setupConstraints()
         
        local.fetchAllFaceMasks(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let masks):
                    self.faceMasks = masks
                case .failure(let error):
                    print(error)
            }
        })
    }
    
    @objc func tappedAll() {
        delegate?.TownControllerResponse(towns: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedSave() {
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            
            var towns = [String]()
            
            for ipath in selectedRows {
                
                towns.append(self.faceMasks?[ipath.row].town ?? "")
            }
            
            delegate?.TownControllerResponse(towns: towns)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        tableView.delegate   = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.pin(to: view)
    }
}
extension TownViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faceMasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        if faceMasks![indexPath.row].isFiltered == true {
            cell.accessoryType = .checkmark
        }
        
        
        cell.selectionStyle = .none
        content.text = faceMasks?[indexPath.row].town
        
        cell.contentConfiguration = content
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 0 false , 1 true
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        }
        else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
}
protocol PassFilteredDataDelegate
{
    func TownControllerResponse(towns: [String]?)
}


