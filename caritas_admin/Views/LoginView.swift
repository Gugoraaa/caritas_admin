import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var mostrarPassword = false
    @State private var isLoading = false

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            Palette.fondo
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 56))
                            .foregroundColor(Palette.acento)
                            .frame(width: 112, height: 112)
                            .background(Palette.acentoClaro)
                            .clipShape(.circle)

                        VStack(spacing: 6) {
                            Text("Cáritas de Monterrey")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(Palette.textoPrincipal)
                            Text("Panel de administración")
                                .font(.title3)
                                .foregroundColor(Palette.textoSecundario)
                        }
                    }

                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Correo electrónico")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(Palette.textoSecundario)

                            HStack(spacing: 12) {
                                Image(systemName: "envelope")
                                    .foregroundColor(Palette.textoSecundario)
                                    .frame(width: 24)
                                TextField("nombre@caritas.org.mx", text: $email)
                                    .textContentType(.username)
                                #if os(iOS)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                #endif
                                    .autocorrectionDisabled()
                            }
                            .padding(.horizontal, 16)
                            .frame(minHeight: 52)
                            .background(Palette.fondo)
                            .clipShape(.rect(cornerRadius: 12))
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contraseña")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(Palette.textoSecundario)

                            HStack(spacing: 12) {
                                Image(systemName: "lock")
                                    .foregroundColor(Palette.textoSecundario)
                                    .frame(width: 24)

                                if mostrarPassword {
                                    TextField("Tu contraseña", text: $password)
                                        .textContentType(.password)
                                        .autocorrectionDisabled()
                                } else {
                                    SecureField("Tu contraseña", text: $password)
                                        .textContentType(.password)
                                }

                                Button {
                                    mostrarPassword.toggle()
                                } label: {
                                    Image(systemName: mostrarPassword ? "eye.slash" : "eye")
                                        .foregroundColor(Palette.textoSecundario)
                                        .frame(width: 44, height: 44)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.leading, 16)
                            .padding(.trailing, 4)
                            .frame(minHeight: 52)
                            .background(Palette.fondo)
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
                        .padding(.top, 8)
                    }
                    .padding(32)
                    .background(Palette.superficie)
                    .clipShape(.rect(cornerRadius: 28))

                    Text("Acceso exclusivo para el personal de Cáritas de Monterrey.")
                        .font(.footnote)
                        .foregroundColor(Palette.textoSecundario)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: 460)
                .padding(.horizontal, 32)
                .padding(.vertical, 80)
                .frame(maxWidth: .infinity)
            }
        }
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK") {}
        }
    }

    func iniciarSesion() async {
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
