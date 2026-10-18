import Foundation

struct Caso: Identifiable, Codable {
    var id: Int
    var clave: String          // "CO", "BE", "DE", "CH"
    var nombre: String         // "Comedor Comunitario San Bernabé"
    var nombreCorto: String    // "Comedor"
    var beneficiarios: String  // "240 familias de la zona norte"
    var objetivo: String
    var recaudado: Double
    var meta: Double
    var responsable: String
    var lugar: String

    // Porcentaje redondeado de avance (0 a 100)
    var porcentaje: Int {
        if meta == 0 {
            return 0
        }
        return Int((recaudado / meta * 100).rounded())
    }
}

// JSON de GET /causas. Los montos llegan como texto decimal ("220000.00") y
// varios campos pueden venir null, por eso se decodifica aquí y se convierte a Caso.
struct CausaRespuesta: Codable {
    var id: Int
    var titulo: String
    var descripcion: String?
    var montoObjetivo: String
    var montoRecaudado: String?
    var beneficiario: String?
    var responsable: String?
    var lugar: String?
    var clave: String?
    var nombreCorto: String?

    enum CodingKeys: String, CodingKey {
        case id
        case titulo
        case descripcion
        case montoObjetivo = "monto_objetivo"
        case montoRecaudado = "monto_recaudado"
        case beneficiario
        case responsable
        case lugar
        case clave
        case nombreCorto = "nombre_corto"
    }

    var caso: Caso {
        return Caso(
            id: id,
            clave: clave ?? iniciales(titulo),
            nombre: titulo,
            nombreCorto: nombreCorto ?? titulo,
            beneficiarios: beneficiario ?? "Sin registro",
            objetivo: descripcion ?? "",
            recaudado: Double(montoRecaudado ?? "") ?? 0,
            meta: Double(montoObjetivo) ?? 0,
            responsable: responsable ?? "Sin registro",
            lugar: lugar ?? "Sin registro"
        )
    }
}
