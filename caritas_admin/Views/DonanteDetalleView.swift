import SwiftUI

struct DonanteDetalleView: View {
    var donante: Donante

    var textoDiasSinDonar: String {
        if let dias = donante.diasSinDonar {
            if dias == 1 {
                return "Hace 1 día"
            }
            return "Hace \(dias) días"
        }
        return "Sin donativos"
    }

    var body: some View {
        ZStack {
            Palette.fondo
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(alignment: .center, spacing: 20) {
                        AvatarDonante(nombre: donante.nombre, donanteId: donante.id, tamano: 88)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(donante.nombre)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Palette.textoPrincipal)
                                .fixedSize(horizontal: false, vertical: true)
                            Text(donante.colonia ?? "Sin colonia registrada")
                                .font(.title3)
                                .foregroundColor(Palette.textoSecundario)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        RiesgoBadge(riesgo: donante.riesgo)
                    }
                    .padding(28)
                    .background(Palette.superficie)
                    .clipShape(.rect(cornerRadius: 24))

                    HStack(spacing: 24) {
                        datoGrande(titulo: "Último donativo",
                                   valor: donante.monto.map { formatoPesos($0) } ?? "—")
                        datoGrande(titulo: "Fecha",
                                   valor: donante.ultimoDonativo.map { formatoFecha($0) } ?? "—")
                        datoGrande(titulo: "Sin donar",
                                   valor: textoDiasSinDonar)
                    }

                    HStack(alignment: .top, spacing: 24) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Información")
                                .font(.title3)
                                .bold()
                                .foregroundColor(Palette.textoPrincipal)
                                .padding(.bottom, 8)

                            DatoRow(etiqueta: "Nombre", valor: donante.nombre)
                            Divider()
                            DatoRow(etiqueta: "Colonia", valor: donante.colonia ?? "Sin registro")
                            Divider()
                            DatoRow(etiqueta: "Método de pago", valor: donante.metodoPago)
                            Divider()
                            DatoRow(etiqueta: "Riesgo", valor: donante.riesgo)
                        }
                        .padding(28)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Palette.superficie)
                        .clipShape(.rect(cornerRadius: 24))

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Caso asignado")
                                .font(.title3)
                                .bold()
                                .foregroundColor(Palette.textoPrincipal)

                            if let casoId = donante.casoId, let clave = donante.casoClave {
                                HStack(spacing: 16) {
                                    ClaveCaso(clave: clave, casoId: casoId, tamano: 56)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(donante.casoNombre ?? donante.casoNombreCorto ?? "Caso \(casoId)")
                                            .font(.headline)
                                            .foregroundColor(Palette.textoPrincipal)
                                            .fixedSize(horizontal: false, vertical: true)
                                        Text(donante.casoNombreCorto ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(Palette.textoSecundario)
                                    }
                                }
                            } else {
                                Text("Este donante no tiene un caso asignado.")
                                    .font(.body)
                                    .foregroundColor(Palette.textoSecundario)
                            }
                        }
                        .padding(28)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Palette.superficie)
                        .clipShape(.rect(cornerRadius: 24))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 24)
            }
        }
        .navigationTitle("Donante")
        .toolbarTitleDisplayMode(.inline)
    }

    func datoGrande(titulo: String, valor: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.subheadline)
                .foregroundColor(Palette.textoSecundario)
            Text(valor)
                .font(.title2)
                .bold()
                .foregroundColor(Palette.textoPrincipal)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Palette.superficie)
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    NavigationStack {
        DonanteDetalleView(donante: donantesEjemplo[0])
    }
}
