import UIKit

protocol SavedMatchesTableViewDelegate: AnyObject {
    func tableViewDidRemoveRow(_ tableView: SavedMatchesTableView)
}

class SavedMatchesTableView: UITableView {
    
    weak var matchesDelegate: SavedMatchesTableViewDelegate?
    
    weak var viewModel: SavedMatchesTableViewModel!
        
    init() {
        super.init(frame: .zero, style: .grouped)
    
        delegate = self
        dataSource = self
        
        separatorColor = .black
        allowsSelection = false
        
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        separatorColor = .black
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        let cellClass = SavedMatchTableViewCell.self
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SavedMatchesTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: SavedMatchTableViewCell.self), for: indexPath) as? SavedMatchTableViewCell else {
            return SavedMatchTableViewCell()
        }
        
        let event = viewModel.event(for: indexPath.row)
        cell.configure(with: event)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120.0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            tableView.beginUpdates()

            viewModel.removeEvent(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
            
            matchesDelegate?.tableViewDidRemoveRow(self)
        }
    }
}
