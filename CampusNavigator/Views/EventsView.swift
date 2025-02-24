import SwiftUI
import EventKit

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let day: String
    let weekday: String
    let month: String
    let venue: String
    let time: String
    let imageName: String?
}

struct EventsView: View {
    @State private var isKeyboardVisible = false
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
                    .padding(.leading)
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(events) { event in
                                EventComponent(title: event.title, description: event.description, day: event.day, weekday: event.weekday, month: event.month)
                                    .onTapGesture {
                                        selectedEvent = event
                                        isEventDetailPresented = true
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, isKeyboardVisible ? geometry.safeAreaInsets.bottom : 0)
            }
            .padding(.top, 50)
            .frame(maxHeight: .infinity)
            .onTapGesture {
                self.isKeyboardVisible = false
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            // Add Event Button at the Bottom Right Corner
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
        .sheet(isPresented: $isEventDetailPresented) {
            if let selectedEvent = selectedEvent {
                EventDetailView(event: selectedEvent)
            }
        }
        .sheet(isPresented: $isAddEventPresented) {
            AddEventView()
        }
    }
}

struct EventDetailView: View {
    let event: Event
    let eventStore = EKEventStore()
    @Environment(\.presentationMode) var presentationMode
    
    func addToCalendar() {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted && error == nil {
                let newEvent = EKEvent(eventStore: eventStore)
                newEvent.title = event.title
                newEvent.startDate = Date() // Placeholder: Adjust as needed
                newEvent.endDate = Calendar.current.date(byAdding: .hour, value: 2, to: Date())
                newEvent.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(newEvent, span: .thisEvent)
                } catch {
                    print("Error saving event: \(error.localizedDescription)")
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("Cancel")
                }
                .padding()
                Spacer()
            }
            
            if let eventImage = event.imageName {
                Image(eventImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding()
            }
            
            Text(event.title)
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text(event.description)
                .font(.body)
                .padding()
            
            Text("📅 Date: \(event.day) \(event.month) 2025")
                .font(.headline)
            
            Text("📍 Venue: \(event.venue)")
                .font(.headline)
            
            Text("⏰ Time: \(event.time)")
                .font(.headline)
            
            Spacer()
            
            Button(action: addToCalendar) {
                HStack {
                    Text("Add to my calendar")
                    Image(systemName: "plus.circle.fill")
                }
                .foregroundColor(.blue)
                .padding()
            }
        }
        .padding(.top, 50)
    }
}

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var eventTitle: String = ""
    @State private var eventDescription: String = ""
    @State private var eventDate: String = ""
    @State private var eventTime: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Text("Cancel")
                }
                .padding()
                Spacer()
            }
            
            Text("Add New Event")
                .font(.largeTitle)
                .bold()
                .padding()
            
            TextField("Event Title", text: $eventTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Event Description", text: $eventDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Event Date", text: $eventDate)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Event Time", text: $eventTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Spacer()
            
            Button(action: {
                // Handle adding event logic here
                print("Event Added: \(eventTitle), \(eventDescription), \(eventDate), \(eventTime)")
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Text("Add Event")
                    Image(systemName: "plus.circle.fill")
                }
                .foregroundColor(.blue)
                .padding()
            }
        }
        .padding(.top, 50)
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}
