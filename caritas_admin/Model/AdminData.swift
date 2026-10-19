import Foundation

struct ResumenAdmin: Decodable {
    struct Periodo: Decodable {
        let start: String
        let end: String
    }

    struct Recaudacion: Decodable {
        struct Semana: Decodable, Identifiable {
            let start: String
            let end: String
            let total: String
            var id: String { start }
        }

        let total: String
        let weeklyTotals: [Semana]

        enum CodingKeys: String, CodingKey {
            case total
            case weeklyTotals = "weekly_totals"
        }
    }

    struct Resultado: Decodable, Identifiable {
        let outcome: String
        let callCount: Int
        var id: String { outcome }

        enum CodingKeys: String, CodingKey {
            case outcome
            case callCount = "call_count"
        }
    }

    struct Responsable: Decodable, Identifiable {
        let userId: Int
        let userName: String
        let callCount: Int
        let promiseCount: Int
        var id: Int { userId }

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case userName = "user_name"
            case callCount = "call_count"
            case promiseCount = "promise_count"
        }
    }

    struct Riesgo: Decodable {
        let green: Int
        let yellow: Int
        let red: Int
        var total: Int { green + yellow + red }
    }

    let period: Periodo
    let fundraising: Recaudacion
    let callOutcomes: [Resultado]
    let callsByResponsible: [Responsable]
    let donorRisk: Riesgo

    enum CodingKeys: String, CodingKey {
        case period, fundraising
        case callOutcomes = "call_outcomes"
        case callsByResponsible = "calls_by_responsible"
        case donorRisk = "donor_risk"
    }
}

struct LlamadaAdmin: Decodable, Identifiable {
    let callId: Int
    let donorId: Int
    let donorFullName: String
    let userId: Int?
    let userName: String?
    let result: String
    let callStatus: String
    let scheduledDate: String?

    var id: Int { callId }

    enum CodingKeys: String, CodingKey {
        case callId = "call_id"
        case donorId = "donor_id"
        case donorFullName = "donor_full_name"
        case userId = "user_id"
        case userName = "user_name"
        case result
        case callStatus = "call_status"
        case scheduledDate = "scheduled_date"
    }
}

struct UsuarioAdmin: Decodable, Identifiable {
    let id: Int
    let name: String
    let role: String
}
