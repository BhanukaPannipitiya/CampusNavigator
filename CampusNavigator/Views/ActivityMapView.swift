import SwiftUI
import MapKit

struct ActivityMapView: View {
    @State private var searchText = ""
    @State private var filterOptions: Set<String> = ["Lectures", "Exams", "Events"]
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
    @State private var showActivityForm = false
    @State private var selectedLocation: Location?
    @State private var showDetails = false
    

    @State private var locations: [Location] = [
        Location(name: "Main Lecture Hall", type: "Lectures", coordinate: .init(latitude: 37.7749, longitude: -122.4194)),
        Location(name: "Science Building", type: "Lectures", coordinate: .init(latitude: 37.7755, longitude: -122.4180)),
        Location(name: "Computer Lab", type: "Lectures", coordinate: .init(latitude: 37.7738, longitude: -122.4202)),
        Location(name: "Exam Hall", type: "Exams", coordinate: .init(latitude: 37.7760, longitude: -122.4170)),
        Location(name: "Sports Complex", type: "Events", coordinate: .init(latitude: 37.7725, longitude: -122.4215))
    ]
    

    var filteredLocations: [Location] {
        locations.filter { filterOptions.contains($0.type) }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Know what's happening")
                        .font(.system(size: 26, weight: .heavy, design: .default))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    
                    Text("Tap for events to know more")
                        .font(.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(Color(.sRGB, red: 60/255, green: 60/255, blue: 67/255, opacity: 0.6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                }
                .padding(.leading)
                
                // Filter Buttons
                HStack {
                    ForEach(["Lectures", "Exams", "Events"], id: \.self) { filter in
                        Button(action: {
                            if filterOptions.contains(filter) {
                                filterOptions.remove(filter)
                            } else {
                                filterOptions.insert(filter)
                            }
                        }) {
                            Text(filter)
                                .font(.subheadline.bold())
                                .foregroundColor(filterOptions.contains(filter) ? .white : .blue)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    filterOptions.contains(filter) ? Color.blue : Color(.systemGray6)
                                )
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal)
                
                Map(coordinateRegion: $region, annotationItems: filteredLocations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        Button(action: {
                            selectedLocation = location
                            showDetails = true
                        }) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                                
                                Text(location.name)
                                    .font(.caption)
                                    .fixedSize()
                            }
                        }
                    }
                }
                .frame(height: 400)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)
            }
//           .frame(maxHeight: .infinity)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showActivityForm = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
            
            // Activity Details Panel
            if let selectedLocation = selectedLocation, showDetails {
                ActivityDetailsPanel(location: selectedLocation, showDetails: $showDetails)
                    .transition(.move(edge: .bottom))
            }
            
            
        }
        .sheet(isPresented: $showActivityForm) {
            AddActivityForm(locations: $locations)
        }
    }
}

// Activity Details Panel
struct ActivityDetailsPanel: View {
    let location: Location
    @Binding var showDetails: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(location.name)
                .font(.title2.bold())
            Text(location.type)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("Lat: \(location.coordinate.latitude), Lon: \(location.coordinate.longitude)")
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
            Button("Close") {
                showDetails = false
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(15)
        }
        .padding()
        .frame(height: 200)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}

// Add Activity Form
struct AddActivityForm: View {
    @Binding var locations: [Location]
    @State private var name = ""
    @State private var type = "Lectures"
    @State private var latitude = ""
    @State private var longitude = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Activity Details")) {
                    TextField("Name", text: $name)
                    Picker("Type", selection: $type) {
                        Text("Lectures").tag("Lectures")
                        Text("Exams").tag("Exams")
                        Text("Events").tag("Events")
                    }
                    TextField("Latitude", text: $latitude)
                    TextField("Longitude", text: $longitude)
                }
            }
            .navigationTitle("Add Activity")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let lat = Double(latitude), let lon = Double(longitude) {
                            let newLocation = Location(
                                name: name,
                                type: type,
                                coordinate: .init(latitude: lat, longitude: lon)
                            )
                            locations.append(newLocation)
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Data Model
struct Location: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let coordinate: CLLocationCoordinate2D
}

struct ActivityMapView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityMapView()
    }
}
