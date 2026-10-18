import Foundation

struct Donante: Identifiable, Codable {
    var id: Int
    var nombre: String
    var colonia: String?
    var metodoPago: String       // "Efectivo", "SPEI" o "—"
    var casoId: Int?
    var casoClave: String?
    var casoNombreCorto: String?
    var monto: Double?           // monto del último donativo
    var ultimoDonativo: Date?
    var riesgo: String           // "Bajo", "Medio" o "Alto"
}

// JSON de GET /admin/donors
struct DonanteRespuesta: Codable {
    var id: Int
    var fullName: String
    var neighborhood: String?
    var causa: CausaResumen?
    var lastDonationAt: String?
    var lastDonationAmount: String?
    var paymentMethod: String?
    var risk: RiesgoRespuesta

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case neighborhood
        case causa
        case lastDonationAt = "last_donation_at"
        case lastDonationAmount = "last_donation_amount"
        case paymentMethod = "payment_method"
        case risk
    }

    var donante: Donante {
        return Donante(
            id: id,
            nombre: fullName,
            colonia: neighborhood,
            metodoPago: textoMetodoPago,
            casoId: causa?.id,
            casoClave: causa?.clave ?? causa.map { iniciales($0.titulo) },
            casoNombreCorto: causa?.nombreCorto ?? causa?.titulo,
            monto: lastDonationAmount.flatMap { Double($0) },
            ultimoDonativo: lastDonationAt.flatMap { fechaDesdeAPI($0) },
            riesgo: textoRiesgo
        )
    }

    private var textoMetodoPago: String {
        switch paymentMethod {
        case "efectivo": return "Efectivo"
        case "spei":     return "SPEI"
        default:         return "—"
        }
    }

    private var textoRiesgo: String {
        switch risk.level {
        case "green":  return "Bajo"
        case "yellow": return "Medio"
        default:       return "Alto"
        }
    }
}

struct CausaResumen: Codable {
    var id: Int
    var titulo: String
    var clave: String?
    var nombreCorto: String?

    enum CodingKeys: String, CodingKey {
        case id
        case titulo
        case clave
        case nombreCorto = "nombre_corto"
    }
}

struct RiesgoRespuesta: Codable {
    var level: String               // "green", "yellow" o "red"
    var daysWithoutDonating: Int?

    enum CodingKeys: String, CodingKey {
        case level
        case daysWithoutDonating = "days_without_donating"
    }
}
