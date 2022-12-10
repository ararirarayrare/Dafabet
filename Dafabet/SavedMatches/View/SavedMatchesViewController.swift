import UIKit

class SavedMatchesViewController: BaseVC {
    
    weak var viewModel: SavedMatchesViewModel!
        
    private lazy var tableView: SavedMatchesTableView = {
        let tableView = SavedMatchesTableView()
        tableView.frame = CGRect(x: 8, y: 0, width: view.bounds.width - 16, height: view.bounds.height)
        tableView.matchesDelegate = self
        tableView.backgroundColor = .clear
        tableView.viewModel = viewModel.getTableViewModel()
        return tableView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 200, height: 50)
        button.center = view.center
        button.backgroundColor = .dafaDarkRed
        button.setTitle("Add first!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.layer.cornerRadius = 12
        
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.title = "Your bets!"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false

        view.addSubview(tableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
        if viewModel.savedEventsIsEmpty {
            view.addSubview(addButton)
            animateAddButton()
        } else {
            addButton.removeFromSuperview()
        }
    }
    
    @objc
    private func addTapped() {
        tabBarController?.selectedIndex = 0
    }
    
    private func animateAddButton() {
        addButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 3, options: .allowUserInteraction) { [weak self] in
            self?.addButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}

extension SavedMatchesViewController: SavedMatchesTableViewDelegate {
    func tableViewDidRemoveRow(_ tableView: SavedMatchesTableView) {
        (UIApplication.shared.delegate as? AppDelegate)?.settings.vibrateIfAllowed(.success)
        if viewModel.savedEventsIsEmpty {
            view.addSubview(addButton)
            animateAddButton()
        }
    }
}
