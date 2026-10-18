import Foundation

struct Usuario: Codable {
    var id: Int
    var name: String
    var email: String
    var role: String   // "admin", "coordinador"...
}

struct LoginRequest: Codable {
    var email: String
    var password: String
}

struct LoginResponse: Codable {
    var token: String
    var user: Usuario
}
