//
//  ActivitiesListView.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI
import CoreData

struct EventsListView: View {
    @FetchRequest var activities: FetchedResults<Activity>
    @FetchRequest var trips: FetchedResults<Trip>
    @State private var selectedActivity: Activity?
    var activityDetailHandler: ActivityDetailHandler
    var tripDetailHandler: TripDetailHandler
    
    init(activitiesFilter: Searchable, tripsFilter: Searchable, activityDetailHandler: @escaping ActivityDetailHandler, tripDetailHandler: @escaping TripDetailHandler) {
        let activityRequest = Activity.fetchRequest(with: activitiesFilter.predicate)
        let tripRequest = Trip.fetchRequest(with: tripsFilter.predicate)
        _activities = FetchRequest(fetchRequest: activityRequest)
        _trips = FetchRequest(fetchRequest: tripRequest)
        self.activityDetailHandler = activityDetailHandler
        self.tripDetailHandler = tripDetailHandler
    }
    
    var colorSet: DayTime.ColorSet {
        Helpers.colorByTime()
    }
    
    var body: some View {
        ZStack {
            eventsList
        }
    }
    
    @ViewBuilder
    var eventsList: some View {
        let activitiesNotInAnyTrip = activities.filter { $0.trip_ == nil }
        let activitiesByTime = Dictionary(grouping: activitiesNotInAnyTrip) { $0.time.timeIntervalSince1970 }
        let tripsByTime = Dictionary(grouping: trips) { $0.time.timeIntervalSince1970 }
        let orderedTime = (Array(activitiesByTime.keys) + Array(tripsByTime.keys)).sorted { $0 < $1}
        EventsListContainer {
            ForEach(orderedTime, id: \.self) { time in
                ForEach(activitiesNotInAnyTrip.filter { $0.time.timeIntervalSince1970 == time}) { activity in
                    ActivityCardView(activity: activity, onActivityTapHandler: activityDetailHandler)
                        .transition(.asymmetric(insertion: .scale(scale: DrawingConstants.cardScaleFactor).animation(.easeInOut(duration: DrawingConstants.cardAnimationDuration)), removal: .identity))
                }
                
                ForEach(trips.filter { $0.time.timeIntervalSince1970 == time}) { trip in
                    TripCardView(trip: trip, onTripTapHandler: tripDetailHandler)
                        .transition(.asymmetric(insertion: .scale(scale: DrawingConstants.cardScaleFactor).animation(.easeInOut(duration: DrawingConstants.cardAnimationDuration)), removal: .identity))
                }
            }
            Color.clear.padding(.bottom, 20)
        }
    }
    
    struct DrawingConstants {
        static let cardScaleFactor: CGFloat = 0.92
        static let cardAnimationDuration: CGFloat = 0.1
        static let notFoundIconFontSize: CGFloat = 80
    }
}

struct ActivitiesListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView(activitiesFilter: Activity.Filter.init(selectedDate: Date()), tripsFilter: Trip.Filter.init(selectedDate: Date()), activityDetailHandler: { activity in
            
        }) { trip in
            
        }
    }
}
