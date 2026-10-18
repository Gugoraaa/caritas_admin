import SwiftUI

struct RiesgoBadge: View {
    var riesgo: String

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .frame(width: 7, height: 7)
            Text(riesgo)
                .font(.subheadline)
                .bold()
        }
        .foregroundColor(Palette.colorRiesgo(riesgo))
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Palette.colorRiesgoClaro(riesgo))
        .clipShape(.capsule)
    }
}

#Preview {
    VStack {
        RiesgoBadge(riesgo: "Alto")
        RiesgoBadge(riesgo: "Medio")
        RiesgoBadge(riesgo: "Bajo")
    }
}
