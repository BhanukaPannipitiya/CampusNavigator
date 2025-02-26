//
//  ResourceAvailabilityView.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-26.
//

import SwiftUI
import MapKit

// MARK: - Main View
struct ResourceAvailabilityView: View {
    @StateObject private var viewModel = ResourceViewModel()
    @State private var showingReportSheet = false
    @State private var selectedLocation: CampusLocation?
    @State private var isShowingDetail = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Map View
                MapView(locations: viewModel.locations, selectedLocation: $selectedLocation)
                    .ignoresSafeArea(edges: .top)
                    .frame(maxHeight: .infinity)
                
                // Location Detail Card (appears when a location is selected)
                if let location = selectedLocation {
                    VStack {
                        Spacer()
                        LocationDetailCard(
                            location: location,
                            onReportTap: {
                                self.showingReportSheet = true
                            },
                            onNotifyTap: {
                                viewModel.toggleNotifications(for: location)
                            },
                            onDetailsTap: {
                                isShowingDetail = true
                            }
                        )
                        .transition(.move(edge: .bottom))
                        .padding(.bottom, 8)
                    }
                    .animation(.spring(), value: selectedLocation)
                }
                
                // Top Filters
                VStack {
                    ResourceFilterBar(
                        selectedFilter: $viewModel.selectedResourceType,
                        filters: ResourceType.allCases
                    )
                    .padding(.top, 8)
                    Spacer()
                }
                
                // Legend
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        OccupancyLegend()
                            .padding(.trailing, 16)
                            .padding(.bottom, selectedLocation == nil ? 24 : 172)
                    }
                }
            }
            .navigationTitle("Campus Resources")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.refreshData()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.medium)
                    }
                }
            }
            .sheet(isPresented: $showingReportSheet) {
                if let location = selectedLocation {
                    ReportOccupancyView(location: location) { level in
                        viewModel.reportOccupancy(location: location, level: level)
                        showingReportSheet = false
                    }
                    .presentationDetents([.medium])
                }
            }
            .fullScreenCover(isPresented: $isShowingDetail) {
                if let location = selectedLocation {
                    LocationDetailView(location: location)
                }
            }
            .onAppear {
                viewModel.fetchLocations()
            }
        }
    }
}

// MARK: - Map View
struct MapView: View {
    let locations: [CampusLocation]
    @Binding var selectedLocation: CampusLocation?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // Default coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: locations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                LocationMarker(location: location, isSelected: selectedLocation?.id == location.id)
                    .onTapGesture {
                        selectedLocation = location
                    }
            }
        }
    }
}

// MARK: - Location Marker
struct LocationMarker: View {
    let location: CampusLocation
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(location.occupancyLevel.color)
                .frame(width: isSelected ? 50 : 40, height: isSelected ? 50 : 40)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            
            Image(systemName: location.type.iconName)
                .font(.system(size: isSelected ? 24 : 20, weight: .semibold))
                .foregroundColor(.white)
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

// MARK: - Location Detail Card
struct LocationDetailCard: View {
    let location: CampusLocation
    let onReportTap: () -> Void
    let onNotifyTap: () -> Void
    let onDetailsTap: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Image(systemName: location.type.iconName)
                    .font(.title2)
                    .foregroundColor(location.occupancyLevel.color)
                
                Text(location.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(location.occupancyLevel.description)
                    .font(.subheadline)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(location.occupancyLevel.color.opacity(0.2))
                    .foregroundColor(location.occupancyLevel.color)
                    .clipShape(Capsule())
            }
            
            Divider()
            
            // Quick Stats
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Last Updated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(location.lastUpdated)
                        .font(.subheadline)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack(alignment: .leading) {
                    Text("Current Users")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(location.currentUsers) / \(location.capacity)")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button {
                    onDetailsTap()
                } label: {
                    Image(systemName: "info.circle")
                        .font(.title3)
                        .foregroundColor(.blue)
                }
            }
            
            Divider()
            
            // Action Buttons
            HStack {
                Button(action: onReportTap) {
                    HStack {
                        Image(systemName: "gauge.medium")
                        Text("Report")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                }
                
                Button(action: onNotifyTap) {
                    HStack {
                        Image(systemName: location.hasNotifications ? "bell.fill" : "bell")
                        Text(location.hasNotifications ? "Notifying" : "Notify")
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity)
                    .background(location.hasNotifications ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                    .foregroundColor(location.hasNotifications ? .green : .gray)
                    .cornerRadius(10)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - Report Occupancy View
struct ReportOccupancyView: View {
    let location: CampusLocation
    let onSubmit: (OccupancyLevel) -> Void
    @State private var selectedLevel: OccupancyLevel?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("How busy is \(location.name) right now?")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                ForEach(OccupancyLevel.allCases, id: \.self) { level in
                    OccupancyOptionButton(
                        level: level,
                        isSelected: selectedLevel == level,
                        action: {
                            selectedLevel = level
                        }
                    )
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your contribution:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 10) {
                        Text("🏆")
                            .font(.title)
                        
                        VStack(alignment: .leading) {
                            Text("Earn 5 Campus Points")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("Help others find available spaces")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Button(action: {
                    if let level = selectedLevel {
                        onSubmit(level)
                    } else {
                        dismiss()
                    }
                }) {
                    Text(selectedLevel == nil ? "Cancel" : "Submit Report")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedLevel == nil ? Color.gray.opacity(0.2) : Color.blue)
                        .foregroundColor(selectedLevel == nil ? .primary : .white)
                        .cornerRadius(12)
                }
                .disabled(selectedLevel == nil)
            }
            .padding()
            .navigationTitle("Report Occupancy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Occupancy Option Button
struct OccupancyOptionButton: View {
    let level: OccupancyLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: level.iconName)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : level.color)
                    .frame(width: 32)
                
                VStack(alignment: .leading) {
                    Text(level.description)
                        .font(.headline)
                    Text(level.detailedDescription)
                        .font(.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? level.color : Color.gray.opacity(0.1))
            )
            .foregroundColor(isSelected ? .white : .primary)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? level.color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Filter Bar
struct ResourceFilterBar: View {
    @Binding var selectedFilter: ResourceType
    let filters: [ResourceType]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters, id: \.self) { filter in
                    Button(action: {
                        selectedFilter = filter
                    }) {
                        HStack {
                            Image(systemName: filter.iconName)
                            Text(filter.rawValue)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                        .background(selectedFilter == filter ? Color.blue : Color.gray.opacity(0.1))
                        .foregroundColor(selectedFilter == filter ? .white : .primary)
                        .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .background(.ultraThinMaterial)
    }
}

// MARK: - Occupancy Legend
struct OccupancyLegend: View {
    var body: some View {
        HStack(spacing: 12) {
            ForEach(OccupancyLevel.allCases, id: \.self) { level in
                HStack(spacing: 6) {
                    Circle()
                        .fill(level.color)
                        .frame(width: 10, height: 10)
                    
                    Text(level.shortDescription)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
}

// MARK: - Detailed Location View
struct LocationDetailView: View {
    let location: CampusLocation
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeSlot = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Header Image
                    ZStack(alignment: .bottomLeading) {
                        Image("location_placeholder") // Use actual location image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        HStack {
                            Text(location.type.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                            
                            Spacer()
                            
                            HStack {
                                Image(systemName: "person.fill")
                                Text("\(location.currentUsers)/\(location.capacity)")
                            }
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    }
                    
                    // Location Name and Occupancy
                    HStack {
                        VStack(alignment: .leading) {
                            Text(location.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(location.building)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(location.occupancyLevel.description)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(location.occupancyLevel.color.opacity(0.2))
                            .foregroundColor(location.occupancyLevel.color)
                            .clipShape(Capsule())
                    }
                    
                    Divider()
                    
                    // Forecast
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Forecast")
                            .font(.headline)
                        
                        HStack(spacing: 0) {
                            ForEach(0..<6) { i in
                                VStack {
                                    Rectangle()
                                        .fill(OccupancyLevel.getForecastColor(for: i, location: location))
                                        .frame(height: 60)
                                        .cornerRadius(4)
                                    
                                    Text("\(8 + i * 2):00")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 2)
                                .onTapGesture {
                                    selectedTimeSlot = i
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Text("Typically \(["least busy", "moderately busy", "very busy"][selectedTimeSlot % 3]) at this time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // Features
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Features")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            FeatureItem(icon: "wifi", text: "WiFi Available")
                            FeatureItem(icon: "power.plug", text: "Power Outlets")
                            FeatureItem(icon: "cup.and.saucer", text: "Coffee Nearby")
                            FeatureItem(icon: "printer", text: "Printing Station")
                        }
                    }
                    
                    Divider()
                    
                    // Recent Reports
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Reports")
                            .font(.headline)
                        
                        ForEach(0..<3) { i in
                            HStack {
                                Image(systemName: "person.circle")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading) {
                                    Text("User reported: \(OccupancyLevel.allCases[i % 3].description)")
                                        .font(.subheadline)
                                    
                                    Text("\(i * 5 + 2) minutes ago")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: OccupancyLevel.allCases[i % 3].iconName)
                                    .foregroundColor(OccupancyLevel.allCases[i % 3].color)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Location Details", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

// MARK: - Feature Item
struct FeatureItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Models
// MARK: - Models
struct CampusLocation: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let building: String
    let type: ResourceType
    let coordinate: CLLocationCoordinate2D
    var occupancyLevel: OccupancyLevel
    var lastUpdated: String
    let currentUsers: Int
    let capacity: Int
    var hasNotifications: Bool = false
    
    // Make CampusLocation conform to Equatable
    static func == (lhs: CampusLocation, rhs: CampusLocation) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Sample data
    static let samples = [
        CampusLocation(
            name: "Main Library",
            building: "Education Building",
            type: .library,
            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            occupancyLevel: .moderate,
            lastUpdated: "5 minutes ago",
            currentUsers: 145,
            capacity: 300
        ),
        CampusLocation(
            name: "Quiet Study Room",
            building: "Science Hall",
            type: .studyRoom,
            coordinate: CLLocationCoordinate2D(latitude: 37.7750, longitude: -122.4180),
            occupancyLevel: .low,
            lastUpdated: "2 minutes ago",
            currentUsers: 5,
            capacity: 20
        ),
        CampusLocation(
            name: "North Campus Cafe",
            building: "Student Union",
            type: .diningHall,
            coordinate: CLLocationCoordinate2D(latitude: 37.7755, longitude: -122.4190),
            occupancyLevel: .high,
            lastUpdated: "1 minute ago",
            currentUsers: 87,
            capacity: 100
        )
    ]
}

enum ResourceType: String, CaseIterable {
    case studyRoom = "Study Rooms"
    case library = "Libraries"
    case diningHall = "Dining Halls"
    case all = "All"
    
    var iconName: String {
        switch self {
        case .studyRoom: return "book.closed"
        case .library: return "books.vertical"
        case .diningHall: return "fork.knife"
        case .all: return "building.2"
        }
    }
}

enum OccupancyLevel: String, CaseIterable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .moderate: return .orange
        case .high: return .red
        }
    }
    
    var description: String {
        switch self {
        case .low: return "Plenty of Space"
        case .moderate: return "Moderately Busy"
        case .high: return "Very Crowded"
        }
    }
    
    var shortDescription: String {
        switch self {
        case .low: return "Low"
        case .moderate: return "Med"
        case .high: return "High"
        }
    }
    
    var detailedDescription: String {
        switch self {
        case .low: return "Lots of seating available"
        case .moderate: return "Some seats still available"
        case .high: return "Very few or no seats left"
        }
    }
    
    var iconName: String {
        switch self {
        case .low: return "person.badge.minus"
        case .moderate: return "person.2"
        case .high: return "person.3"
        }
    }
    
    static func getForecastColor(for hour: Int, location: CampusLocation) -> Color {
        // This would be replaced with actual forecast data
        let patterns: [[OccupancyLevel]] = [
            [.low, .low, .moderate, .high, .moderate, .low],
            [.low, .moderate, .high, .high, .high, .moderate],
            [.moderate, .low, .low, .moderate, .high, .high]
        ]
        
        let locationHash = location.id.hashValue % patterns.count
        return patterns[locationHash][hour].color
    }
}

// MARK: - View Model
class ResourceViewModel: ObservableObject {
    @Published var locations: [CampusLocation] = []
    @Published var selectedResourceType: ResourceType = .all
    
    func fetchLocations() {
        // In a real app, this would fetch from an API
        locations = CampusLocation.samples
    }
    
    func refreshData() {
        // Simulate a refresh
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchLocations()
        }
    }
    
    func toggleNotifications(for location: CampusLocation) {
        if let index = locations.firstIndex(where: { $0.id == location.id }) {
            locations[index].hasNotifications.toggle()
        }
    }
    
    func reportOccupancy(location: CampusLocation, level: OccupancyLevel) {
        // In a real app, this would send a report to the server
        if let index = locations.firstIndex(where: { $0.id == location.id }) {
            var updatedLocation = locations[index]
            updatedLocation.occupancyLevel = level
            updatedLocation.lastUpdated = "Just now"
            locations[index] = updatedLocation
        }
    }
    
    func filterLocations(by type: ResourceType) -> [CampusLocation] {
        if type == .all {
            return locations
        } else {
            return locations.filter { $0.type == type }
        }
    }
}
