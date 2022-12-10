
class SavedMatchesViewModel {

    var userDefaultsManager: UserDefaultsManager!
    
    var savedEventsIsEmpty: Bool {
        return userDefaultsManager.savedEvents.isEmpty
    }
    
    private var tableViewModel: SavedMatchesTableViewModel!
    
    func getTableViewModel() -> SavedMatchesTableViewModel {
        tableViewModel = SavedMatchesTableViewModel()
        tableViewModel.userDefaultsManager = userDefaultsManager
        return tableViewModel
    }
    
    
}
