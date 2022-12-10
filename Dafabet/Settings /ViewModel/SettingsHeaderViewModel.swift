import UIKit

class SettingsHeaderViewModel {
    
    var userDefaultsManager: UserDefaultsManager!
    
    var userImage: UIImage? {
        userDefaultsManager.userImage
    }
    
    var userName: String {
        userDefaultsManager.userName ?? "User"
    }
    
    func saveImage(_ image: UIImage?) {
        userDefaultsManager.userImage = image
    }
    
    func saveUsername(_ name: String?) {
        userDefaultsManager.userName = name
    }
    
}
