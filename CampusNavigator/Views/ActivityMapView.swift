import SwiftUI
import MapKit

struct ActivityMapView: View {
    @State private var searchText = ""
    @State private var selectedFilter: String = "Lectures"
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9010, longitude: 79.8607),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var showActivityForm = false
    @State private var selectedLocation: Location?
    @State private var showDetailsAlert = false
    @State private var showNavigationSheet = false
    @State private var locations: [Location] = [
        Location(name: "Main Lecture Hall", type: "Lectures", coordinate: .init(latitude: 6.9063, longitude: 79.8708),description:"iOS develpment lecture is held here"),
        Location(name: "Science Building", type: "Lectures", coordinate: .init(latitude: 6.9065, longitude: 79.8708),description:"iOS develpment lecture is held here"),
        Location(name: "Computer Lab", type: "Lectures", coordinate: .init(latitude: 6.9068, longitude: 79.8708),description:"iOS develpment lecture is held here"),
        Location(name: "Exam Hall", type: "Exams", coordinate: .init(latitude: 6.9063, longitude: 79.8710),description:"iOS develpment lecture is held here"),
        Location(name: "Sports Complex", type: "Events", coordinate: .init(latitude: 6.9065, longitude: 79.8711),description:"iOS develpment lecture is held here")
    ]
    
    var filteredLocations: [Location] {
        locations.filter { $0.type == selectedFilter }
    }
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.systemMint
    }
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Live Campus Activity Map")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Text("Tap locations to see more details")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
            }
            
            Picker("Filter", selection: $selectedFilter) {
                ForEach(["Lectures", "Exams", "Events"], id: \.self) { filter in
                    Text(filter).tag(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .tint(.mint)
            .padding(.horizontal)
            
            Map(coordinateRegion: $region, annotationItems: filteredLocations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Button(action: {
                        selectedLocation = location
                        showDetailsAlert = true
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.mint)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .frame(height: 400)
            .cornerRadius(20)
            .padding(.horizontal)
            
            Spacer()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showActivityForm = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.mint)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 90)
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .alert("Location Details", isPresented: $showDetailsAlert) {
            Button("Done", role: .cancel) { }
            Button("Navigate") { showNavigationSheet = true }
        } message: {
            if let selectedLocation = selectedLocation {
                Text("\(selectedLocation.name)\n \(selectedLocation.description)")
            }
        }
        .sheet(isPresented: $showActivityForm) {
            AddActivityForm(locations: $locations)
        }
        .sheet(isPresented: $showNavigationSheet) {
            if let location = selectedLocation {
                NavigationSheet(destination: location.name)
            }
        }
    }
    
    private func showNavigationSteps() {
        showNavigationSheet = true
    }
    
}

// Add Activity Form
struct AddActivityForm: View {
    @Binding var locations: [Location]
    @State private var name = ""
    @State private var type = "Lectures"
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var description = ""
    @State private var isKeyboardVisible = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Activity Details")) {
                        CustomTextField(
                            text: $name,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter activity name",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "Name",
                            labelTextColor: .gray
                        )
                        
                        Picker("Type", selection: $type) {
                            Text("Lectures").tag("Lectures")
                            Text("Exams").tag("Exams")
                            Text("Events").tag("Events")
                        }
                        .foregroundColor(.gray)
                        .accentColor(.black)
                        .padding(.horizontal)
                        .padding(.vertical)
                        
                        CustomTextField(
                            text: $latitude,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter latitude",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "Latitude",
                            labelTextColor: .gray
                        )
                        
                        CustomTextField(
                            text: $longitude,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter longitude",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "Longitude",
                            labelTextColor: .gray
                        )
                        CustomTextField(
                            text: $longitude,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter start time",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "Start Time",
                            labelTextColor: .gray
                        )
                        CustomTextField(
                            text: $longitude,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter end time",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "End Time",
                            labelTextColor: .gray
                        )
                        CustomTextField(
                            text: $description,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter description",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "Description",
                            labelTextColor: .gray
                        )
                        
                        VStack{
                            Text("Adding an activity will require further confirmation and please be accurate about information")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding(.horizontal)
                        
                        CustomTextField(
                            text: $description,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter description",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "Description",
                            labelTextColor: .gray
                        )
                        
                        VStack{
                            Text("Email will be sent to the above email address asking for confirmation of the activity details and once the confirmation is done you can see the activity on map")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding(.horizontal)
                    }
                    
                }
                
                // Done button
                Button(action: {
                    if let lat = Double(latitude), let lon = Double(longitude) {
                        let newLocation = Location(
                            name: name,
                            type: type,
                            coordinate: .init(latitude: lat, longitude: lon),
                            description: description
                        )
                        locations.append(newLocation)
                        dismiss()
                    }
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.mint)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .padding()
            }
            .navigationTitle("Add Activity")
        }
    }
}

struct NavigationSheet: View {
    let destination: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Navigate your way")
                .font(.title2.bold())
                .padding(.top, 32)
            
            Text(destination)
                .font(.title3)
                .foregroundColor(.mint)
                .padding(.vertical, 8)
            
            Divider()
                .padding(.horizontal)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    NavigationStep(icon: "flag.fill", text: "Start at the Main Entrance of Building 01")
                    NavigationStep(icon: "arrow.right", text: "Walk straight ahead towards the Reception Desk.01")
                    NavigationStep(icon: "arrow.turn.up.right", text: "Turn right after the reception")
                    NavigationStep(icon: "door.left.hand.open", text: "Take the Elevator or Staircase to Floor 4")
                    NavigationStep(icon: "arrow.left", text: "Exit the Elevator/Staircase and turn left")
                    NavigationStep(icon: "figure.walk", text: "Follow the hallway past Room 401 & 402")
                    NavigationStep(icon: "mappin.circle.fill", text: "\(destination) will be on your right")
                    
                    Text("You've arrived at \(destination)")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                }
                .padding(24)
            }
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.mint)
                    .cornerRadius(12)
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }
}

struct NavigationStep: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.mint)
                .frame(width: 32)
            
            Text(text)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

// Data Model
struct Location: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let coordinate: CLLocationCoordinate2D
    let description: String
}

struct ActivityMapView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityMapView()
    }
}

