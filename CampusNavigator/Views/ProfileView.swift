import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @State private var username: String = "Chiara Tews"
    @State private var name: String = "Chiara"
    @State private var surname: String = "Tews"
    @State private var email: String = "ChiaraTews@gmail.com"
    @State private var address: String = "Bakers Street London"
    @State private var isDarkMode: Bool = false
    @State private var isEditMode: Bool = false
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var profileImage: Image = Image("profilepic")
    @State private var campusPoints: Int = 250
    @State private var showingRedeemSheet = false
    
    let haptic = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        profileImageSection
                        
                        
                        campusPointsSection
                        
                        
                        profileInfoSection
                            .disabled(!isEditMode)
                        
                        
                        settingsSection
                        
                        
                        Button(action: {
                            haptic.impactOccurred()
                            
                        }) {
                            Text("Logout")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("My Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .fontWeight(.medium)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        haptic.impactOccurred()
                        withAnimation(.spring()) {
                            isEditMode.toggle()
                        }
                    }) {
                        Text(isEditMode ? "Done" : "Edit")
                            .fontWeight(.medium)
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images
                ) {
                    Text("Select a photo")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingCamera) {
                Text("Camera placeholder")
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingRedeemSheet) {
                RedeemPointsView(points: $campusPoints)
                    .presentationDetents([.medium, .large])
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            profileImage = Image(uiImage: uiImage)
                            return
                        }
                    }
                    print("Failed to load image")
                }
            }
            .onAppear {
                isDarkMode = colorScheme == .dark
            }
        }
    }
    
    
    private var profileImageSection: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                profileImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(.systemBackground), lineWidth: 4)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(4)
                
                if isEditMode {
                    Button(action: {
                        haptic.impactOccurred()
                        showingActionSheet = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.mint)
                                .frame(width: 36, height: 36)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                    .offset(x: 6, y: 6)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.bottom, 4)
            
            Text("Chiara Tews")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .confirmationDialog("Change profile picture", isPresented: $showingActionSheet, titleVisibility: .visible) {
            Button("Take Photo") {
                showingCamera = true
            }
            Button("Choose From Library") {
                showingImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    
    private var campusPointsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("CAMPUS POINTS")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.leading)
                .padding(.bottom, 8)
            
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(campusPoints) Points")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Level: \(getLevel(points: campusPoints))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        haptic.impactOccurred()
                        showingRedeemSheet = true
                    }) {
                        Text("Redeem")
                            .font(.headline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Activity")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            PointsActivityCard(
                                iconName: "gauge.medium",
                                activity: "Reported Library Occupancy",
                                points: "+5",
                                time: "Today"
                            )
                            
                            PointsActivityCard(
                                iconName: "building.2",
                                activity: "Reported Study Room Availability",
                                points: "+5",
                                time: "Yesterday"
                            )
                            
                            PointsActivityCard(
                                iconName: "gift",
                                activity: "Redeemed Campus Cafe Discount",
                                points: "-50",
                                time: "Last week"
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 12)
            }
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
    
    private func getLevel(points: Int) -> String {
        switch points {
        case 0..<100:
            return "Freshman"
        case 100..<250:
            return "Sophomore"
        case 250..<500:
            return "Junior"
        case 500..<1000:
            return "Senior"
        default:
            return "Graduate"
        }
    }
    
    
    private var profileInfoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("PROFILE")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.leading)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                ProfileTextField(title: "Username", text: $username, isEditing: isEditMode)
                
                Divider()
                    .padding(.leading)
                
                ProfileTextField(title: "Name", text: $name, isEditing: isEditMode)
                
                Divider()
                    .padding(.leading)
                
                ProfileTextField(title: "Surname", text: $surname, isEditing: isEditMode)
                
                Divider()
                    .padding(.leading)
                
                ProfileTextField(title: "Email", text: $email, isEditing: isEditMode)
                
                Divider()
                    .padding(.leading)
                
                ProfileTextField(title: "Address", text: $address, isEditing: isEditMode)
            }
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("SETTINGS")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.leading)
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                HStack {
                    Text("Appearance:")
                        .padding(.leading)
                    
                    Spacer()
                    
                    Picker("Appearance", selection: $isDarkMode) {
                        HStack {
                            Image(systemName: "sun.max.fill")
                            Text("Light")
                        }
                        .tag(false)
                        
                        HStack {
                            Image(systemName: "moon.fill")
                            Text("Dark")
                        }
                        .tag(true)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 160)
                    .padding(.trailing)
                }
                .padding(.vertical, 14)
                
                Divider()
                    .padding(.leading)
                
                NavigationLink {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            VStack(alignment: .leading, spacing: 16) {
                                NotificationItem2(
                                    title: "Campus Alert",
                                    message: "Construction on West Campus may cause delays. Please plan accordingly.",
                                    time: "2 hours ago",
                                    icon: "cone.fill",
                                    color: .orange
                                )
                                
                                NotificationItem2(
                                    title: "Weather Advisory",
                                    message: "Heavy rain expected this afternoon. Indoor routes recommended.",
                                    time: "Today, 8:30 AM",
                                    icon: "cloud.rain.fill",
                                    color: .blue
                                )
                            }
                            .padding()
                        }
                        .padding()
                    }
                    .navigationTitle("Notifications")
                } label: {
                    HStack {
                        Text("Notifications")
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 14)
                }
                
                Divider()
                    .padding(.leading)
                
            }
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
}


struct ProfileTextField: View {
    let title: String
    @Binding var text: String
    var isEditing: Bool
    
    var body: some View {
        HStack {
            if isEditing {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField(title, text: $text)
                        .font(.body)
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
            } else {
                Text(title)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(text)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(.vertical, isEditing ? 6 : 14)
        .padding(.horizontal)
        .background(isEditing ? Color.clear : Color.clear)
        .contentShape(Rectangle())
    }
}

struct NotificationItem2: View {
    var title: String
    var message: String
    var time: String
    var icon: String
    var color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(color)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct PointsActivityCard: View {
    let iconName: String
    let activity: String
    let points: String
    let time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(points.contains("+") ? Color.green : Color.orange)
                    .cornerRadius(8)
                
                Text(points)
                    .font(.headline)
                    .foregroundColor(points.contains("+") ? .green : .orange)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(activity)
                    .font(.subheadline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.9)
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 200, height: 120)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}


struct RedeemPointsView: View {
    @Binding var points: Int
    @Environment(\.dismiss) private var dismiss
    @State private var selectedReward: Reward?
    @State private var showingConfirmation = false
    @State private var isRedeeming = false
    
    let rewards = [
        Reward(id: 1, name: "10% Off Campus Cafe", description: "Valid for one purchase", points: 50, iconName: "cup.and.saucer.fill"),
        Reward(id: 2, name: "Free Printing Credit", description: "100 pages of printing", points: 75, iconName: "printer.fill"),
        Reward(id: 3, name: "Library Late Fee Waiver", description: "One-time fee waiver", points: 100, iconName: "books.vertical.fill"),
        Reward(id: 4, name: "24h Study Room Access", description: "Extended hours access pass", points: 150, iconName: "key.fill"),
        Reward(id: 5, name: "Campus Parking Pass", description: "One day free parking", points: 200, iconName: "car.fill")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                VStack {
                    Text("Your Points Balance")
                        .font(.headline)
                    
                    Text("\(points)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(Color.blue.opacity(0.1))
                
                
                List {
                    ForEach(rewards) { reward in
                        RewardRow(
                            reward: reward,
                            isSelected: selectedReward?.id == reward.id,
                            canAfford: points >= reward.points
                        )
                        .onTapGesture {
                            if points >= reward.points {
                                selectedReward = reward
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    }
                }
                .listStyle(PlainListStyle())
                
                
                Button(action: {
                    if let reward = selectedReward {
                        isRedeeming = true
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            points -= reward.points
                            isRedeeming = false
                            showingConfirmation = true
                        }
                    }
                }) {
                    if isRedeeming {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.horizontal)
                    } else {
                        Text("Redeem Selected Reward")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedReward == nil ? Color.gray.opacity(0.3) : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding()
                .disabled(selectedReward == nil || isRedeeming)
                .alert("Reward Redeemed!", isPresented: $showingConfirmation) {
                    Button("OK") {
                        selectedReward = nil
                        dismiss()
                    }
                } message: {
                    if let reward = selectedReward {
                        Text("You've successfully redeemed \(reward.name). Check your rewards in the app.")
                    }
                }
            }
            .navigationTitle("Redeem Points")
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


struct Reward: Identifiable {
    let id: Int
    let name: String
    let description: String
    let points: Int
    let iconName: String
}

struct RewardRow: View {
    let reward: Reward
    let isSelected: Bool
    let canAfford: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(canAfford ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: reward.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(canAfford ? .blue : .gray)
            }
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reward.name)
                    .font(.headline)
                    .foregroundColor(canAfford ? .primary : .gray)
                
                Text(reward.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("\(reward.points) points")
                    .font(.subheadline)
                    .foregroundColor(canAfford ? .blue : .gray)
                    .padding(.top, 2)
            }
            
            Spacer()
            
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
        )
        .opacity(canAfford ? 1.0 : 0.6)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .previewDisplayName("Light Mode")
        
        ProfileView()
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}
