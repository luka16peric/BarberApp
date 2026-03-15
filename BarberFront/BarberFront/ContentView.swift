import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isAuthenticated = false
    @State private var isBarberMode = false
    @StateObject var authService = AuthService()

    var body: some View {
        Group {
            if isAuthenticated {
                if isBarberMode {
                    BarberDashboardView(isAuthenticated: $isAuthenticated)
                } else {
                    ClientDashboardView(isAuthenticated: $isAuthenticated)
                }
            } else {
                AuthView
            }
        }
    }
    
    var AuthView: some View {
        ZStack {
            Color(hex: "F8F9FA").ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer().frame(height: 60)
                
                // LOGO
                VStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(hex: "FF6B00"))
                            .frame(width: 110, height: 110)
                            .shadow(color: Color(hex: "FF6B00").opacity(0.3), radius: 15, y: 8)
                        Image(systemName: "scissors")
                            .font(.system(size: 45, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Text("Barber Pro").font(.system(size: 34, weight: .black))
                    Text("Your premium grooming experience").font(.subheadline).foregroundColor(.secondary)
                }
                .padding(.bottom, 50)
                
                // INPUTS
                VStack(spacing: 18) {
                    FigmaTextField(icon: "envelope", placeholder: "Email address", text: $email)
                    FigmaSecureField(icon: "lock", placeholder: "Password", text: $password)
                    
                    HStack {
                        Button(action: { withAnimation { isBarberMode.toggle() } }) {
                            HStack {
                                Image(systemName: isBarberMode ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(isBarberMode ? Color(hex: "FF6B00") : .gray)
                                Text("Barber Mode").font(.footnote).foregroundColor(.primary)
                            }
                        }
                        Spacer()
                        Text("Forgot Password?").font(.footnote).foregroundColor(Color(hex: "FF6B00"))
                    }
                    .padding(.horizontal, 5)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 35)
                
                // BUTTONS
                VStack(spacing: 15) {
                    Button(action: {
                        authService.login(email: email, password: password) { _ in
                            isAuthenticated = true
                        }
                    }) {
                        Text("Sign In")
                            .fontWeight(.bold).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(Color(hex: "FF6B00")).cornerRadius(18)
                    }
                    
                    Text("or").font(.footnote).foregroundColor(.secondary)
                    
                    Button(action: {}) {
                        Text("Continue as Guest")
                            .fontWeight(.semibold).foregroundColor(Color(hex: "FF6B00"))
                            .frame(maxWidth: .infinity).padding(.vertical, 18)
                            .background(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "FF6B00"), lineWidth: 2))
                    }
                }
                .padding(.horizontal, 25)
                Spacer()
            }
        }
    }
}

// POMOĆNI ELEMENTI DIZAJNA
struct FigmaTextField: View {
    var icon: String; var placeholder: String; @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.secondary)
            TextField(placeholder, text: $text)
        }
        .padding(18).background(Color.white).cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black.opacity(0.05), lineWidth: 1))
    }
}

struct FigmaSecureField: View {
    var icon: String; var placeholder: String; @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.secondary)
            SecureField(placeholder, text: $text)
        }
        .padding(18).background(Color.white).cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black.opacity(0.05), lineWidth: 1))
    }
}

struct ClientDashboardView: View {
    @Binding var isAuthenticated: Bool
    var body: some View {
        VStack {
            Text("✂️ Client Dashboard").font(.title).bold()
            Button("Logout") { isAuthenticated = false }.padding().foregroundColor(.red)
        }
    }
}

struct BarberDashboardView: View {
    @Binding var isAuthenticated: Bool
    var body: some View {
        VStack {
            Text("🪒 Barber Dashboard").font(.title).bold()
            Button("Logout") { isAuthenticated = false }.padding().foregroundColor(.red)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (r, g, b) = (1, 1, 1)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: 1)
    }
}
