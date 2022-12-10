import UIKit

class BetView: UIView {
    
    var handler: ((Bool, Double?) -> Void)?
    
    private(set) lazy var containerView: UIView = {
        let screenSize = UIScreen.main.bounds.size
        let size = CGSize(width: screenSize.width * 0.75,
                          height: screenSize.width * 0.5)
        
        let container = UIView(frame: CGRect(origin: .zero, size: size))
        container.center.x = center.x
        container.center.y = center.y - 36
        container.layer.cornerRadius = 20
        container.layer.masksToBounds = true
        container.backgroundColor = .dafaDarkRed
        
        let gradient = CAGradientLayer()
        gradient.frame = container.bounds
        gradient.colors = [
            UIColor(red: 120/255, green: 10/255, blue: 10/255, alpha: 1.0).cgColor,
            UIColor(red: 60/255, green: 10/255, blue: 3/255, alpha: 1.0).cgColor
        ]
        gradient.cornerRadius = container.layer.cornerRadius
        container.layer.insertSublayer(gradient, at: 0)
        
        return container
    }()
    
    private lazy var eventLabel: UILabel = createLabel()
    
    private lazy var betLabel: UILabel = createLabel()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.textAlignment = .center
        textField.font = .boldSystemFont(ofSize: 18)
        textField.placeholder = "Type bet amount $"
        textField.layer.cornerRadius = 4
        textField.keyboardType = .decimalPad
        textField.becomeFirstResponder()
        textField.delegate = self
        return textField
    }()
    
    private lazy var cancelButton: UIButton = createButton(title: "Cancel", tag: 0)
    
    private lazy var betButton: UIButton = createButton(title: "Bet", tag: 1)
    
    init(event: String, bet: Team, odd: String) {
        super.init(frame: UIScreen.main.bounds)
        
        addSubview(containerView)
        
        backgroundColor = .black.withAlphaComponent(0.5)

        eventLabel.text = event
        containerView.addSubview(eventLabel)
        NSLayoutConstraint.activate([
            eventLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                constant: 16),
            eventLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                 constant: -16),
            eventLabel.topAnchor.constraint(equalTo: containerView.topAnchor,
                                            constant: 20)
        ])
        
        let attributtedString = NSMutableAttributedString(
            string: "Win:  ",
            attributes: [
                .font : UIFont.boldSystemFont(ofSize: 20)
            ]
        )
    
        let betTeam = NSAttributedString(
            string: String(describing: bet).capitalized,
            attributes: [
                .font : UIFont.italicSystemFont(ofSize: 20)
            ]
        )
        
        attributtedString.append(betTeam)
        
        attributtedString.append(NSAttributedString(string: "  -  "))
        
        let odd = NSAttributedString(
            string: "x " + odd.replacingOccurrences(of: ",", with: "."),
            attributes: [
                .font : UIFont.boldSystemFont(ofSize: 20)
            ]
        )
        attributtedString.append(odd)
        
        betLabel.attributedText = attributtedString
        containerView.addSubview(betLabel)
        NSLayoutConstraint.activate([
            betLabel.leadingAnchor.constraint(equalTo: eventLabel.leadingAnchor),
            
            betLabel.topAnchor.constraint(equalTo: eventLabel.bottomAnchor,
                                          constant: 8)
        ])
        
        containerView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                               constant: 20),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                               constant: -20),
            textField.topAnchor.constraint(equalTo: betLabel.bottomAnchor,
                                           constant: 12),
            textField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        betButton.setTitleColor(.dafaGreen, for: .highlighted)
        let buttonsStackView = UIStackView(arrangedSubviews: [cancelButton, betButton])
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 16
        buttonsStackView.distribution = .fillEqually
        
        containerView.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                      constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                       constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                     constant: -16),
            buttonsStackView.topAnchor.constraint(equalTo: textField.bottomAnchor,
                                                  constant: 12)
        ])
    }
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            handler?(false, nil)
            (UIApplication.shared.delegate as? AppDelegate)?.settings.selectionIfAllowed()
        } else {
            guard let text = textField.text,
                  let amount = Double(text),
                  amount > 0 else {
                animateEmptyField()
                (UIApplication.shared.delegate as? AppDelegate)?.settings.vibrateIfAllowed(.error)
                return
            }
            handler?(true, amount)
        }
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 22)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
//        label.lineBreakMode = .byWordWrapping
        return label
    }
    
    private func createButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.setTitle(title, for: .normal)
        button.setTitleColor(.dafaDarkRed, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tag = tag
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    private func animateEmptyField() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.04
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textField.center.x - 2, y: textField.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textField.center.x + 2, y: textField.center.y))
        
        
        textField.layer.add(animation, forKey: "position")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BetView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.replacingOccurrences(of: ",", with: ".")
    }
}
