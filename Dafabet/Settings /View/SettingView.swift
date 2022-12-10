import UIKit

protocol SettingViewDelegate: AnyObject {
    func settingsView(_ settingsView: SettingView, pressedSwitch uiSwitch: UISwitch)
    func settingsView(_ settingsView: SettingView, pressedButton button: UIButton)
}

class SettingView: UIView {
    
    weak var delegate: SettingViewDelegate?
    
    var shapeLayer: CAShapeLayer? {
        didSet {
            guard let shapeLayer = shapeLayer else {
                return
            }
            layer.insertSublayer(shapeLayer, at: 0)
        }
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 26, weight: .medium)
        label.textColor = .white
        return label
    }()

    
    enum SettingViewType {
        case uiSwitch(Bool)
        case button(ButtonType)
    }
    
    init(type: SettingViewType, text: String) {
        super.init(frame: .zero)
        
        backgroundColor = .dafaDarkRed
        
        label.text = text
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        switch type {
        case .uiSwitch(let isOn):
            let uiSwitch = createSwitch()
            uiSwitch.isOn = isOn
            addSubview(uiSwitch)
            NSLayoutConstraint.activate([
                uiSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                uiSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
        case .button(let type):
            let button = createButton(type)
            addSubview(button)
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                button.centerYAnchor.constraint(equalTo: centerYAnchor),
                button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),
                button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.75)
            ])
        }
        
    }

    @objc
    private func switchDidChangeValue(_ sender: UISwitch) {
        delegate?.settingsView(self, pressedSwitch: sender)
    }
    
    @objc
    private func didPressButton(_ sender: UIButton) {
        delegate?.settingsView(self, pressedButton: sender)
    }
    
    private func createSwitch() -> UISwitch {
        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.addTarget(self, action: #selector(switchDidChangeValue(_:)), for: .valueChanged)
        uiSwitch.accessibilityIdentifier = label.text
        
        return uiSwitch
    }
    
    enum ButtonType: String {
        case chevron = "chevron.right"
        case share = "arrowshape.turn.up.forward"
    }
    
    private func createButton(_ type: ButtonType) -> UIButton {
        let button = UIButton()
        button.accessibilityIdentifier = label.text
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 32)
        let image = UIImage(systemName: type.rawValue, withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .white
        
        return button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
