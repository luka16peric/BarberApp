import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isAuthenticated = false
    @State private var isBarberMode = false
    
    // Koristimo tvoj AuthService
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
    
    // MARK: - LOGIN EKRAN
    var AuthView: some View {
        ZStack {
            Color(hex: "F8F9FA").ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer().frame(height: 60)
                
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
                    Text("Barber Pro")
                        .font(.system(size: 34, weight: .black))
                        .foregroundColor(Color(hex: "1A1A1A"))
                }
                .padding(.bottom, 50)
                
                VStack(spacing: 18) {
                    FigmaTextField(icon: "envelope", placeholder: "Email address", text: $email)
                    FigmaSecureField(icon: "lock", placeholder: "Password", text: $password)
                    
                    HStack {
                        Button(action: { withAnimation(.spring()) { isBarberMode.toggle() } }) {
                            HStack(spacing: 6) {
                                Image(systemName: isBarberMode ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(isBarberMode ? Color(hex: "FF6B00") : .gray)
                                Text("Barber Mode")
                                    .font(.system(size: 14, weight: isBarberMode ? .bold : .medium))
                                    .foregroundColor(isBarberMode ? Color(hex: "1A1A1A") : .gray)
                            }
                        }
                        Spacer()
                        Text("Forgot Password?")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "FF6B00"))
                    }
                    .padding(.horizontal, 5)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 35)
                
                Button(action: {
                    authService.login(email: email, password: password) { _ in
                        isAuthenticated = true
                    }
                }) {
                    Text("Sign In")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color(hex: "FF6B00"))
                        .cornerRadius(18)
                }
                .padding(.horizontal, 25)
                
                Spacer()
            }
        }
    }
}

// MARK: - MODERN HOME SCREEN (JORDAN DIZAJN)
struct ClientDashboardView: View {
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome back,")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                Text("Jordan")
                    .font(.system(size: 32, weight: .black))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 25)
            .padding(.top, 30)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    
                    // Quick Actions
                    HStack(spacing: 20) {
                        ActionCard(icon: "calendar", title: "Book Now", subtitle: "Schedule appointment")
                        ActionCard(icon: "scissors", title: "Services", subtitle: "View all services")
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 20)
                    
                    // Horizontalni Scroll za Barbere
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Our Barbers")
                                .font(.headline)
                            Spacer()
                            Text("See All")
                                .font(.subheadline).bold()
                                .foregroundColor(Color(hex: "FF6B00"))
                        }
                        .padding(.horizontal, 25)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                BarberCard(name: "Marcus Chen", specialty: "Classic Cuts", rating: "4.8")
                                BarberCard(name: "David Torres", specialty: "Beard Expert", rating: "5.0")
                            }
                            .padding(.horizontal, 25)
                        }
                    }
                    
                    // Premium Banner
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Premium Grooming Package")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Get 20% off on your first visit")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                    }
                    .padding(25)
                    .background(Color(hex: "FF6B00"))
                    .cornerRadius(25)
                    .padding(.horizontal, 25)
                    
                    Button("Sign Out") {
                        isAuthenticated = false
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(Color(hex: "F8F9FA").ignoresSafeArea())
    }
}

// MARK: - POMOĆNE KOMPONENTE
struct ActionCard: View {
    var icon: String; var title: String; var subtitle: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .padding(12)
                .background(Color(hex: "FF6B00"))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline).foregroundColor(.black)
                Text(subtitle).font(.caption2).foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.03), radius: 10, y: 5)
    }
}

struct BarberCard: View {
    var name: String; var specialty: String; var rating: String
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 180, height: 180)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").font(.caption2)
                    Text(rating).font(.caption).bold()
                }
                .padding(6)
                .background(Color(hex: "FF6B00"))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(10)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name).font(.headline).foregroundColor(.black)
                Text(specialty).font(.caption).bold().foregroundColor(Color(hex: "FF6B00"))
            }
            .padding(15)
        }
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.03), radius: 10, y: 5)
    }
}

struct FigmaTextField: View {
    var icon: String; var placeholder: String; @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.secondary)
            TextField(placeholder, text: $text)
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(15)
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
        .padding(18)
        .background(Color.white)
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black.opacity(0.05), lineWidth: 1))
    }
}

struct BarberDashboardView: View {
    @Binding var isAuthenticated: Bool
    var body: some View {
        VStack {
            Text("🪒 Barber Panel")
            Button("Sign Out") { isAuthenticated = false }
        }
    }
}

// MARK: - EKSTENZIJA ZA BOJE (Rješava tvoj error 'hex:')
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
