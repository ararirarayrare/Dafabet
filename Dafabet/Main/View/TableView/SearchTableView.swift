import UIKit

protocol SearchTableViewSelectDelegate: AnyObject {
    func tableView(_ tableView: SearchTableView, didSelect event: EventModel, team: Team)
}

class SearchTableView: UITableView {
    
    weak var selectDelegate: SearchTableViewSelectDelegate?
    
    let viewModel: SearchTableViewModel
            
    private var sectionHeaderButtons: [SearchTableViewHeaderButton] = []
    
    var headerColor: UIColor? {
        didSet {
            reloadData()
        }
    }

    var allSectionsOpen: Bool = false {
        didSet {
            allSectionsOpen ? viewModel.openAll() : viewModel.closeAll()
        }
    }
    
    init(viewModel: SearchTableViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .grouped)
        
        self.viewModel.reloadHandler = { [weak self] in
            self?.reloadData()
        }
        
        for i in 0..<viewModel.sectionModels.count {
            let button = SearchTableViewHeaderButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = i
            button.imageView?.tintColor = .white
            button.isOpen = viewModel.sectionModels[i].isOpen
                    
            button.addTarget(self, action: #selector(sectionHeaderButtonTapped(_:)), for: .touchUpInside)
            sectionHeaderButtons.append(button)
        }
        
        delegate = self
        dataSource = self
        
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        separatorColor = .black
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        let cellClass = SearchTableViewCell.self
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    @objc
    private func sectionHeaderButtonTapped(_ sender: SearchTableViewHeaderButton) {
        (UIApplication.shared.delegate as? AppDelegate)?.settings.selectionIfAllowed()
        sender.isOpen = !sender.isOpen
        viewModel.openClose(section: sender.tag)
        reloadSections([sender.tag], with: .none)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: SearchTableViewCell.self)
        
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? SearchTableViewCell else {
            return SearchTableViewCell()
        }
        
        let cellModel = viewModel.cellModel(for: indexPath)
        
        cell.configure(with: cellModel)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let currentModel = viewModel.currentSectionModels[section]
        let button = sectionHeaderButtons[section]
        let headerView = SearchTableViewSectionHeader(sport: currentModel.title,
                                                      matchesCount: currentModel.events.count,
                                                      openButton: button)
        headerView.backgroundColor = headerColor ?? .lightText

        return headerView
    }
        
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}

extension SearchTableView: SearchTableViewCellDelegate {
    func cell(_ cell: SearchTableViewCell, didPressBetButton button: SearchTableViewBetButton) {
        selectDelegate?.tableView(self, didSelect: cell.event, team: button.betTeam)
    }
}
