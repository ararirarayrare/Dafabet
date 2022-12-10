
class MainViewModel {
    
    let tableViewModel: SearchTableViewModel

    var userDefaultsManager: UserDefaultsManager!
    
    init(tableViewModels: [SearchTableViewSectionModel]) {
        var shuffeled = tableViewModels.compactMap {
            SearchTableViewSectionModel(title: $0.title,
                                        events: $0.events.shuffled())
        }
        shuffeled[0].isOpen = true
        tableViewModel = SearchTableViewModel(sectionModels: shuffeled)
    }
    
    func saveBet(event: EventModel, betAmount: Double, team: Team) {
        let event = SavedEventModel(event: event, betAmount: betAmount, team: team)
        userDefaultsManager.savedEvents.append(event)
    }
    
}
