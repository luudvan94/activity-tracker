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
    @State private var selectedActivity: Activity?
    var activityDetailHandler: ActivityDetailHandler
    
    init(filter: Searchable, activityDetailHandler: @escaping ActivityDetailHandler) {
        let request = Activity.fetchRequest(with: filter.predicate)
        _activities = FetchRequest(fetchRequest: request)
        self.activityDetailHandler = activityDetailHandler
    }
    
    var colorSet: TimeColor.ColorSet {
        Helpers.colorByTime()
    }
    
    var body: some View {
        ZStack {
            activitiyList
        }
    }
    
    var activitiyList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: DrawingConstants.defaultSpacing) {
                ForEach(activities) { activity in
                    ActivityCardView(activity: activity, onActivityTapHandler: activityDetailHandler)
                        .transition(.asymmetric(insertion: .scale(scale: DrawingConstants.activityCardScaleFactor).animation(.easeInOut(duration: DrawingConstants.activityCardAnimationDuation)), removal: .identity))
                }
                Color.clear.padding(.bottom, 20)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(DrawingConstants.activityCardCornerRadius)
    }
    
    struct DrawingConstants {
        static let activityCardScaleFactor: CGFloat = 0.92
        static let activityCardAnimationDuation: CGFloat = 0.1
        static let activityCardCornerRadius: CGFloat = 20
        static let defaultSpacing: CGFloat = 60
        static let notFoundIconFontSize: CGFloat = 80
    }
}

struct ActivitiesListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesListView(filter: Activity.Filter.init(selectedDate: Date())) { activity in
            
        }
    }
}
