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
    var focusActivity: Activity?
    var activityDetailHandler: ActivityDetailHandler
    @State private var activitiesRegion = defaultRegion
    
    init(filter: Searchable, activityToFocus: Activity? = nil, activityDetailHandler: @escaping ActivityDetailHandler) {
        let request = Activity.fetchRequest(with: filter.predicate, sortDescriptors: filter.sort)
        _activities = FetchRequest(fetchRequest: request)
        self.activityDetailHandler = activityDetailHandler
        self.focusActivity = activityToFocus
    }
    
    var body: some View {
        ZStack {
            map.cornerRadius(DrawingConstants.cornerRadius)
        }
        .onAppear {
            configureRegion()
        }
    }
    
    var map: some View {
        
        Map(coordinateRegion: $activitiesRegion, annotationItems: coordinatedActivities) { activity in
            MapAnnotation(coordinate: activity.location_!.coordinate!) {
                ActivityAnnotationView(activity: activity) {
                    activityDetailHandler(activity)
                }
            }
        }
    }
    
    private func configureRegion() {
        var regionCoordinate: CLLocationCoordinate2D? = nil
        if let coordinate = focusActivity?.location_?.coordinate {
            regionCoordinate = coordinate
        } else if let coordinate = newestActivity?.location_?.coordinate {
            regionCoordinate = coordinate
        }
        
        if regionCoordinate != nil {
            activitiesRegion = MKCoordinateRegion(center: regionCoordinate!, latitudinalMeters: 750, longitudinalMeters: 750)
        }
    }
    
    var coordinatedActivities: [Activity] {
        return activities.filter { $0.location_ != nil }
    }
    
    var newestActivity: Activity? {
        activities.filter { $0.location_ != nil }.sorted { $0.time > $1.time }.first
    }
}

fileprivate struct DrawingConstants {
    static let cornerRadius: CGFloat = 20
}

struct ActivitiesMapView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesMapView(filter: Activity.Filter.init(), activityToFocus: Activity()) { activity in
            
        }
    }
}
