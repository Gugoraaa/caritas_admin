import SwiftUI

struct ChipFiltro: View {
    var texto: String
    var seleccionado: Bool
    var accion: () -> Void

    var body: some View {
        Button {
            accion()
        } label: {
            Text(texto)
                .font(.subheadline)
                .bold()
                .foregroundColor(seleccionado ? Palette.superficie : Palette.textoPrincipal)
                .padding(.horizontal, 16)
                .frame(minHeight: 44)
                .background(seleccionado ? Palette.acento : Palette.chip)
                .clipShape(.capsule)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        ChipFiltro(texto: "Todos", seleccionado: true) {}
        ChipFiltro(texto: "Bajo", seleccionado: false) {}
    }
}
