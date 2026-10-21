import Foundation

func formatoPesos(_ monto: Double) -> String {
    return "$" + monto.formatted(.number.precision(.fractionLength(0)))
}

func iniciales(_ nombre: String) -> String {
    let palabras = nombre.split(separator: " ")
    var resultado = ""
    for palabra in palabras.prefix(2) {
        if let letra = palabra.first {
            resultado += String(letra)
        }
    }
    return resultado.uppercased()
}

func fechaDesdeAPI(_ texto: String) -> Date? {
    let formato = DateFormatter()
    formato.locale = Locale(identifier: "en_US_POSIX")
    formato.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formato.date(from: String(texto.prefix(19)))
}

func fechaFinDesdeAPI(_ texto: String) -> Date? {
    let formato = DateFormatter()
    formato.locale = Locale(identifier: "en_US_POSIX")
    formato.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    return formato.date(from: texto)
}

func formatoFecha(_ fecha: Date) -> String {
    let formato = DateFormatter()
    formato.locale = Locale(identifier: "es_MX")
    formato.dateFormat = "d MMM yyyy"
    return formato.string(from: fecha).replacingOccurrences(of: ".", with: "")
}

func formatoMes(_ fecha: Date) -> String {
    let formato = DateFormatter()
    formato.locale = Locale(identifier: "es_MX")
    formato.timeZone = TimeZone(identifier: "UTC")
    formato.dateFormat = "MMMM yyyy"
    return formato.string(from: fecha)
}

func mesActual() -> String {
    let formato = DateFormatter()
    formato.locale = Locale(identifier: "es_MX")
    formato.dateFormat = "MMMM yyyy"
    return formato.string(from: Date()).capitalized
}
