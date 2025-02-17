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
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        
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
                    .padding(.horizontal, 10)
                }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(.sRGB, red: 118/255, green: 118/255, blue: 128/255, opacity: 0.5))

                    TextField("Position, location or keywords", text: .constant(""))
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.primary)
                }
                .padding(5)
                .background(Color(.sRGB, red: 118/255, green: 118/255, blue: 128/255, opacity: 0.12))
                .cornerRadius(15)

                Text("Explore our features")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(features, id: \.self) { feature in
                            Button(action: { selectedFeature = feature }) {
                                VStack(spacing: 8) {
                                    Image(systemName: iconName(for: feature))
                                        .font(.title2)
                                        .padding(8)
                                        .frame(width: 60, height: 60)
                                        .background(Circle().fill(.white.opacity(0.2)))
                                    
                                    Text(feature)
                                        .font(.subheadline.weight(.bold))
                                }
                                .foregroundColor(.white)
                                .frame(width: 144, height: 144)
                                .background(RoundedRectangle(cornerRadius: 12).fill(featureColor(for: feature)))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                    }
                }

                Spacer()
                
                BottomTabBar(selectedTab: $selectedTab)
            }
            .padding(.horizontal)
            .background(Color(.secondarySystemBackground).ignoresSafeArea())
            .navigationDestination(item: $selectedFeature) { feature in
                switch feature {
                case "AR Navigator":
                    ARNavigatorView()
                default:
                    EmptyView()
                }
            }
        }
    }
    
    private func featureColor(for feature: String) -> Color {
        switch feature {
        case "AR Navigator": return Color(red: 51/255, green: 76/255, blue: 127/255)
        case "Activity Map": return Color(red: 127/255, green: 51/255, blue: 94/255)
        case "Occupancy": return Color(red: 65/255, green: 137/255, blue: 102/255)
        case "Events": return Color(red: 178/255, green: 71/255, blue: 73/255)
        case "Chat": return .mint
        case "Meeting Lectures": return Color(red: 127/255, green: 51/255, blue: 94/255)
        case "Emergency": return Color(red: 202/255, green: 30/255, blue: 24/255)
        case "Updates": return Color(red: 157/255, green: 146/255, blue: 72/255)
        default: return Color(red: 127/255, green: 51/255, blue: 94/255)
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
