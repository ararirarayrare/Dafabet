import UIKit

enum Team: Int, Codable {
    case home = 1
    case away = 2
}

class SavedEventModel: EventModel {
    let betAmount: Double
    let betTeam: Team
    
    init(event: EventModel, betAmount: Double, team: Team) {
        self.betTeam = team
        self.betAmount = betAmount
        super.init(sport: event.sport,
                   eventTitle: event.eventTitle,
                   homeTitle: event.homeTitle,
                   awayTitle: event.awayTitle,
                   dateString: event.dateString,
                   timeString: event.timeString)
    }
    
    private enum CodingKeys: String, CodingKey {
        case betAmount = "betAmount"
        case betTeam = "betTeam"
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(betAmount, forKey: .betAmount)
        try container.encode(betTeam, forKey: .betTeam)
        
        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            betAmount = try container.decode(Double.self, forKey: .betAmount)
        } catch {
            throw error
        }
        betTeam = try container.decode(Team.self, forKey: .betTeam)
        
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
}
