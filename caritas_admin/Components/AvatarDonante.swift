import SwiftUI

struct AvatarDonante: View {
    var nombre: String
    var donanteId: Int
    var tamano: CGFloat

    var body: some View {
        Text(iniciales(nombre))
            .font(.system(size: tamano * 0.38))
            .bold()
            .foregroundColor(Palette.avatares[donanteId % Palette.avatares.count])
            .frame(width: tamano, height: tamano)
            .background(Palette.avataresClaros[donanteId % Palette.avataresClaros.count])
            .clipShape(.circle)
    }
}

#Preview {
    HStack {
        AvatarDonante(nombre: "Sergio Alonso Treviño Garza", donanteId: 1, tamano: 88)
        AvatarDonante(nombre: "Alicia Montemayor", donanteId: 2, tamano: 44)
    }
}
