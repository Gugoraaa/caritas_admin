import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            Palette.fondo
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 64))
                        .foregroundColor(Palette.acento)
                        .padding(.top, 80)

                    VStack(spacing: 8) {
                        Text("Cáritas de Monterrey")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Palette.textoPrincipal)
                        Text("Panel de administración")
                            .font(.title3)
                            .foregroundColor(Palette.textoSecundario)
                    }

                    VStack(spacing: 12) {
                        // Sin modificadores exclusivos de iOS: el target también compila para macOS
                        TextField("Correo electrónico", text: $email)
                            .textContentType(.username)
                            .autocorrectionDisabled()
                            .padding(.horizontal, 16)
                            .frame(minHeight: 52)
                            .background(Palette.superficie)
                            .clipShape(.rect(cornerRadius: 12))

                        SecureField("Contraseña", text: $password)
                            .textContentType(.password)
                            .padding(.horizontal, 16)
                            .frame(minHeight: 52)
                            .background(Palette.superficie)
                            .clipShape(.rect(cornerRadius: 12))
                    }

                    Button {
                        Task {
                            await iniciarSesion()
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .tint(Palette.superficie)
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 52)
                        } else {
                            Text("Iniciar sesión")
                                .font(.headline)
                                .foregroundColor(Palette.superficie)
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 52)
                        }
                    }
                    .buttonStyle(.plain)
                    .background(Palette.acento)
                    .clipShape(.rect(cornerRadius: 12))
                    .disabled(isLoading)
                }
                .frame(maxWidth: 420)
                .padding(.horizontal, 32)
                .frame(maxWidth: .infinity)
            }
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK") {}
        }
    }

    func iniciarSesion() async {
        // En minúsculas por si el teclado puso la primera letra en mayúscula
        let correo = email.trimmingCharacters(in: .whitespaces).lowercased()

        if correo.isEmpty {
            alertMessage = "Escribe tu correo electrónico."
            showAlert.toggle()
            return
        }

        if !correo.contains("@") || !correo.contains(".") {
            alertMessage = "Escribe un correo electrónico válido."
            showAlert.toggle()
            return
        }

        if password.isEmpty {
            alertMessage = "Escribe tu contraseña."
            showAlert.toggle()
            return
        }

        isLoading = true
        do {
            let respuesta = try await AuthService.login(email: correo, password: password)
            isLoading = false
            // RaizView detecta la sesión activa y muestra las pestañas
            UserSessionHelper.iniciarSesion(token: respuesta.token, usuario: respuesta.user)
        } catch let error as APIError {
            isLoading = false
            alertMessage = error.mensaje
            showAlert.toggle()
        } catch {
            isLoading = false
            alertMessage = APIError.desconocido.mensaje
            showAlert.toggle()
        }
    }
}

#Preview {
    LoginView()
}
