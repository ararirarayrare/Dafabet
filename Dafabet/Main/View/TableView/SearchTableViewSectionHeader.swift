import UIKit

class SearchTableViewSectionHeader: UIView {
    
    init(sport: String, matchesCount: Int, openButton: SearchTableViewHeaderButton) {
        super.init(frame: .zero)
        layer.cornerRadius = 8

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
                
        let attributedString = NSMutableAttributedString()
        
        let sportString = NSAttributedString(string: sport + " - ",
                                             attributes: [
                                                .font : UIFont.boldSystemFont(ofSize: 24)
                                             ])
        attributedString.append(sportString)
        
        let matchesCountString = NSAttributedString(string: "\(matchesCount) matches",
                                                    attributes: [
                                                        .font : UIFont.italicSystemFont(ofSize: 20)
                                                    ])
        attributedString.append(matchesCountString)
        
        label.attributedText = attributedString
         
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(openButton)
        NSLayoutConstraint.activate([
            openButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            openButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            openButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
            openButton.widthAnchor.constraint(equalTo: openButton.heightAnchor, multiplier: 0.75)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
