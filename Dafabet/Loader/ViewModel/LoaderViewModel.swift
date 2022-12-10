import Foundation

class LoaderViewModel {
    
    var mainViewModel: MainViewModel?
    var savedMatchesViewModel: SavedMatchesViewModel!
    var settingsViewModel: SettingsViewModel!
    
    private(set) var isPerformingRequest: Bool = false
    
    let networkManager: NetworkManager
    let userDefaultsManager: UserDefaultsManager
    
    init(networkManager: NetworkManager, userDefaultsManager: UserDefaultsManager) {
        self.networkManager = networkManager
        self.userDefaultsManager = userDefaultsManager
    }
    
    func getMainViewModel(_ handler: @escaping (MainViewModel?, NetworkManager.RequestError?) -> Void) {
        
        // request list of leagues
        isPerformingRequest = true
        networkManager.requestLeagues { [weak self] (leaguesJson, error) in
            guard let leaguesJson = leaguesJson, error == nil else {
                DispatchQueue.main.async { [weak self] in
                    handler(nil, error)
                    self?.isPerformingRequest = false
                }
                return
            }
            
            // reduce list of leagues to one league according to given sport
            let sports = [ "Cricket", "Soccer", "Basketball", "Baseball", "Volleyball" ]
            let sportLeagueDictionary = Filter().filter(sportNames: sports, jsonArray: leaguesJson)
            
            var sectionModels = [SearchTableViewSectionModel]()
            // dispatch group to continue only when all team requests received
            let teamsDispatchGroup = DispatchGroup()
            let teamsQueue = DispatchQueue(label: "teams", attributes: .concurrent)
            
            for (sport, league) in sportLeagueDictionary {
                // for each league request a teams list
                teamsDispatchGroup.enter()
                teamsQueue.async() {
                    self?.networkManager.requestTeams(inLeague: league) { [weak self] teamsJson, error in
                        guard let teamsJson = teamsJson, error == nil else {
                            DispatchQueue.main.async { [weak self] in
                                handler(nil, error)
                                self?.isPerformingRequest = false
                            }
                            return
                        }
                        
                        // list of teams identifiers
                        let teamIDs = teamsJson.compactMap ({ $0.idTeam })
                        
                        var eventModels = [EventModel]()
                        // dispatch group to continue only when all event requests received
                        let eventsDispatchGroup = DispatchGroup()
                        let eventsQueue = DispatchQueue(label: "events", attributes: .concurrent)
                        
                        teamIDs.forEach { teamID in
                            // request list of events for each team by identifier
                            eventsDispatchGroup.enter()
                            eventsQueue.async() {
                                self?.networkManager.requestEvents(for: teamID) { events, error in
                                    // get only first event
                                    guard let firstEvent = events?.first, error == nil else {
                                        eventsDispatchGroup.leave()
                                        return
                                    }
         
                                    // create cell model by first event
                                    
                                    let eventModel = EventModel(sport: sport,
                                                                eventTitle: firstEvent.strEvent,
                                                                homeTitle: firstEvent.strHomeTeam,
                                                                awayTitle: firstEvent.strAwayTeam,
                                                                dateString: firstEvent.dateEvent,
                                                                timeString: firstEvent.strTime)
                                    
                                    // append if not containing tha same
                                    if !eventModels.contains(where: { $0 == eventModel }) {
                                        eventModels.append(eventModel)
                                    }
                                    
                                    eventsDispatchGroup.leave()
                                }
                            }
                        }
                        // execute when all events received and handeled
                        eventsDispatchGroup.notify(queue: teamsQueue) {
                            if !eventModels.isEmpty {
                                let sectionModel = SearchTableViewSectionModel(title: sport,
                                                                               events: eventModels)
                                sectionModels.append(sectionModel)
                            }
                            teamsDispatchGroup.leave()
                        }
                        
                    }
                    
                }
                
            }
            
            // execute when all teams received and handeled, and all sectionModels created
            teamsDispatchGroup.notify(queue: .main) { [weak self] in
                self?.mainViewModel = MainViewModel(tableViewModels: sectionModels)
                self?.mainViewModel?.userDefaultsManager = self?.userDefaultsManager
                handler(self?.mainViewModel, nil)
                self?.isPerformingRequest = false
            }
            
        }
        
    }
    
    func getSavedMatchesViewModel() -> SavedMatchesViewModel {
        savedMatchesViewModel = SavedMatchesViewModel()
        savedMatchesViewModel.userDefaultsManager = userDefaultsManager
        return savedMatchesViewModel
    }
    
    func getSettingsViewModel() -> SettingsViewModel {
        settingsViewModel = SettingsViewModel()
        settingsViewModel.userDefaultsManager = userDefaultsManager
        return settingsViewModel
    }
}

class Filter {
    
    func filter(sportNames: [String], jsonArray: [LeagueJSON]) -> [String : String] {
        var filtered = [String : String]()
        
        for json in jsonArray {
            if let sport = json.strSport, let league = json.strLeague {
                if sportNames.contains(sport), !filtered.contains(where: { $0.key == sport }) {
                    filtered.updateValue(league, forKey: sport)
                }
            }
        }
        
        return filtered
    }
    
}
