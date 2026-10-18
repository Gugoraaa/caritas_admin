import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ResumenView()
                .tabItem {
                    Label("Resumen", systemImage: "chart.bar.fill")
                }

            LlamadasView()
                .tabItem {
                    Label("Llamadas", systemImage: "phone.fill")
                }

            DonantesView()
                .tabItem {
                    Label("Donantes", systemImage: "person.2.fill")
                }

            CasosView()
                .tabItem {
                    Label("Casos", systemImage: "heart.text.square.fill")
                }

            AjustesView()
                .tabItem {
                    Label("Ajustes", systemImage: "gearshape.fill")
                }
        }
        .tint(Palette.acento)
    }
}

#Preview {
    ContentView()
}
