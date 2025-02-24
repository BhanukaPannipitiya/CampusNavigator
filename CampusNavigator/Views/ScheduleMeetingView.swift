//
//  ScheduleMeetingView.swift
//  CampusNavigator
//
//  Created by Nisila Chandunu on 2025-02-24.
//

import SwiftUI

struct ScheduleMeetingView: View {
    let lecturer: Lecturer

        var body: some View {
            NavigationView{
                VStack {
                    
                    
                    Text(lecturer.title)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    Text(lecturer.description)
                        .font(.body)
                        .padding()
                    
                    Spacer()
                }
                .navigationBarBackButtonHidden(true)
                
            }
        }
}

#Preview {
    ScheduleMeetingView(lecturer: Lecturer(title: "Dr. Sample Lecturer", description: "Meeting discussion on research topics"))
}
