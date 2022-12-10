import Foundation

struct LeaguesResponce : Codable {
    let leagues : [LeagueJSON]?

    enum CodingKeys: String, CodingKey {
        case leagues = "leagues"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        leagues = try values.decodeIfPresent([LeagueJSON].self, forKey: .leagues)
    }

}

struct LeagueJSON : Codable {
    let idLeague : String?
    let strLeague : String?
    let strSport : String?
    let strLeagueAlternate : String?

    enum CodingKeys: String, CodingKey {
        case idLeague = "idLeague"
        case strLeague = "strLeague"
        case strSport = "strSport"
        case strLeagueAlternate = "strLeagueAlternate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idLeague = try values.decodeIfPresent(String.self, forKey: .idLeague)
        strLeague = try values.decodeIfPresent(String.self, forKey: .strLeague)
        strSport = try values.decodeIfPresent(String.self, forKey: .strSport)
        strLeagueAlternate = try values.decodeIfPresent(String.self, forKey: .strLeagueAlternate)
    }
}
