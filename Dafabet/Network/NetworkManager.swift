import Foundation

class NetworkManager {
    
    private static let apiKey = "50130162"
    private let baseStringURL = "https://www.thesportsdb.com/api/v1/json/\(apiKey)/"
    
    enum QueryParams: String {
        case leagues = "all_leagues.php"
        case teams = "search_all_teams.php?l="
        case lastEvents5 = "eventslast.php?id="
        case nextEvents5 = "eventsnext.php?id="
        case nextLeagueEvents15 = "eventsnextleague.php?id="
    }
    
    enum RequestError: String, Error {
        case networkConnection = "Please check your internet connection."
        case serverResponce = "Something went wrong with server :(\nWe're already fixing it.\nPlease try again later."
        case URL = "Something went wrong :(Please try again later."
    }
    
    func requestLeagues(_ completion: @escaping ([LeagueJSON]?, RequestError?) -> Void) {
        guard let URL = URL(string: baseStringURL + QueryParams.leagues.rawValue) else {
            completion(nil, .URL)
            return
        }
        
        URLSession.shared.dataTask(with: URL) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil, .networkConnection)
                return
            }
            
            if let leaguesJson = try? JSONDecoder().decode(LeaguesResponce.self, from: data).leagues {
                DispatchQueue.main.async { completion(leaguesJson, nil) }
            } else {
                completion(nil, .serverResponce)
            }
            
        }.resume()
        
    }
    
    func requestTeams(inLeague league: String, _ completion: @escaping ([TeamJSON]?, RequestError?) -> Void) {
        guard let league = league.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let URL = URL(string: baseStringURL + QueryParams.teams.rawValue + league) else {
            completion(nil, .URL)
            return
        }
        
        URLSession.shared.dataTask(with: URL) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil, .networkConnection)
                return
            }
            
            if let teamsJson = try? JSONDecoder().decode(TeamsResponce.self, from: data).teams {
                DispatchQueue.main.async { completion(teamsJson, nil) }
            } else {
                completion(nil, .serverResponce)
            }
            
        }.resume()
    }
    
    func requestEvents(for teamId: String, _ completion: @escaping ([EventJSON]?, RequestError?) -> Void) {
        guard let URL = URL(string: baseStringURL + QueryParams.nextEvents5.rawValue + teamId) else {
            completion(nil, .URL)
            return
        }
                
        URLSession.shared.dataTask(with: URL) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil, .networkConnection)
                return
            }
            
            if let eventsJson = try? JSONDecoder().decode(EventResponce.self, from: data).events {
                DispatchQueue.main.async { completion(eventsJson, nil) }
            } else {
                completion(nil, .serverResponce)
            }
            
            
        }.resume()
    }
}
