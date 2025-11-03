
import Vapor

struct MusicDTO: Content {
    var id: UUID?
    var nom: String
    var audio: String
    var logo: String
    var planeteMusicId: UUID? 
}

struct PartialMusicDTO: Content {
    var nom: String?
    var audio: String?
    var logo: String?
}
