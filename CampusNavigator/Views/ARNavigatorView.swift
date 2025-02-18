import SwiftUI

struct ARNavigatorView: View {
    let locations = ["Cafeteria", "Auditorium", "Lecture Hall1", "Medical", "Center"]
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Simulated status bar
                HStack {
                    Spacer()
                    Text("9:41")
                        .font(.subheadline)
                        .padding(.trailing)
                        .padding(.top, 8)
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        Text("Where are you headed?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search for a building...", text: .constant(""))
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Location Buttons
                        VStack(spacing: 0) {
                            ForEach(locations, id: \.self) { location in
                                Button(action: {}) {
                                    HStack {
                                        Text(location)
                                            .foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                
                                if location != locations.last {
                                    Divider()
                                }
                            }
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .padding(.horizontal)
                        
                        // AR Preview Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("AR preview")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            RoundedRectangle(cornerRadius: 12)
                                .frame(height: 200)
                                .foregroundColor(Color(.systemGray5))
                                .overlay(
                                    Image(systemName: "viewfinder")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                )
                                .padding(.horizontal)
                            
                            Text("Your destination will appear here in AR")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal)
                        }
                        .padding(.top)
                    }
                    .padding(.vertical)
                }
                
                // Start AR Button
                Button(action: {}) {
                    Text("Start AR Navigation")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
                .background(Color(.systemBackground))
            }
        }
    }
}

struct ARNavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        ARNavigatorView()
    }
}
