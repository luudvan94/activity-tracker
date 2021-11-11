//
//  ActivitiesListView.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI
import CoreData

struct ActivitiesListView: View {
    @FetchRequest var activities: FetchedResults<Activity>
    
    init(filter: Searchable) {
        let request = Activity.fetchRequest(with: filter.predicate)
        _activities = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 60) {
                ForEach(activities) { activity in
                    ActivityCardView(activity: activity)
                }
                Color.clear.padding(.bottom, 20)
            }
            .padding()
        }.background(Color.white).cornerRadius(20)
    }
}

struct ActivitiesListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesListView(filter: Activity.Filter.init(selectedDate: Date()))
    }
}
