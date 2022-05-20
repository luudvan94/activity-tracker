//
//  ActivitiesMapView.swift
//  Activity Tracker
//
//  Created by luu van on 3/4/22.
//

import SwiftUI
import MapKit

fileprivate let defaultRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 37.334_900,
                                   longitude: -122.009_020),
    latitudinalMeters: 750,
    longitudinalMeters: 750)

struct ActivitiesMapView: View {
    @FetchRequest var activities: FetchedResults<Activity>
    var centerActivity: Activity?
    var activityDetailHandler: ActivityDetailHandler
    @State private var activitiesRegion = defaultRegion
    
    init(filter: Searchable, centerActivity: Activity? = nil, activityDetailHandler: @escaping ActivityDetailHandler) {
        let request = Activity.fetchRequest(with: filter.predicate, sortDescriptors: filter.sort)
        _activities = FetchRequest(fetchRequest: request)
        self.activityDetailHandler = activityDetailHandler
        self.centerActivity = centerActivity
    }
    
    var body: some View {
        ZStack {
//            map.cornerRadius(DrawingConstants.cornerRadius)
            
        }
//        .onAppear {
//            if let coordinate = centerActivity?.location {
//                activitiesRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
//            } else if let coordinate = activities.filter({ $0.coordinate != nil }).sorted(by: { $0.time > $1.time }).first?.coordinate {
//                activitiesRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
//            }
//        }
    }
    
//    var map: some View {
//        Map(coordinateRegion: $activitiesRegion, annotationItems: coordinatedActivities) { activity in
//            MapAnnotation(coordinate: activity.coordinate!) {
//                ActivityAnnotationView(activity: activity) {
//                    activityDetailHandler(activity)
//                }
//            }
//        }
//    }
    
//    var coordinatedActivities: [Activity] {
//        return activities.filter { $0.coordinate != nil }
//    }
    
}

fileprivate struct DrawingConstants {
    static let cornerRadius: CGFloat = 20
}

struct ActivitiesMapView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesMapView(filter: Activity.Filter.init(), centerActivity: Activity()) { activity in
            
        }
    }
}
