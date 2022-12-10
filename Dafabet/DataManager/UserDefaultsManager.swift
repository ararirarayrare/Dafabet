import UIKit

class UserDefaultsManager {

    struct Keys {
        static let userName = "userName"
        static let userImage = "userImage"
        static let savedMatches = "savedMatches"
        static let vibrationDisabled = "vibrationDisabled"
        static let notificationsDisabled = "notificationsDisabled"
    }
    
    var userName: String? {
        get {
            UserDefaults.standard.string(forKey: Keys.userName)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.userName)
        }
    }
    
    var userImage: UIImage? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Keys.userImage),
                  let decoded = try? PropertyListDecoder().decode(Data.self, from: data) else {
                return UIImage(named: "camera")
            }
            
            return UIImage(data: decoded) ?? UIImage(named: "camera")
        }
        
        set {
            guard let data = newValue?.jpegData(compressionQuality: 0.5),
                  let encoded = try? PropertyListEncoder().encode(data) else {
                return
            }
            
            UserDefaults.standard.set(encoded, forKey: Keys.userImage)
        }
    }
    
    var savedEvents: [SavedEventModel] {
        get {
            if let data = UserDefaults.standard.data(forKey: Keys.savedMatches),
               let models = try? JSONDecoder().decode([SavedEventModel].self,
                                                      from: data) {
                return models
            } else {
                return [SavedEventModel]()
            }
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: Keys.savedMatches)
        }
    }
    
    var isVibrationDisabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.vibrationDisabled)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.vibrationDisabled)
        }
    }
    
    var isNotificationsDisabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.notificationsDisabled)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.notificationsDisabled)
        }
    }
}
