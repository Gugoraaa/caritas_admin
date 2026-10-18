import SwiftUI

// Paleta centralizada: todos los colores de la app viven aquí.
// Contraste verificado (WCAG): todos los pares texto/fondo son >= 4.5:1.
struct Palette {
    static let fondo           = Color(red: 242/255, green: 242/255, blue: 247/255)
    static let superficie      = Color(red: 255/255, green: 255/255, blue: 255/255)
    static let acento          = Color(red:  37/255, green:  99/255, blue: 235/255)
    static let textoPrincipal  = Color(red:  17/255, green:  17/255, blue:  17/255)
    static let textoSecundario = Color(red: 110/255, green: 110/255, blue: 115/255)
    static let chip            = Color(red: 229/255, green: 229/255, blue: 234/255)
    static let error           = Color(red: 185/255, green:  28/255, blue:  28/255)

    // Colores de avatar; se elige uno según el id del donante
    static let avatares = [
        Color(red:  67/255, green:  56/255, blue: 202/255),
        Color(red: 126/255, green:  34/255, blue: 206/255),
        Color(red: 194/255, green:  65/255, blue:  12/255),
        Color(red:  29/255, green:  78/255, blue: 216/255),
        Color(red:  15/255, green: 118/255, blue: 110/255)
    ]
    static let avataresClaros = [
        Color(red: 224/255, green: 231/255, blue: 255/255),
        Color(red: 243/255, green: 232/255, blue: 255/255),
        Color(red: 255/255, green: 237/255, blue: 213/255),
        Color(red: 219/255, green: 234/255, blue: 254/255),
        Color(red: 204/255, green: 251/255, blue: 241/255)
    ]

    // Color de cada caso según su id (1 = naranja, 2 = azul, 3 = rojo, 4 = índigo...).
    // Con el módulo, cualquier id nuevo del API cae en un color de la lista.
    static let casos = [
        Color(red: 194/255, green:  65/255, blue:  12/255),
        Color(red:  29/255, green:  78/255, blue: 216/255),
        Color(red: 185/255, green:  28/255, blue:  28/255),
        Color(red:  67/255, green:  56/255, blue: 202/255),
        Color(red: 126/255, green:  34/255, blue: 206/255),
        Color(red:  15/255, green: 118/255, blue: 110/255)
    ]
    static let casosClaros = [
        Color(red: 255/255, green: 237/255, blue: 213/255),
        Color(red: 219/255, green: 234/255, blue: 254/255),
        Color(red: 254/255, green: 226/255, blue: 226/255),
        Color(red: 224/255, green: 231/255, blue: 255/255),
        Color(red: 243/255, green: 232/255, blue: 255/255),
        Color(red: 204/255, green: 251/255, blue: 241/255)
    ]

    // Posición en la lista; el segundo módulo evita índices negativos
    private static func indiceCaso(_ id: Int) -> Int {
        return ((id - 1) % casos.count + casos.count) % casos.count
    }

    static func colorCaso(_ id: Int) -> Color {
        return casos[indiceCaso(id)]
    }

    static func colorCasoClaro(_ id: Int) -> Color {
        return casosClaros[indiceCaso(id)]
    }

    static func colorRiesgo(_ riesgo: String) -> Color {
        switch riesgo {
        case "Alto":  return Color(red: 185/255, green:  28/255, blue:  28/255)
        case "Medio": return Color(red: 194/255, green:  65/255, blue:  12/255)
        default:      return Color(red:  21/255, green: 128/255, blue:  61/255)
        }
    }

    static func colorRiesgoClaro(_ riesgo: String) -> Color {
        switch riesgo {
        case "Alto":  return Color(red: 254/255, green: 226/255, blue: 226/255)
        case "Medio": return Color(red: 255/255, green: 237/255, blue: 213/255)
        default:      return Color(red: 220/255, green: 252/255, blue: 231/255)
        }
    }
}
