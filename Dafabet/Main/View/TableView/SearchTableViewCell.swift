import UIKit

protocol SearchTableViewCellDelegate: AnyObject {
    func cell(_ cell: SearchTableViewCell, didPressBetButton button: SearchTableViewBetButton)
}

class SearchTableViewCell: UITableViewCell {
    
    weak var delegate: SearchTableViewCellDelegate?
    
    private(set) var event: EventModel!
    
    private lazy var homeTitleLabel: UILabel = createLabel(.title, aligment: .center)
    private var homeBetButton: SearchTableViewBetButton!
    
    private lazy var awayTitleLabel: UILabel = createLabel(.title, aligment: .center)
    private var awayBetButton: SearchTableViewBetButton!

    private lazy var dateLabel: UILabel = createLabel(.date, aligment: .center)
    private lazy var timeLabel: UILabel = createLabel(.date, aligment: .center)
    
    func configure(with event: EventModel) {
        self.event = event
        
        backgroundColor = .clear
        
        dateLabel.text = event.dateString.replacingOccurrences(of: "-", with: ".")
        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: 40),
            dateLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.25)
        ])
        
        timeLabel.text = String(describing: event.timeString.dropLast(3))
        addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,
                                           constant: 8),
            timeLabel.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor)
        ])
        
        homeTitleLabel.text = event.homeTitle
        addSubview(homeTitleLabel)
        NSLayoutConstraint.activate([
            homeTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                    constant: 12),
            homeTitleLabel.topAnchor.constraint(equalTo: topAnchor,
                                                constant: 12),
            homeTitleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor,
                                                     constant: -12)
        ])
        
        awayTitleLabel.text = event.awayTitle
        addSubview(awayTitleLabel)
        NSLayoutConstraint.activate([
            awayTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -12),
            awayTitleLabel.topAnchor.constraint(equalTo: topAnchor,
                                                constant: 12),
            awayTitleLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor,
                                                    constant: 12)
        ])
        
        homeBetButton = createBetButton(event.homeOdd.replacingOccurrences(of: ",", with: "."),
                                        team: .home)
        awayBetButton = createBetButton(event.awayOdd.replacingOccurrences(of: ",", with: "."),
                                        team: .away)
        
        addSubview(homeBetButton)
        NSLayoutConstraint.activate([
            homeBetButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -12),
            homeBetButton.centerXAnchor.constraint(equalTo: homeTitleLabel.centerXAnchor),
            homeBetButton.widthAnchor.constraint(equalToConstant: 80),
            homeBetButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        addSubview(awayBetButton)
        NSLayoutConstraint.activate([
            awayBetButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -12),
            awayBetButton.centerXAnchor.constraint(equalTo: awayTitleLabel.centerXAnchor),
            awayBetButton.widthAnchor.constraint(equalToConstant: 80),
            awayBetButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [homeBetButton, awayBetButton].forEach { button in
            guard let button = button else {
                return
            }
            button.setGradiet()
            addShape(for: button)
        }
    }
    
    private func addShape(for view: UIView) {
        guard view.bounds.size != .zero else {
            return
        }
        
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 8).cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.dafaDarkRed.cgColor
        shape.lineWidth = 2.0
        
        if let sublayers = view.layer.sublayers, sublayers.contains(shape) {
            return
        }
        
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.addSublayer(shape)
    }
    
    private enum LabelTypee {
        case title, odd, date
    }
    
    private func createLabel(_ type: LabelTypee, aligment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .title:
            label.font = .boldSystemFont(ofSize: 20)
            label.textColor = .dafaDarkRed
            label.minimumScaleFactor = 0.7
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
        case .date, .odd:
            label.font = .italicSystemFont(ofSize: 20)
            label.textColor = .black
            label.numberOfLines = 1
            label.minimumScaleFactor = 0.3
        }
        
        label.textAlignment = aligment
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }
    
    @objc
    private func betButtonTapped(_ sender: SearchTableViewBetButton) {
        delegate?.cell(self, didPressBetButton: sender)
    }
    
    private func createBetButton(_ oddString: String?, team: Team) -> SearchTableViewBetButton {
        let button = SearchTableViewBetButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .dafaDarkRed
        button.titleLabel?.font = .italicSystemFont(ofSize: 20)
        
        button.betTeam = team
        button.setTitle(oddString, for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(betButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
}
