import UIKit

class SavedMatchTableViewCell: UITableViewCell {

    private lazy var sportLabel: UILabel = createLabel(.title)
    
    private lazy var eventLabel: UILabel = createLabel(.event)
    
    private lazy var betLabel: UILabel = createLabel(.none, aligment: .right)
    
    private lazy var amountLabel = createLabel(.title, aligment: .right)
    
    private lazy var oddLabel = createLabel(.none, aligment: .right)
    
    func configure(with event: SavedEventModel) {
        backgroundColor = .clear
        
        var teamString: String {
            switch event.betTeam {
            case .home:
                return event.homeTitle
            case .away:
                return event.awayTitle
            }
        }
        
        let attributtedString = NSMutableAttributedString(string: "Win: ")
    
        let betTeam = NSAttributedString(
            string: String(describing: event.betTeam).capitalized,
            attributes: [
                .foregroundColor : UIColor.dafaDarkRed,
                .font : UIFont.boldSystemFont(ofSize: 20)
            ]
        )
        
        attributtedString.append(betTeam)
        
        betLabel.attributedText = attributtedString
        addSubview(betLabel)
        NSLayoutConstraint.activate([
            betLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                               constant: -16),
            betLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        ])
        
        amountLabel.text = "\(event.betAmount) $"
        amountLabel.textColor = .dafaGreen
        addSubview(amountLabel)
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                  constant: -16),
            amountLabel.leadingAnchor.constraint(equalTo: betLabel.leadingAnchor),
            amountLabel.topAnchor.constraint(equalTo: betLabel.bottomAnchor,
                                             constant: 4)
        ])
        
    
        switch event.betTeam {
        case .home:
            oddLabel.text = "x" + event.homeOdd.replacingOccurrences(of: ",", with: ".")
        case .away:
            oddLabel.text = "x" + event.awayOdd.replacingOccurrences(of: ",", with: ".")
        }
        addSubview(oddLabel)
        NSLayoutConstraint.activate([
            oddLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -16),
            oddLabel.leadingAnchor.constraint(equalTo: betLabel.leadingAnchor),
            oddLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor,
                                          constant: 4)
        ])
        
        
        sportLabel.text = event.sport
        addSubview(sportLabel)
        NSLayoutConstraint.activate([
            sportLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            sportLabel.topAnchor.constraint(equalTo: betLabel.topAnchor)
        ])
        
        eventLabel.text = event.eventTitle
        addSubview(eventLabel)
        NSLayoutConstraint.activate([
            eventLabel.leadingAnchor.constraint(equalTo: sportLabel.leadingAnchor),
            eventLabel.trailingAnchor.constraint(equalTo: betLabel.leadingAnchor,
                                                 constant: -20),
            eventLabel.topAnchor.constraint(equalTo: sportLabel.bottomAnchor,
                                            constant: 4)
        ])
        
    }
    
    enum LabelType {
        case title, event, none
    }
    
    private func createLabel(_ type: LabelType, aligment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .title:
            label.font = .boldSystemFont(ofSize: 20)
            label.textColor = .dafaDarkRed
            label.minimumScaleFactor = 0.7
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping
        case .event:
            label.font = .italicSystemFont(ofSize: 20)
            label.textColor = .black
            label.numberOfLines = 2
            label.minimumScaleFactor = 0.6
        case .none:
            label.font = .systemFont(ofSize: 20)
            label.textColor = .black
            label.minimumScaleFactor = 0.5
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
        }
        
        label.textAlignment = aligment
        label.adjustsFontSizeToFitWidth = true
                
        return label
    }
}
