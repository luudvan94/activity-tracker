//
//  HomeView.swift
//  Activity Tracker
//
//  Created by luu van on 11/8/21.
//

import SwiftUI
import CoreData
import SwiftUIFlowLayout

struct HomeView: View {

    var body: some View {
        ZStack {
            background
            
            VStack(alignment: .leading) {
                selectedDateTime.padding()
                calendarAndDateSelector.frame(height: 50).padding(.horizontal)
                activitiesList.padding()
            }
        }
    }
    
    var background: some View {
        Color.blueMint.ignoresSafeArea()
    }
    
    var selectedDateTime: some View {
        Text.header("Tuesday, 9 Nov, 2021")
    }
    
    var calendarAndDateSelector: some View {
        HStack {
            Image(systemName: "calendar").foregroundColor(.blueMint).font(.title).buttonfity(mainColor: .white, shadowColor: .shadow, action: {}).frame(width: 50)
            
            ZStack {
                Color.white.cornerRadius(20)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 40) {
                        Text.regular("1")
                        Text.regular("2")
                        Text.regular("3")
                        Text.regular("4")
                        Text.regular("5")
                        Text.regular("6")
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    
    var activitiesList: some View {
        ScrollView {
            VStack(spacing: 60) {
                ForEach(0..<20) { _ in
                    activity
                }
            }
            .padding()
        }.background(Color.white).cornerRadius(20)
    }
    
    var activity: some View {
        VStack {
            FlowLayout(mode: .scrollable, items: ["asda", "asda asdads", "asdasd", "asdasd bavsbdvan dbvansdvnavsdbavndv"]) { item in
                Text.regular(item)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(10)
            }

        }
        .padding(5)
        .buttonfity(mainColor: .redPink, shadowColor: .redPinkShadow, action: {})
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
