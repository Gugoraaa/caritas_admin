import Foundation

struct Caso: Identifiable, Codable {
    var id: Int
    var clave: String
    var nombre: String
    var nombreCorto: String
    var beneficiarios: String
    var objetivo: String
    var recaudado: Double
    var meta: Double
    var responsable: String
    var lugar: String
    var fechaFin: Date? = nil

    var porcentaje: Int {
        if meta == 0 {
            return 0
        }
        return Int((recaudado / meta * 100).rounded())
    }
}

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
    var fechaFin: String?

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
        case fechaFin = "fecha_fin"
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
            lugar: lugar ?? "Sin registro",
            fechaFin: fechaFinDesdeAPI(fechaFin ?? "")
        )
    }
}
