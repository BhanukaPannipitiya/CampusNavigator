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
    
    @State private var selectedTab = 0
    @State private var selectedFeature: String?
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white, Color.mint]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
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
                ScrollView{
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
                
//                BottomTabBar(selectedTab: $selectedTab)
                
            }
            .padding(.horizontal)
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
            return [Color(red: 0x44 / 255, green: 0xBD / 255, blue: 0xB7 / 255),
                    Color(red: 0x5D / 255, green: 0x8A / 255, blue: 0xE5 / 255)]
            
        case "Activity Map":
            return [Color(red: 0x35 / 255, green: 0x17 / 255, blue: 0xCE / 255),
                    Color(red: 0x82 / 255, green: 0x70 / 255, blue: 0xDC / 255)]
            
        case "Occupancy":
            return [Color(red: 0x67 / 255, green: 0xCE / 255, blue: 0x67 / 255),
                    Color(red: 0x41 / 255, green: 0x89 / 255, blue: 0x66 / 255)]
            
        case "Events":
            return [Color(red: 0xED / 255, green: 0x61 / 255, blue: 0xB1 / 255),
                    Color(red: 0xE3 / 255, green: 0xA9 / 255, blue: 0xC9 / 255)]
            
        case "Chat":
            return [Color(red: 0xF8 / 255, green: 0x8E / 255, blue: 0x55 / 255),
                    Color(red: 0xC3 / 255, green: 0x55 / 255, blue: 0x1A / 255)]
            
        case "Meeting Lectures":
            return [Color(red: 0x82 / 255, green: 0x70 / 255, blue: 0xDC / 255),
                    Color(red: 0x53 / 255, green: 0x41 / 255, blue: 0xAD / 255)]
            
        case "Emergency":
            return [Color(red: 0xFE / 255, green: 0x06 / 255, blue: 0x06 / 255),
                    Color(red: 0x98 / 255, green: 0x04 / 255, blue: 0x04 / 255)]
            
        case "Updates":
            return [Color(red: 0xFF / 255, green: 0xC8 / 255, blue: 0x00 / 255),
                    Color(red: 0xFF / 255, green: 0x94 / 255, blue: 0x00 / 255)]
            
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
        HomeView()
    }
}
