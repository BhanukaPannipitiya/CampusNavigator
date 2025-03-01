//
//  EventSlideShow.swift
//  CampusNavigator
//
//  Created by Bhanuka Pannipitiya on 2025-02-24.
//

import SwiftUI

struct EventSlideshowView: View {
    let eventBanners = ["banner1", "banner2", "banner3","banner2"]
    @State private var currentIndex = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $currentIndex) {
                ForEach(0..<eventBanners.count, id: \.self) { index in
                    Image(eventBanners[index])
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .shadow(radius: 4)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 200)
            .cornerRadius(12)
            .onAppear {
                startAutoSlide()
            }
        }
        .padding(.horizontal, 10)
    }
    
    private func startAutoSlide() {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % eventBanners.count
            }
        }
    }
}

struct EventSlideshowView_Previews: PreviewProvider {
    static var previews: some View {
        EventSlideshowView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

