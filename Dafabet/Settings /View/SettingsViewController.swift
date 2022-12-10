import UIKit

class SettingsViewController: BaseVC {
    
    weak var viewModel: SettingsViewModel!
    
    private lazy var headerView: SettingsHeaderView = {
        let headerView = SettingsHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.delegate = self
        headerView.viewModel = viewModel.getHeaderViewModel()
        return headerView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        
        stackView.layer.cornerRadius = 16
        stackView.layer.masksToBounds = true
                        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

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
        
        setupSettingsStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
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

    private func createSettingView(title: String, type: SettingView.SettingViewType) -> SettingView {
        let settingView = SettingView(type: type, text: title)
        settingView.delegate = self
        settingView.translatesAutoresizingMaskIntoConstraints = false
        
        return settingView
    }
    
    fileprivate enum SettingTitle: String {
        case notifications = "Notifications"
        case vibrations = "Vibrations"
        case privacyPolicy = "Privacy Policy"
        case shareApp = "Share app"
    }

    private func setupSettingsStackView() {
        let stackViewBottomConstraint = stackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -24
        )
        stackViewBottomConstraint.priority = .defaultLow
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor,
                                           constant: 24),
            stackViewBottomConstraint
        ])
        
        let notificationsSetiingView = createSettingView(title: SettingTitle.notifications.rawValue,
                                                         type: .uiSwitch(viewModel.isNotificationsAllowed))
        stackView.addArrangedSubview(notificationsSetiingView)
        notificationsSetiingView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        let vibrationsSetiingView = createSettingView(title: SettingTitle.vibrations.rawValue,
                                                      type: .uiSwitch(viewModel.isVibrationAllowed))
        stackView.addArrangedSubview(vibrationsSetiingView)
        vibrationsSetiingView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        
        let privacyPolicySettingView = createSettingView(title: SettingTitle.privacyPolicy.rawValue,
                                                         type: .button(.chevron))
        stackView.addArrangedSubview(privacyPolicySettingView)
        privacyPolicySettingView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        
        let shareAppSettingView = createSettingView(title: SettingTitle.shareApp.rawValue,
                                                    type: .button(.share))
        stackView.addArrangedSubview(shareAppSettingView)
        shareAppSettingView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}

extension SettingsViewController: SettingsHeaderViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func headerView(_ headerView: SettingsHeaderView, didBeginEditingImageView imageView: UIImageView) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            headerView.setImage(image)
            (UIApplication.shared.delegate as? AppDelegate)?.settings.vibrateIfAllowed(.success)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func headerView(_ headerView: SettingsHeaderView, didBeginEditingLabel label: UILabel) {
        let alertController = UIAlertController(title: "Edit username:", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.text = label.text
            textField.placeholder = "User name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textfield = alertController.textFields?.first, textfield.text != "" else {
                return
            }
            (UIApplication.shared.delegate as? AppDelegate)?.settings.vibrateIfAllowed(.success)
            headerView.setUsername(textfield.text)
        }
        alertController.addAction(saveAction)
        
        present(alertController, animated: true)
    }
}

extension SettingsViewController: SettingViewDelegate {
    func settingsView(_ settingsView: SettingView, pressedSwitch uiSwitch: UISwitch) {
        (UIApplication.shared.delegate as? AppDelegate)?.settings.selectionIfAllowed()
        switch uiSwitch.accessibilityIdentifier {
        case SettingTitle.notifications.rawValue:
            viewModel.isNotificationsAllowed = uiSwitch.isOn
        case SettingTitle.vibrations.rawValue:
            viewModel.isVibrationAllowed = uiSwitch.isOn
        default:
            break
        }
    }
    
    func settingsView(_ settingsView: SettingView, pressedButton button: UIButton) {
        (UIApplication.shared.delegate as? AppDelegate)?.settings.selectionIfAllowed()
        switch button.accessibilityIdentifier {
        case SettingTitle.privacyPolicy.rawValue:
            if let url = URL(string: viewModel.privacyPolicyLink) {
                let webController = WebViewController(url: url)
                webController.prefersNavBarHidden = false
                navigationController?.pushViewController(webController, animated: true)
            }
        case SettingTitle.shareApp.rawValue:
            guard let link = URL(string: viewModel.appStoreLink) else {
                return
            }
            let activityVC = UIActivityViewController(activityItems: [link],
                                                      applicationActivities: nil)
            present(activityVC, animated: true)
        default:
            break
        }
    }
}
