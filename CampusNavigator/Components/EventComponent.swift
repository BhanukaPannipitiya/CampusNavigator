//
//  EventComponent.swift
//  CampusNavigator
//
//  Created by Bhanuka  Pannipitiya  on 2025-02-17.
//

import SwiftUI

struct EventComponent: View {
    let title: String
    let description: String
    let day: String
    let weekday: String
    let month: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .bold()
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(day)
                    .font(.title)
                    .bold()
                    .foregroundColor(.red)
                
                HStack(spacing: 2) {
                    Text(weekday.uppercased())
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.gray)
                    
                    Text(month.uppercased())
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(radius: 1)
    }
}

// Preview with sample data
struct EventComponent_Previews: PreviewProvider {
    static var previews: some View {
        EventComponent(
            title: "iOS Workshop",
            description: "Learn SwiftUI basics.",
            day: "7",
            weekday: "Sun",
            month: "June"
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
