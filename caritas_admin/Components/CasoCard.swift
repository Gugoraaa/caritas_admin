import SwiftUI

struct CasoCard: View {
    var caso: Caso

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 16) {
                ClaveCaso(clave: caso.clave, casoId: caso.id, tamano: 64)

                VStack(alignment: .leading, spacing: 4) {
                    Text(caso.nombre)
                        .font(.title3)
                        .bold()
                        .foregroundColor(Palette.textoPrincipal)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(caso.beneficiarios)
                        .font(.subheadline)
                        .foregroundColor(Palette.textoSecundario)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .foregroundColor(Palette.textoSecundario)
            }

            Text(caso.objetivo)
                .font(.body)
                .foregroundColor(Palette.textoPrincipal)

            VStack(spacing: 10) {
                ProgressView(value: min(caso.recaudado, caso.meta), total: caso.meta)
                    .tint(Palette.colorCaso(caso.id))
                    .scaleEffect(x: 1, y: 2)

                HStack {
                    Text("\(formatoPesos(caso.recaudado)) · \(caso.porcentaje)%")
                        .bold()
                        .foregroundColor(Palette.textoPrincipal)
                    Spacer()
                    Text("Objetivo \(formatoPesos(caso.meta))")
                        .foregroundColor(Palette.textoSecundario)
                }
                .font(.subheadline)
            }

            Divider()

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Responsable")
                        .font(.caption)
                        .foregroundColor(Palette.textoSecundario)
                    Text(caso.responsable)
                        .font(.subheadline)
                        .foregroundColor(Palette.textoPrincipal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Lugar")
                        .font(.caption)
                        .foregroundColor(Palette.textoSecundario)
                    Text(caso.lugar)
                        .font(.subheadline)
                        .foregroundColor(Palette.textoPrincipal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(28)
        .background(Palette.superficie)
        .clipShape(.rect(cornerRadius: 24))
    }
}

#Preview {
    CasoCard(caso: casosEjemplo[0])
        .padding()
        .background(Palette.fondo)
}
