
class SavedMatchesTableViewModel {
    
    var userDefaultsManager: UserDefaultsManager!

    var numberOfRows: Int {
        return userDefaultsManager.savedEvents.count
    }
    
    func event(for row: Int) -> SavedEventModel {
        return userDefaultsManager.savedEvents[row]
    }
    
    func removeEvent(at row: Int) {
        userDefaultsManager.savedEvents.remove(at: row)
    }
}
