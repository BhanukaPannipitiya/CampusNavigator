import SwiftUI


struct HomeView: View {
    let features = [
        "AR Navigator", "Activity Map",
        "Occupancy", "Events", "Chat", "Meeting Lectures", "Emergency", "Updates"
    ]

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    @Binding var selectedTab: Int
    @State private var selectedFeature: String?
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white, Color.mint]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        NavigationStack {
            VStack( spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image("profilepic")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.mint, lineWidth: 1))
                        
                        VStack(alignment: .leading) {
                            Text("Hello,")
                                .font(.subheadline.weight(.medium))
                            
                            Text("Chiara Tews")
                                .font(.title2.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        
                        Image(systemName: "bell.badge")
                            .font(.title2)
                    }
                }
                .padding(.horizontal, 10)
                
                SearchBar(text: .constant(""))
                    .padding(.horizontal, 10)
                
                ScrollView {
                    EventSlideshowView()
                    
                    Text("Explore our features")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(features, id: \.self) { feature in
                            Button(action: { selectedFeature = feature }) {
                                VStack(spacing: 8) {
                                    HStack {
                                        VStack {
                                            Image(systemName: iconName(for: feature))
                                                .font(.title2)
                                                .frame(width: 60)
                                                .foregroundColor(.white)
                                            
                                            Text(feature)
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(Color(.white))
                                                .frame(width: 70, height: 40)
                                                .multilineTextAlignment(.center)
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.8)
                                            
                                        }
                                        Spacer()
                                        
                                        ZStack {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 1)
                                                .frame(width: 20, height: 20)
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 10, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding()
                                .frame(width: 160, height: 100)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: gradientColors(for: feature)),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                    }
                    
                    Spacer()
                }
                BottomTabBar(selectedTab: .constant(0))
            }
            .background(backgroundGradient)
            .navigationDestination(item: $selectedFeature) { feature in
                switch feature {
                case "AR Navigator":
                    ARNavigatorView()
                case "Events":
                    EventsView()
                case "Activity Map":
                    ActivityMapView()
                case "Meeting Lectures":
                    MeetingLecturesView()
                case "Chat":
                    ChatView()
                default:
                    EmptyView()
                }
            }
        }
    }
    
    private func gradientColors(for feature: String) -> [Color] {
        switch feature {
        case "AR Navigator":
            return [Color.blue, Color.purple]
        case "Activity Map":
            return [Color.green, Color.blue]
        case "Occupancy":
            return [Color.orange, Color.red]
        case "Events":
            return [Color.pink, Color.purple]
        case "Chat":
            return [Color.yellow, Color.orange]
        case "Meeting Lectures":
            return [Color.teal, Color.blue]
        case "Emergency":
            return [Color.red, Color.black]
        case "Updates":
            return [Color.gray, Color.blue]
        default:
            return [Color.gray.opacity(0.8), Color.gray.opacity(0.6)]
        }
    }
    
    private func iconName(for feature: String) -> String {
        switch feature {
        case "AR Navigator": return "vision.pro.fill"
        case "Activity Map": return "map"
        case "Occupancy": return "person.3"
        case "Events": return "calendar"
        case "Chat": return "bubble.left"
        case "Meeting Lectures": return "video"
        case "Emergency": return "exclamationmark.triangle"
        case "Updates": return "bell"
        default: return "questionmark"
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(selectedTab: .constant(0))
    }
}
