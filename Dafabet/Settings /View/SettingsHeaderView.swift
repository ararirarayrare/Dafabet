import UIKit

protocol SettingsHeaderViewDelegate: AnyObject {
    func headerView(_ headerView: SettingsHeaderView, didBeginEditingImageView imageView: UIImageView)
    func headerView(_ headerView: SettingsHeaderView, didBeginEditingLabel label: UILabel)
}

class SettingsHeaderView: UIView {
    
    weak var delegate: SettingsHeaderViewDelegate?
    
    weak var viewModel: SettingsHeaderViewModel! {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            imageView.image = viewModel.userImage
            label.text = viewModel.userName
        }
    }
    
    private var imageShape: CAShapeLayer? {
        didSet {
            guard let imageShape = imageShape else {
                return
            }
            imageView.layer.addSublayer(imageShape)
        }
    }
    
//    private let userDefaultsManager = UserDefaultsManager()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Copperplate Bold", size: 26)
        label.textColor = .white
        label.textAlignment = .left
        
        label.numberOfLines = 2
        
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var editImageButton: UIButton = createEditButton(withTag: 0, type: .plus)
    private lazy var editLabelButton: UIButton = createEditButton(withTag: 1, type: .edit)
    
    init() {
        super.init(frame: .zero)
        
        layer.cornerRadius = 24
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.45),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        addSubview(editImageButton)
        NSLayoutConstraint.activate([
            editImageButton.centerXAnchor.constraint(equalTo: imageView.trailingAnchor,
                                                    constant: -4),
            editImageButton.centerYAnchor.constraint(equalTo: imageView.bottomAnchor,
                                                     constant: -4),
            editImageButton.widthAnchor.constraint(equalToConstant: 32),
            editImageButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        addSubview(editLabelButton)
        NSLayoutConstraint.activate([
            editLabelButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                      constant: -16),
            editLabelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editLabelButton.widthAnchor.constraint(equalToConstant: 32),
            editLabelButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                           constant: 24),
            label.trailingAnchor.constraint(equalTo: editLabelButton.leadingAnchor,
                                            constant: -24),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageShape == nil {
            let imageShape = CAShapeLayer()
            let cornerRadius = imageView.bounds.height / 2
            imageShape.path = UIBezierPath(roundedRect: imageView.bounds,
                                           cornerRadius: cornerRadius).cgPath
            imageShape.fillColor = UIColor.clear.cgColor
            imageShape.strokeColor = UIColor.white.cgColor
            imageShape.lineWidth = 4.0
            imageShape.strokeEnd = 1
            
            imageView.layer.cornerRadius = cornerRadius
            imageView.layer.masksToBounds = true
            
            self.imageShape = imageShape
            self.animateImageShape()
        }
    }

    private func animateImageShape() {
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.strokeEnd))
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.75
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.isRemovedOnCompletion = true
        
        self.imageShape?.add(animation, forKey: "circle")
    }
    
    func setImage(_ image: UIImage?) {
        viewModel.saveImage(image)
        imageView.image = image
        animateImageShape()
    }
    
    func setUsername(_ name: String?) {
        label.text = name
        viewModel.saveUsername(name)
    }
    
    @objc
    private func editButtonTapped(_ sender: UIButton) {
        (UIApplication.shared.delegate as? AppDelegate)?.settings.selectionIfAllowed()
        switch sender.tag {
        case editImageButton.tag:
            delegate?.headerView(self, didBeginEditingImageView: imageView)
        case editLabelButton.tag:
            delegate?.headerView(self, didBeginEditingLabel: label)
        default:
            break
        }
    }
    
    private enum EditButtonType: String {
        case edit = "square.and.pencil"
        case plus = "plus"
    }
    
    private func createEditButton(withTag tag: Int, type: EditButtonType) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag
        button.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(systemName: type.rawValue, withConfiguration: imageConfig)
        
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .white
        return button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
