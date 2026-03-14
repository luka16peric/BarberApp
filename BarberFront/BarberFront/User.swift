import Foundation

struct User: Codable, Identifiable {
    var id: Int? // Opcionalno jer ga baza dodjeljuje
    var firstName: String
    var lastName: String
    var email: String
    var passwordHash: String
    var role: String // "Barber" ili "Client"
}
