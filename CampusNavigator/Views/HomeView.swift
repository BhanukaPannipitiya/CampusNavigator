import SwiftUI

struct HomeView: View {
    let features = [
        "AR Navigator", "Activity Map",
        "Occupancy", "Events", "Chat", "Meeting Lectures", "Emergency", "Updates"
    ]

    let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    @Binding var selectedTab: Int
    @State private var selectedFeature: String?
    @State private var showNotifications = false
    @State private var searchText = ""
    @State private var isSearchActive = false
    @Environment(\.colorScheme) var colorScheme
    @State private var showProfileView = false
    
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(.systemBackground),
                Color.mint.opacity(colorScheme == .dark ? 0.3 : 0.2)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                   
                        profileHeader
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
     
                        searchBarView
                            .padding(.horizontal)
                        
                        
                        EventSlideshowView()
                            .frame(height: 180)
                            .cornerRadius(16)
                            .padding(.horizontal)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        featuresSection
                    }
                    .padding(.bottom, 80)
                }
                .refreshable {
                    haptic.impactOccurred()
                }
            }
            .navigationDestination(item: $selectedFeature) { feature in
                destinationView(for: feature)
                    .navigationTitle(feature)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .sheet(isPresented: $showNotifications) {
                NotificationsView()
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showProfileView) {
                ProfileView()
            }
        }
    }
    
    private var profileHeader: some View {
        HStack(spacing: 12) {
            Button(action: {
                haptic.impactOccurred()
                showProfileView = true
            }) {
                Image("profilepic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.mint, lineWidth: 2))
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .transition(.scale.combined(with: .opacity))
            }
            .buttonStyle(ScaleButtonStyle())
            
            Button(action: {
                haptic.impactOccurred()
                showProfileView = true
            }) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hello,")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.secondary)
                    
                    Text("Chiara Tews")
                        .font(.title3.weight(.bold))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                haptic.impactOccurred(intensity: 0.7)
                showNotifications.toggle()
                
            }) {
                ZStack {
                    Circle()
                        .fill(Color(.secondarySystemBackground))
                        .frame(width: 44, height: 44)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    
                    Image(systemName: "bell.badge")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }
    
    private var searchBarView: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.leading, 8)
                
                TextField("Search", text: $searchText, onEditingChanged: { editing in
                    withAnimation(.spring()) {
                        isSearchActive = editing
                    }
                })
                .padding(.vertical, 10)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        haptic.impactOccurred(intensity: 0.5)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .padding(.trailing, 8)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 4)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSearchActive ? Color.mint : Color.clear, lineWidth: 2)
            )
            .animation(.spring(response: 0.3), value: isSearchActive)
        }
    }
    
    
    private var featuresSection: some View {
        VStack(spacing: 16) {
            Text("Explore our features")
                .font(.headline)
                .padding(.top, 8)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(features, id: \.self) { feature in
                    FeatureCard(
                        feature: feature,
                        icon: iconName(for: feature),
                        colors: gradientColors(for: feature),
                        action: {
                            haptic.impactOccurred()
                            withAnimation(.spring()) {
                                selectedFeature = feature
                            }
                        }
                    )
                    .transition(.scale)
                }
            }
            .padding(.horizontal)
        }
    }
    

    private func destinationView(for feature: String) -> some View {
        Group {
            switch feature {
            case "AR Navigator":
                ARNavigatorView()
            case "Activity Map":
                ActivityMapView()
            case "Occupancy":
                ResourceAvailabilityView()
            case "Events":
                EventsView()
            case "Chat":
                ChatView()
            case "Meeting Lectures":
                MeetingLecturesView()
            case "Emergency":
                EmergencyView()
//            case "Updates":
//                UpdatesView()
            default:
                EmptyView()
            }
        }
   
        .toolbar(feature == "Activity Map" || feature == "Emergency" ? .visible : .hidden, for: .tabBar)
    }
    
    private func gradientColors(for feature: String) -> [Color] {
        switch feature {
        case "AR Navigator":
            return [Color.blue, Color.indigo]
        case "Activity Map":
            return [Color.green, Color.teal]
        case "Occupancy":
            return [Color.orange, Color.red]
        case "Events":
            return [Color.pink, Color.purple]
        case "Chat":
            return [Color.yellow, Color.orange]
        case "Meeting Lectures":
            return [Color.teal, Color.blue]
        case "Emergency":
            return [Color.red, Color.pink]
        case "Updates":
            return [Color.mint, Color.teal]
        default:
            return [Color.gray.opacity(0.8), Color.gray.opacity(0.6)]
        }
    }
    
    private func iconName(for feature: String) -> String {
        switch feature {
        case "AR Navigator": return "arkit"
        case "Activity Map": return "map.fill"
        case "Occupancy": return "person.3.fill"
        case "Events": return "calendar.badge.clock"
        case "Chat": return "bubble.left.fill"
        case "Meeting Lectures": return "video.fill"
        case "Emergency": return "exclamationmark.triangle.fill"
        case "Updates": return "bell.fill"
        default: return "questionmark"
        }
    }
}


struct FeatureCard: View {
    let feature: String
    let icon: String
    let colors: [Color]
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(colors[0].opacity(0.3))
                        .cornerRadius(12)
                    
                    Text(feature)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            .padding()
            .frame(height: 100)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: colors[0].opacity(0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}


struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(0))
            .previewDisplayName("Light Mode")
        
        HomeView(selectedTab: .constant(0))
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}

