import Foundation

struct EventResponce : Codable {
    let events : [EventJSON]?

    enum CodingKeys: String, CodingKey {
        case events = "events"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        events = try values.decodeIfPresent([EventJSON].self, forKey: .events)
    }

}

struct EventJSON : Codable {
    let strEvent: String?
    
    let dateEvent: String?
    
    let strHomeTeam: String?
    let strAwayTeam: String?
    
    let strTime: String?
    
    enum CodingKeys: String, CodingKey {
        case strEvent = "strEvent"
        case dateEvent = "dateEvent"
        case strHomeTeam = "strHomeTeam"
        case strAwayTeam = "strAwayTeam"
        case strTime = "strTime"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        strEvent = try values.decodeIfPresent(String.self, forKey: .strEvent)
        dateEvent = try values.decodeIfPresent(String.self, forKey: .dateEvent)
        strHomeTeam = try values.decodeIfPresent(String.self, forKey: .strHomeTeam)
        strAwayTeam = try values.decodeIfPresent(String.self, forKey: .strAwayTeam)
        strTime = try values.decodeIfPresent(String.self, forKey: .strTime)
    }
}
