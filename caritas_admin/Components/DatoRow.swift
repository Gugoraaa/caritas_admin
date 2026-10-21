import SwiftUI

struct DatoRow: View {
    var etiqueta: String
    var valor: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(etiqueta)
                .foregroundColor(Palette.textoSecundario)
            Spacer()
            Text(valor)
                .foregroundColor(Palette.textoPrincipal)
                .multilineTextAlignment(.trailing)
        }
        .font(.body)
        .padding(.vertical, 14)
    }
}

#Preview {
    DatoRow(etiqueta: "Responsable", valor: "Hna. Teresa Ibarra")
        .padding()
}
