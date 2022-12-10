import UIKit

class Settings {
    
    private let userDefaultsManager: UserDefaultsManager
    
    init(userDefaultsManager: UserDefaultsManager) {
        self.userDefaultsManager = userDefaultsManager
    }
    
    var vibrate: Bool {
        !userDefaultsManager.isVibrationDisabled
    }
    
    func vibrateIfAllowed(_ feebackType: UINotificationFeedbackGenerator.FeedbackType) {
        guard vibrate else {
            return
        }
        
        UINotificationFeedbackGenerator().notificationOccurred(feebackType)
    }
    
    func selectionIfAllowed() {
        guard vibrate else {
            return
        }
        
        UISelectionFeedbackGenerator().selectionChanged()
    }
}
