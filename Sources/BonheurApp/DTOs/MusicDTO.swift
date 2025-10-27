
import Vapor

struct MusicDTO: Content {
    var id: UUID?
    var nom: String
    var planeteMusiqueId: UUID?
    var audio: String
    var logo: String
}

struct PartialMusicDTO: Content {
    var nom: String?
    var planeteMusicId: UUID?
}
