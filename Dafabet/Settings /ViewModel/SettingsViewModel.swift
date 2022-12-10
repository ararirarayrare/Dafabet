import Foundation

class SettingsViewModel {
    
    private var headerViewModel: SettingsHeaderViewModel!
    
    var userDefaultsManager: UserDefaultsManager!
    
    var privacyPolicyLink: String {
        "https://docs.google.com/document/d/1GP4fMacvNduHJ-bx0KN5v5gnBMQNCxc5lAMB-z5pKqk/edit?usp=sharing"
    }
    
    var appStoreLink: String {
        "https://stackoverflow.com/questions/35861962/share-app-link-to-by-activityviewcontroller-ios-swift"
    }
    
    var isVibrationAllowed: Bool {
        get {
            !userDefaultsManager.isVibrationDisabled
        }
        
        set {
            userDefaultsManager.isVibrationDisabled = !newValue
        }
    }
    
    var isNotificationsAllowed: Bool {        
        get {
            !userDefaultsManager.isNotificationsDisabled
        }
        
        set {
            userDefaultsManager.isNotificationsDisabled = !newValue
        }
    }
    
    func getHeaderViewModel() -> SettingsHeaderViewModel {
        headerViewModel = SettingsHeaderViewModel()
        headerViewModel.userDefaultsManager = userDefaultsManager
        return headerViewModel
    }
}
