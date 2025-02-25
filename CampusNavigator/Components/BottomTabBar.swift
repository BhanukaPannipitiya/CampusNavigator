import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
        Self.configureTabBarAppearance() // Use `Self.` to call the static method
    }
    
    var body: some View {
            TabView(selection: $selectedTab) {
                
                HomeView(selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                ActivityMapView()
                    .tabItem {
                        Image(systemName: "map.fill")
                        Text("Map")
                    }
                    .tag(1)
                
                EmergencyView()
                    .tabItem {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Emergency")
                    }
                    .tag(2)
                
            }
            .accentColor(.mint)
    }
    
    private static func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray3
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    BottomTabBar(selectedTab: .constant(0))
}
