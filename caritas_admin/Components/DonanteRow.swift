import SwiftUI

// Un renglón de la tabla de Donantes
struct DonanteRow: View {
    var donante: Donante

    // "Anáhuac · SPEI"; si no hay colonia, solo el método
    var subtitulo: String {
        if let colonia = donante.colonia {
            return "\(colonia) · \(donante.metodoPago)"
        }
        return donante.metodoPago
    }

    var body: some View {
        HStack(spacing: 16) {
            // Avatar con iniciales
            Text(iniciales(donante.nombre))
                .font(.headline)
                .foregroundColor(Palette.avatares[donante.id % Palette.avatares.count])
                .frame(width: 44, height: 44)
                .background(Palette.avataresClaros[donante.id % Palette.avataresClaros.count])
                .clipShape(.circle)

            VStack(alignment: .leading, spacing: 2) {
                Text(donante.nombre)
                    .font(.body)
                    .foregroundColor(Palette.textoPrincipal)
                Text(subtitulo)
                    .font(.subheadline)
                    .foregroundColor(Palette.textoSecundario)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {
                if let casoId = donante.casoId, let clave = donante.casoClave {
                    ClaveCaso(clave: clave, casoId: casoId, tamano: 28)
                    Text(donante.casoNombreCorto ?? "")
                        .font(.subheadline)
                        .foregroundColor(Palette.textoSecundario)
                }
            }
            .frame(width: 170, alignment: .leading)

            Text(donante.monto.map { formatoPesos($0) } ?? "—")
                .font(.title3)
                .bold()
                .foregroundColor(Palette.textoPrincipal)
                .frame(width: 100, alignment: .trailing)

            Text(donante.ultimoDonativo.map { formatoFecha($0) } ?? "Sin donativos")
                .font(.subheadline)
                .foregroundColor(Palette.textoSecundario)
                .frame(width: 110, alignment: .trailing)

            RiesgoBadge(riesgo: donante.riesgo)
                .frame(width: 90, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

#Preview {
    DonanteRow(donante: donantesEjemplo[0])
}
