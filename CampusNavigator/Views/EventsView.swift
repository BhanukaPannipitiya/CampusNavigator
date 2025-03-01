import SwiftUI
import EventKit

struct Event: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let day: String
    let weekday: String
    let month: String
    let venue: String
    let time: String
    let imageName: String?
    

    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

struct EventsView: View {
    @State private var selectedEvent: Event? = nil
    @State private var isEventDetailPresented = false
    @State private var isAddEventPresented = false
    
    let events: [Event] = [
        Event(title: "Tech Talk", description: "Join us for a discussion on AI advancements.", day: "17", weekday: "Monday", month: "Feb", venue: "Campus Hall", time: "2:00 PM - 4:00 PM", imageName: "profilepic"),
        Event(title: "Hackathon", description: "24-hour coding challenge for developers.", day: "20", weekday: "Thursday", month: "Feb", venue: "Lab 3", time: "9:00 AM - 9:00 AM", imageName: "profilepic"),
        Event(title: "Music Fest", description: "Enjoy live performances from various artists.", day: "25", weekday: "Sunday", month: "Feb", venue: "Open Ground", time: "6:00 PM - 10:00 PM", imageName: "profilepic"),
        Event(title: "Career Fair", description: "Meet top companies and explore job opportunities.", day: "28", weekday: "Wednesday", month: "Feb", venue: "Auditorium", time: "10:00 AM - 4:00 PM", imageName: "profilepic")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                VStack {
                    VStack(spacing: 10) {
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
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(events) { event in
                                EventComponent(title: event.title, description: event.description, day: event.day, weekday: event.weekday, month: event.month)
                                    .onTapGesture {
                                        selectedEvent = event
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .padding(.top, 50)
            
          
            Button(action: {
                isAddEventPresented = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.mint)
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            .padding(.bottom, 30)
        }
        .onChange(of: selectedEvent) { newValue in
            if newValue != nil {
                isEventDetailPresented = true
            }
        }
        .sheet(isPresented: $isEventDetailPresented) {
            if let selectedEvent = selectedEvent {
                EventDetailView(event: selectedEvent)
                    .onDisappear {
                        self.selectedEvent = nil
                    }
            }
        }
        .sheet(isPresented: $isAddEventPresented) {
            AddEventView()
        }
    }
}
struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @State private var eventName = ""
    @State private var subject = ""
    @State private var description = ""
    @State private var startTime = ""
    @State private var endTime = ""
    @State private var studentEmail = ""
    @State private var isKeyboardVisible = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Event Details")) {
                        CustomTextField(
                            
                            text: $eventName,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter event name",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "Event Name",
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
                        
                        CustomTextField(
                            text: $startTime,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter start time (e.g., 2:00 PM)",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "Start Time",
                            labelTextColor: .gray
                            
                        )
                        
                        CustomTextField(
                            
                            text: $endTime,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter end time (e.g., 4:00 PM)",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "End Time",
                            labelTextColor: .gray
                        )
                    }
                    
                    Section {
                        Text("Adding an Event will require further confirmation and please be accurate about information")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Section(header: Text("Verification")) {
                        CustomTextField(
                            text: $studentEmail,
                            isKeyboardVisible: $isKeyboardVisible,
                            placeholder: "Enter student email",
                            textColor: .black,
                            backgroundColor: Color(.systemGray6),
                            fontSize: 16,
                            labelText: "Verification Email",
                            labelTextColor: .gray
                        )
                        
                        Text("Email will be sent to the above email address asking for confirmation of the event details and once the confirmation is done you can see the activity on map")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                Button(action: {
           
                    dismiss()
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
            .navigationTitle("Add Event")
        }
    }
}
struct EventDetailView: View {
    let event: Event
    @Environment(\.dismiss) var dismiss
    @State private var isAnimating = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.mint.opacity(0.2), Color.white]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    ZStack(alignment: .bottomLeading) {
                        if let imageName = event.imageName {
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .clipped()
                                .overlay(
                                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.6)]),
                                                   startPoint: .top,
                                                   endPoint: .bottom
                                                  ))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(event.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(event.venue)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding()
                    }
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 20) {
                
                        HStack(spacing: 20) {
                            DetailCard(icon: "calendar", title: "Date", value: "\(event.day) \(event.month)")
                            DetailCard(icon: "clock", title: "Time", value: event.time)
                        }
                        
              
                        Text(event.description)
                            .font(.body)
                            .lineSpacing(6)
                            .cornerRadius(12)
                            .frame(maxWidth: .infinity)
                        
                
                        Button(action: addToCalendar) {
                            HStack {
                                Image(systemName: "calendar.badge.plus")
                                Text("Add to Calendar")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.mint)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .padding(.vertical,90)
            

            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Text("Close")
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAnimating = true
            }
        }
    }
    

    struct DetailCard: View {
        let icon: String
        let title: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.mint)
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 3)
        }
    }
    
    
    func addToCalendar() {
        let eventStore = EKEventStore()
        
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                handleCalendarAccess(granted: granted, error: error, eventStore: eventStore)
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                handleCalendarAccess(granted: granted, error: error, eventStore: eventStore)
            }
        }
    }
    
    func handleCalendarAccess(granted: Bool, error: Error?, eventStore: EKEventStore) {
        if granted, error == nil {
            let newEvent = EKEvent(eventStore: eventStore)
            newEvent.title = event.title
            newEvent.startDate = Date()
            newEvent.endDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
            newEvent.calendar = eventStore.defaultCalendarForNewEvents
            
            do {
                try eventStore.save(newEvent, span: .thisEvent)
                DispatchQueue.main.async {
                    alertMessage = "Event added successfully to your calendar!"
                    showAlert = true
                }
            } catch {
                DispatchQueue.main.async {
                    alertMessage = "Failed to save event: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        } else {
            DispatchQueue.main.async {
                alertMessage = "Access to calendar denied or error: \(error?.localizedDescription ?? "Unknown error")"
                showAlert = true
            }
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
