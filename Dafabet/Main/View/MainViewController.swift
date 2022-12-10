//
//  ViewController.swift
//  Dafabet
//
//  Created by mac on 28.09.2022.
//

import UIKit

class MainViewController: BaseVC {
    
    weak var viewModel: MainViewModel! {
        didSet {
            configure()
        }
    }
    
    private lazy var headerView: SearchHeaderView = {
        let headerView = SearchHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.searchBar.delegate = self
        
        return headerView
    }()
    
    private var tableView: SearchTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

           
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (headerView.layer.sublayers?.first as? CAGradientLayer) == nil, headerView.bounds.size != .zero {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = headerView.bounds
            gradientLayer.cornerRadius = headerView.layer.cornerRadius
            gradientLayer.colors = [
                UIColor(red: 120/255, green: 10/255, blue: 10/255, alpha: 1.0).cgColor,
                UIColor(red: 60/255, green: 10/255, blue: 3/255, alpha: 1.0).cgColor
            ]
            headerView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true

        tableView?.reloadData()
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    func configure() {
        setupTableView()
        setupHeaderView()
    }
    
    private func setupTableView() {
        guard let viewModel = viewModel else {
            return
        }
        tableView = SearchTableView(viewModel: viewModel.tableViewModel)
        tableView.frame = CGRect(x: 8,
                                 y: 200,
                                 width: view.bounds.width - 16,
                                 height: view.bounds.height - 200)
        tableView.selectDelegate = self
        tableView.contentInset.top = 120
        tableView.backgroundColor = .clear
        tableView.headerColor = .dafaDarkRed
        tableView.allowsSelection = false
        view.addSubview(tableView)
    }
    
    private func setupHeaderView() {
        headerView.titleLabel.text = "Matches"
        view.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 8),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -8),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                            constant: 16),
            headerView.heightAnchor.constraint(equalToConstant: 220),
        ])
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            tableView.allSectionsOpen = false
            tableView.viewModel.currentSectionModels = tableView.viewModel.sectionModels
            return
        }
        
        tableView.allSectionsOpen = true
        tableView.viewModel.filterCurrentSectionModels(by: searchText)
        
        if let firstNonEmptySection = tableView.viewModel.firstNonEmptySection {
            tableView.scrollToRow(at: IndexPath(row: 0, section: firstNonEmptySection), at: .top, animated: true)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
}

extension MainViewController: SearchTableViewSelectDelegate {
    func tableView(_ tableView: SearchTableView, didSelect event: EventModel, team: Team) {
        var odd: String {
            switch team {
            case .home:
                return event.homeOdd
            case .away:
                return event.awayOdd
            }
        }
        let betView = BetView(event: event.eventTitle, bet: team, odd: odd)
        betView.alpha = 0
        betView.containerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        view.addSubview(betView)
        UIView.animate(withDuration: 0.2) {
            betView.alpha = 1
            betView.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        betView.handler = { [weak self] (success, amount) in
            if success {
                guard let amount = amount else {
                    return
                }
                
                (UIApplication.shared.delegate as? AppDelegate)?.settings.vibrateIfAllowed(.success)
                self?.viewModel.saveBet(event: event, betAmount: amount, team: team)
            }
            
            self?.hideKeyboard()
            UIView.animate(withDuration: 0.2) {
                betView.alpha = 0
                betView.containerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            } completion: { _ in
                betView.removeFromSuperview()
            }
        }
    }
}
