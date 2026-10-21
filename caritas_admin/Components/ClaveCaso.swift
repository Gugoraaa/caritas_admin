import SwiftUI

struct ClaveCaso: View {
    var clave: String
    var casoId: Int
    var tamano: CGFloat

    var body: some View {
        Text(clave)
            .font(.system(size: tamano * 0.42))
            .bold()
            .foregroundColor(Palette.colorCaso(casoId))
            .frame(width: tamano, height: tamano)
            .background(Palette.colorCasoClaro(casoId))
            .clipShape(.rect(cornerRadius: tamano * 0.25))
    }
}

#Preview {
    HStack {
        ClaveCaso(clave: "CO", casoId: 1, tamano: 64)
        ClaveCaso(clave: "BE", casoId: 2, tamano: 28)
    }
}
