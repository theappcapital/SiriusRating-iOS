//
//  ContentView.swift
//  SiriusRatingSwiftUI
//
//  Created by Thomas Neuteboom on 15/09/2022.
//

import SwiftUI
import SiriusRating

@MainActor class ViewModel: ObservableObject {
    
    private let siriusRating: SiriusRating
    
    @Published private(set) var significantEventsCount: UInt
    
    init(siriusRating: SiriusRating = SiriusRating.shared) {
        self.siriusRating = siriusRating
        self.significantEventsCount = siriusRating.dataStore.significantEventCount
    }
    
    func userDidSignificantEvent() {
        self.siriusRating.userDidSignificantEvent()
        self.significantEventsCount = self.siriusRating.dataStore.significantEventCount
    }
    
    func resetAllUsageTrackers() {
        self.siriusRating.resetAllTrackers()
        self.significantEventsCount = self.siriusRating.dataStore.significantEventCount
    }
    
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("Significant events: \(self.viewModel.significantEventsCount)")
                .multilineTextAlignment(.center)
                .padding(.bottom, 4)
            Text("(Prompt will trigger when it reached 5 significant events)")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            Button {
                self.viewModel.userDidSignificantEvent()
            } label: {
                Text("Trigger significant event")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            Button {
                self.viewModel.resetAllUsageTrackers()
            } label: {
                Text("Reset all usage trackers")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(12)
            }.padding(.bottom, 50)
            Button {
                SiriusRating.shared.showRequestPrompt()
            } label: {
                Text("Test request prompt")
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(12)
            }.padding(.bottom)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
