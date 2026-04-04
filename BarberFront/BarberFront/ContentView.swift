import SwiftUI

// MARK: - MODELI PODATAKA
struct ServiceItem: Identifiable {
    let id = UUID()
    let name: String; let price: String; let duration: String; let icon: String
}

struct BarberItem: Identifiable {
    let id = UUID()
    let name: String; let specialty: String; let rating: String; let years: String; let imageName: String
}

struct DateItem: Identifiable {
    let id = UUID()
    let dayName: String; let dayNumber: String; let month: String
}

// MARK: - MAIN CONTENT VIEW
struct ContentView: View {
    // 1. Ovdje definiramo "poštara" koji priča sa C# serverom
    @StateObject var authService = AuthService()
    
    // 2. Lokalne varijable za unos teksta i modove rada
    @State private var email = ""
    @State private var password = ""
    @State private var isBarberMode = false
    @State private var isGuest = false
    
    var body: some View {
        Group {
            // 3. LOGIKA: Ako je korisnik ulogiran ILI je ušao kao gost
            if authService.isAuthenticated || isGuest {
                if isBarberMode {
                    BarberDashboardView(isAuthenticated: $authService.isAuthenticated)
                } else {
                    ClientDashboardView(isAuthenticated: $authService.isAuthenticated, isGuest: $isGuest)
                }
            } else {
                // 4. Ovdje dodaješ poziv za AuthView
                // Šaljemo mu sve što on očekuje (email, lozinku, modove)
                AuthView(
                    email: $email,
                    password: $password,
                    isBarberMode: $isBarberMode,
                    isGuest: $isGuest
                )
                // 5. OVO JE KLJUČNO: Dajemo mu pristup authService-u
                .environmentObject(authService)
            }
        }
    }
}
// MARK: - REGISTER VIEW (RAZDVOJENO IME I PREZIME)
struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            Color(hex: "F8F9FA").ignoresSafeArea()
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 10) {
                        Text("Create Account").font(.system(size: 32, weight: .black))
                        Text("Join Barber Pro and start booking").foregroundColor(.gray)
                    }.padding(.top, 40)
                    
                    VStack(spacing: 18) {
                        // RAZDVOJENO IME I PREZIME
                        HStack(spacing: 15) {
                            FigmaTextField(icon: "person", placeholder: "First Name", text: $firstName)
                            FigmaTextField(icon: "person.fill", placeholder: "Last Name", text: $lastName)
                        }
                        
                        // EMAIL - Isključeno veliko slovo
                        FigmaTextField(icon: "envelope", placeholder: "Email address", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        // TELEFON - Brojčana tipkovnica
                        FigmaTextField(icon: "phone", placeholder: "Phone Number", text: $phone)
                            .keyboardType(.phonePad)
                        
                        FigmaSecureField(icon: "lock", placeholder: "Password", text: $password)
                    }.padding(.horizontal, 25)
                    
                    Button(action: {
                        print("Registracija: \(firstName) \(lastName)")
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Sign Up").fontWeight(.bold).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 18).background(Color(hex: "FF6B00")).cornerRadius(18)
                    }.padding(.horizontal, 25)
                    
                    Button("Already have an account? Sign In") {
                        presentationMode.wrappedValue.dismiss()
                    }.foregroundColor(.gray).font(.footnote)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - LOGIN
struct AuthView: View {
    // 1. Dodajemo pristup AuthService-u
    @EnvironmentObject var authService: AuthService
    
    @Binding var email: String
    @Binding var password: String
    
    // Više ne trebamo @Binding za isAuthenticated jer ga slušamo preko authService-a
    @Binding var isBarberMode: Bool
    @Binding var isGuest: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F8F9FA").ignoresSafeArea()
                VStack(spacing: 0) {
                    Spacer().frame(height: 60)
                    
                    // Logo sekcija
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
                    }.padding(.bottom, 50)
                    
                    // Input polja
                    VStack(spacing: 18) {
                        FigmaTextField(icon: "envelope", placeholder: "Email address", text: $email)
                            .autocapitalization(.none)
                            .disableAutocorrection(true) // Dodano da ti iPhone ne kvari mail
                            .keyboardType(.emailAddress)
                        
                        FigmaSecureField(icon: "lock", placeholder: "Password", text: $password)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 10)
                    
                    // Prikaz greške ako login ne uspije
                    if let errorMessage = authService.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.bottom, 20)
                    } else {
                        Spacer().frame(height: 25)
                    }
                    
                    // Tipke
                    VStack(spacing: 15) {
                        // 2. ISPRAVLJEN GUMB - Sada zove login metodu
                        Button(action: {
                            authService.login(email: email, password: password)
                        }) {
                            if authService.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color(hex: "FF6B00"))
                                    .cornerRadius(18)
                            } else {
                                Text("Sign In")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(Color(hex: "FF6B00"))
                                    .cornerRadius(18)
                            }
                        }
                        .disabled(authService.isLoading) // Onemogući gumb dok se učitava
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Create Account")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(hex: "FF6B00"))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(RoundedRectangle(cornerRadius: 18).stroke(Color(hex: "FF6B00"), lineWidth: 2))
                        }
                        
                        Button(action: { withAnimation { isGuest = true } }) {
                            Text("Continue as Guest").foregroundColor(.gray).font(.subheadline)
                        }.padding(.top, 10)
                    }.padding(.horizontal, 25)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}
// MARK: - HOME SCREEN (Jordan)
struct ClientDashboardView: View {
    @Binding var isAuthenticated: Bool; @Binding var isGuest: Bool
    @State private var navigationId = UUID()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F8F9FA").ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(isGuest ? "Welcome, Guest" : "Welcome back,").font(.system(size: 18)).foregroundColor(.gray)
                            Text(isGuest ? "Stranger" : "Jordan").font(.system(size: 32, weight: .black))
                        }
                        .padding(.horizontal, 25)
                        .padding(.top, 30)
                        
                        VStack(alignment: .leading, spacing: 30) {
                            HStack(spacing: 20) {
                                NavigationLink(destination: ServicesView()) { ActionCard(icon: "calendar", title: "Book Now", subtitle: "Schedule appointment") }
                                NavigationLink(destination: ServicesView()) { ActionCard(icon: "scissors", title: "Services", subtitle: "View all") }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal, 25)
                            .padding(.top, 20)
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Our Barbers").font(.headline).padding(.horizontal, 25)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        BarberCard(name: "Luka Perić", specialty: "Classic Cuts", rating: "4.8")
                                        BarberCard(name: "Jani Brodarić", specialty: "Beard Expert", rating: "5.0")
                                    }.padding(.horizontal, 25)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Find Us").font(.headline).padding(.horizontal, 25)
                                HStack(spacing: 15) {
                                    Image(systemName: "map.fill").font(.title2).foregroundColor(.white).padding(12).background(Color(hex: "FF6B00")).cornerRadius(15)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Barber Pro Studio").font(.headline)
                                        Text("Ulica Hrvatske Mornarice 10, Split").font(.subheadline).foregroundColor(.gray)
                                    }
                                    Spacer()
                                }.padding(20).background(Color.white).cornerRadius(25).shadow(color: Color.black.opacity(0.03), radius: 10, y: 5).padding(.horizontal, 25)
                            }
                            
                            HStack(spacing: 25) {
                                SocialButton(icon: "camera.fill", color: "E1306C")
                                SocialButton(icon: "music.note", color: "000000")
                                SocialButton(icon: "f.square.fill", color: "1877F2")
                            }.frame(maxWidth: .infinity).padding(.top, 10)

                            Button("Exit App") { isAuthenticated = false; isGuest = false }.font(.footnote).foregroundColor(.gray).frame(maxWidth: .infinity).padding(.bottom, 30)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .id(navigationId)
    }
}

// MARK: - BOOKING KORACI
struct ServicesView: View {
    @Environment(\.presentationMode) var presentationMode; @State private var selectedService: ServiceItem?
    let services = [ServiceItem(name: "Haircut", price: "$40", duration: "30 min", icon: "scissors"), ServiceItem(name: "Beard Trim", price: "$25", duration: "20 min", icon: "wind"), ServiceItem(name: "Full Service", price: "$65", duration: "60 min", icon: "sparkles"), ServiceItem(name: "Hot Towel Shave", price: "$35", duration: "30 min", icon: "bolt.fill")]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { presentationMode.wrappedValue.dismiss() }) { HStack(spacing: 5) { Image(systemName: "chevron.left"); Text("Back") }.foregroundColor(Color(hex: "FF6B00")).font(.system(size: 18, weight: .medium)) }.padding(.horizontal, 25).padding(.top, 10)
            VStack(alignment: .leading, spacing: 12) {
                Text("Book Appointment").font(.system(size: 28, weight: .bold))
                ZStack(alignment: .leading) { Capsule().fill(Color.gray.opacity(0.1)).frame(height: 4); Capsule().fill(Color(hex: "FF6B00")).frame(width: 80, height: 4) }
            }.padding(.horizontal, 25).padding(.top, 25)
            Text("Choose Service").font(.system(size: 20, weight: .bold)).padding(.horizontal, 25).padding(.top, 35)
            ScrollView { VStack(spacing: 15) { ForEach(services) { service in Button(action: { selectedService = service }) { ServiceItemRow(service: service, isSelected: selectedService?.id == service.id) } } }.padding(25) }
            if let s = selectedService { NavigationLink(destination: BarberSelectionView(selectedService: s)) { Text("Choose Barber").font(.system(size: 18, weight: .bold)).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 18).background(Color(hex: "FF6B00")).cornerRadius(18).padding(.horizontal, 25).padding(.bottom, 30) } }
        }.background(Color(hex: "F8F9FA").ignoresSafeArea()).navigationBarHidden(true)
    }
}

struct BarberSelectionView: View {
    @Environment(\.presentationMode) var presentationMode; let selectedService: ServiceItem; @State private var selectedBarber: BarberItem?
    let barbers = [BarberItem(name: "Luka Perić", specialty: "Classic Cuts", rating: "4.9", years: "12 years", imageName: "person.fill"), BarberItem(name: "Jani Brodarić", specialty: "Fade Specialist", rating: "4.8", years: "8 years", imageName: "person.fill")]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { presentationMode.wrappedValue.dismiss() }) { HStack(spacing: 5) { Image(systemName: "chevron.left"); Text("Back") }.foregroundColor(Color(hex: "FF6B00")).font(.system(size: 18, weight: .medium)) }.padding(.horizontal, 25).padding(.top, 10)
            VStack(alignment: .leading, spacing: 12) { Text("Book Appointment").font(.system(size: 28, weight: .bold)); HStack(spacing: 5) { Capsule().fill(Color(hex: "FF6B00")).frame(width: 60, height: 4); Capsule().fill(Color(hex: "FF6B00")).frame(width: 60, height: 4) } }.padding(.horizontal, 25).padding(.top, 25)
            Text("Choose Your Barber").font(.system(size: 20, weight: .bold)).padding(.horizontal, 25).padding(.top, 35)
            ScrollView { VStack(spacing: 15) { ForEach(barbers) { b in Button(action: { selectedBarber = b }) { BarberSelectRow(barber: b, isSelected: selectedBarber?.id == b.id) } } }.padding(25) }
            if let b = selectedBarber { NavigationLink(destination: DateSelectionView(selectedService: selectedService, selectedBarber: b)) { Text("Choose Date").font(.system(size: 18, weight: .bold)).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 18).background(Color(hex: "FF6B00")).cornerRadius(18).padding(.horizontal, 25).padding(.bottom, 30) } }
        }.background(Color(hex: "F8F9FA").ignoresSafeArea()).navigationBarHidden(true)
    }
}

struct DateSelectionView: View {
    @Environment(\.presentationMode) var presentationMode; let selectedService: ServiceItem; let selectedBarber: BarberItem; @State private var selectedDate: DateItem?
    let dates = [DateItem(dayName: "Thu", dayNumber: "2", month: "Apr"), DateItem(dayName: "Fri", dayNumber: "3", month: "Apr"), DateItem(dayName: "Sat", dayNumber: "4", month: "Apr"), DateItem(dayName: "Sun", dayNumber: "5", month: "Apr"), DateItem(dayName: "Mon", dayNumber: "6", month: "Apr"), DateItem(dayName: "Tue", dayNumber: "7", month: "Apr")]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { presentationMode.wrappedValue.dismiss() }) { HStack(spacing: 5) { Image(systemName: "chevron.left"); Text("Back") }.foregroundColor(Color(hex: "FF6B00")) }.padding(.horizontal, 25).padding(.top, 10)
            VStack(alignment: .leading, spacing: 12) { Text("Book Appointment").font(.system(size: 28, weight: .bold)); HStack(spacing: 5) { ForEach(0..<3, id: \.self) { _ in Capsule().fill(Color(hex: "FF6B00")).frame(width: 60, height: 4) } } }.padding(.horizontal, 25).padding(.top, 25)
            ScrollView { LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) { ForEach(dates) { d in Button(action: { selectedDate = d }) { DateCard(date: d, isSelected: selectedDate?.id == d.id) } } }.padding(25) }
            if let d = selectedDate { NavigationLink(destination: TimeSelectionView(selectedService: selectedService, selectedBarber: selectedBarber, selectedDate: d)) { Text("Choose Time").font(.system(size: 18, weight: .bold)).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 18).background(Color(hex: "FF6B00")).cornerRadius(18).padding(.horizontal, 25).padding(.bottom, 30) } }
        }.background(Color(hex: "F8F9FA").ignoresSafeArea()).navigationBarHidden(true)
    }
}

struct TimeSelectionView: View {
    @Environment(\.presentationMode) var presentationMode; let selectedService: ServiceItem; let selectedBarber: BarberItem; let selectedDate: DateItem; @State private var selectedTime: String?
    let times = ["09:00", "10:00", "11:00", "12:00", "13:00", "14:00"]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: { presentationMode.wrappedValue.dismiss() }) { HStack(spacing: 5) { Image(systemName: "chevron.left"); Text("Back") }.foregroundColor(Color(hex: "FF6B00")) }.padding(.horizontal, 25).padding(.top, 10)
            VStack(alignment: .leading, spacing: 12) { Text("Book Appointment").font(.system(size: 28, weight: .bold)); HStack(spacing: 5) { ForEach(0..<4, id: \.self) { _ in Capsule().fill(Color(hex: "FF6B00")).frame(width: 60, height: 4) } } }.padding(.horizontal, 25).padding(.top, 25)
            ScrollView { LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) { ForEach(times, id: \.self) { t in Button(action: { selectedTime = t }) { Text(t).font(.headline).foregroundColor(selectedTime == t ? .white : .black).frame(maxWidth: .infinity).padding(.vertical, 20).background(selectedTime == t ? Color(hex: "FF6B00") : Color.white).cornerRadius(20) } } }.padding(25) }
            if let t = selectedTime { NavigationLink(destination: ConfirmationView(selectedService: selectedService, selectedBarber: selectedBarber, selectedDate: selectedDate, selectedTime: t)) { Text("Review").font(.system(size: 18, weight: .bold)).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 18).background(Color(hex: "FF6B00")).cornerRadius(18).padding(.horizontal, 25).padding(.bottom, 30) } }
        }.background(Color(hex: "F8F9FA").ignoresSafeArea()).navigationBarHidden(true)
    }
}

struct ConfirmationView: View {
    let selectedService: ServiceItem; let selectedBarber: BarberItem; let selectedDate: DateItem; let selectedTime: String
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ZStack { Circle().fill(Color(hex: "FF6B00")).frame(width: 80, height: 80); Image(systemName: "checkmark").font(.system(size: 40, weight: .bold)).foregroundColor(.white) }
            Text("Confirm Booking").font(.title2).bold().padding(.top, 20)
            VStack(spacing: 15) {
                SummaryRow(title: "Service", val: selectedService.name, icon: selectedService.icon)
                SummaryRow(title: "Barber", val: selectedBarber.name, icon: "person.fill")
                SummaryRow(title: "Time", val: "\(selectedDate.dayNumber) Apr, \(selectedTime)", icon: "clock")
            }.padding(25).background(Color.white).cornerRadius(30).padding(25)
            Spacer()
            Button(action: {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
                    window.rootViewController = UIHostingController(rootView: ContentView())
                    window.makeKeyAndVisible()
                }
            }) { Text("Confirm Booking").font(.headline).foregroundColor(.white).frame(maxWidth: .infinity).padding(.vertical, 20).background(Color(hex: "FF6B00")).cornerRadius(20).padding(.horizontal, 25).padding(.bottom, 40) }
        }.background(Color(hex: "F8F9FA").ignoresSafeArea()).navigationBarHidden(true)
    }
}

// MARK: - POMOĆNE KOMPONENTE
struct ServiceItemRow: View {
    let service: ServiceItem; let isSelected: Bool
    var body: some View { HStack(spacing: 20) { ZStack { RoundedRectangle(cornerRadius: 15).fill(Color(hex: "FF6B00").opacity(0.08)).frame(width: 55, height: 55); Image(systemName: service.icon).font(.system(size: 20)).foregroundColor(Color(hex: "FF6B00")) }; VStack(alignment: .leading, spacing: 4) { Text(service.name).font(.system(size: 18, weight: .bold)).foregroundColor(.black); HStack(spacing: 8) { Text(service.price).bold().foregroundColor(Color(hex: "FF6B00")); Text(service.duration).foregroundColor(.gray) } }; Spacer() }.padding(18).background(Color.white).cornerRadius(25).overlay(RoundedRectangle(cornerRadius: 25).stroke(isSelected ? Color(hex: "FF6B00") : Color.clear, lineWidth: 2)).shadow(color: Color.black.opacity(0.02), radius: 10, y: 5) }
}
struct BarberSelectRow: View { let barber: BarberItem; let isSelected: Bool; var body: some View { HStack(spacing: 15) { Rectangle().fill(Color.gray.opacity(0.1)).frame(width: 70, height: 70).cornerRadius(15); VStack(alignment: .leading, spacing: 4) { Text(barber.name).font(.headline).foregroundColor(.black); Text(barber.specialty).font(.subheadline).foregroundColor(Color(hex: "FF6B00")).bold(); HStack { Image(systemName: "star.fill").foregroundColor(Color(hex: "FF6B00")).font(.caption); Text(barber.rating).font(.caption).bold().foregroundColor(.black); Text("• \(barber.years)").font(.caption).foregroundColor(.gray) } }; Spacer() }.padding().background(Color.white).cornerRadius(25).overlay(RoundedRectangle(cornerRadius: 25).stroke(isSelected ? Color(hex: "FF6B00") : Color.clear, lineWidth: 2)).shadow(color: Color.black.opacity(0.02), radius: 10, y: 5) } }
struct DateCard: View { let date: DateItem; let isSelected: Bool; var body: some View { VStack(spacing: 4) { Text(date.dayName).font(.caption).foregroundColor(isSelected ? .white : .gray); Text(date.dayNumber).font(.title2).bold().foregroundColor(isSelected ? .white : .black); Text(date.month).font(.caption).foregroundColor(isSelected ? .white : .gray) }.frame(maxWidth: .infinity).padding(.vertical, 20).background(isSelected ? Color(hex: "FF6B00") : Color.white).cornerRadius(20).shadow(color: Color.black.opacity(0.02), radius: 5, y: 2) } }
struct ActionCard: View { var icon: String; var title: String; var subtitle: String; var body: some View { VStack(alignment: .leading, spacing: 12) { Image(systemName: icon).font(.title2).foregroundColor(.white).padding(12).background(Color(hex: "FF6B00")).cornerRadius(12); VStack(alignment: .leading, spacing: 2) { Text(title).font(.headline).foregroundColor(.black); Text(subtitle).font(.caption2).foregroundColor(.gray) } }.frame(maxWidth: .infinity, alignment: .leading).padding(20).background(Color.white).cornerRadius(25).shadow(color: Color.black.opacity(0.03), radius: 10, y: 5) } }
struct BarberCard: View { var name: String; var specialty: String; var rating: String; var body: some View { VStack(alignment: .leading, spacing: 0) { Rectangle().fill(Color.gray.opacity(0.2)).frame(width: 180, height: 180).cornerRadius(25); VStack(alignment: .leading, spacing: 4) { Text(name).font(.headline).foregroundColor(.black); Text(specialty).font(.caption).bold().foregroundColor(Color(hex: "FF6B00")) }.padding(15) }.background(Color.white).cornerRadius(25) } }
struct SocialButton: View { var icon: String; var color: String; var body: some View { Image(systemName: icon).font(.title2).foregroundColor(Color(hex: color)).frame(width: 55, height: 55).background(Color.white).cornerRadius(18).shadow(color: Color.black.opacity(0.05), radius: 5, y: 2) } }
struct SummaryRow: View { let title: String; let val: String; let icon: String; var body: some View { HStack { Image(systemName: icon).foregroundColor(.orange).frame(width: 30); VStack(alignment: .leading) { Text(title).font(.caption).foregroundColor(.gray); Text(val).bold() }; Spacer() } } }

// MARK: - FIGMA TEXT FIELD (AŽURIRANO)
struct FigmaTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundColor(.secondary)
            TextField(placeholder, text: $text)
                .disableAutocorrection(true)
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(15)
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black.opacity(0.05), lineWidth: 1))
    }
}

struct FigmaSecureField: View { var icon: String; var placeholder: String; @Binding var text: String; var body: some View { HStack { Image(systemName: icon).foregroundColor(.secondary); SecureField(placeholder, text: $text) }.padding(18).background(Color.white).cornerRadius(15).overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black.opacity(0.05), lineWidth: 1)) } }
struct BarberDashboardView: View { @Binding var isAuthenticated: Bool; var body: some View { VStack { Text("Barber Panel"); Button("Logout") { isAuthenticated = false } } } }

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0; Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64; switch hex.count { case 6: (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF); default: (r, g, b) = (1, 1, 1) }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: 1)
    }
}
