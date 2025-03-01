import SwiftUI

struct BottomTabBar: View {
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
        Self.configureTabBarAppearance()
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
        
        appearance.configureWithDefaultBackground()
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurVisualEffect = UIVisualEffectView(effect: blurEffect)
        
        appearance.backgroundColor = UIColor.clear
        
        appearance.backgroundEffect = blurEffect
        
        appearance.shadowColor = UIColor.black.withAlphaComponent(0.15)
        
        let itemAppearance = UITabBarItemAppearance()
        
        itemAppearance.normal.iconColor = UIColor(.mint.opacity(0.6))
        itemAppearance.selected.iconColor = UIColor(.mint)
        
        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        
        appearance.stackedLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    BottomTabBar(selectedTab: .constant(0))
}
