import Foundation

// "$1,000" — sin decimales, como se muestra en las tablas
func formatoPesos(_ monto: Double) -> String {
    return "$" + monto.formatted(.number.precision(.fractionLength(0)))
}

// "Sergio Alonso Treviño Garza" -> "SA"
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

// El API manda fechas sin zona horaria: "2026-03-10T00:00:00"
func fechaDesdeAPI(_ texto: String) -> Date? {
    let formato = DateFormatter()
    formato.locale = Locale(identifier: "en_US_POSIX")
    formato.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formato.date(from: String(texto.prefix(19)))
}

// "10 mar 2026"
func formatoFecha(_ fecha: Date) -> String {
    let formato = DateFormatter()
    formato.locale = Locale(identifier: "es_MX")
    formato.dateFormat = "d MMM yyyy"
    return formato.string(from: fecha).replacingOccurrences(of: ".", with: "")
}

// "Octubre 2026"
func mesActual() -> String {
    let formato = DateFormatter()
    formato.locale = Locale(identifier: "es_MX")
    formato.dateFormat = "MMMM yyyy"
    return formato.string(from: Date()).capitalized
}
