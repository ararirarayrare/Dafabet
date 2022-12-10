import Foundation

struct TeamsResponce : Codable {
    let teams : [TeamJSON]?

    enum CodingKeys: String, CodingKey {
        case teams = "teams"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        teams = try values.decodeIfPresent([TeamJSON].self, forKey: .teams)
    }

}

struct TeamJSON : Codable {

    let idTeam: String?
    let strTeam: String?

    enum CodingKeys: String, CodingKey {
        case idTeam = "idTeam"
        case strTeam = "strTeam"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        idTeam = try values.decodeIfPresent(String.self, forKey: .idTeam)
        strTeam = try values.decodeIfPresent(String.self, forKey: .strTeam)
    }
}
