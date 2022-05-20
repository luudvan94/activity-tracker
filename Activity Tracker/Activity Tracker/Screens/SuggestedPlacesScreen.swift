//
//  SuggestedPlacesScreen.swift
//  Activity Tracker
//
//  Created by luu van on 5/20/22.
//

import SwiftUI
import CoreData
import CoreLocation

struct SuggestedPlacesScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var locationManager: LocationManager
    @Binding var location: Location?
    var colorSet: DayTime.ColorSet
    
    @State private var searchText = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    searchBar
                    
                    if locationManager.location != nil {
                        markCurrentLocation
                    }
                    
                    VStack(alignment: .leading) {
                        placesAssociatedText
                        suggestedPlace
                            .transition(AnyTransition.opacity)
                    }
                    
                }
                .padding()
            }
        }
        .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
        .onAppear {
            locationManager.requestLocation()
        }
    }
    
    @ViewBuilder
    var markCurrentLocation: some View {
        let isSelected = location != nil && location?.address_ == nil
        HStack {
            Text.regular(Labels.justMarkThisLocation).foregroundColor(.black)
            Image(systemName: "circle.fill")
                .font(.footnote)
                .foregroundColor(isSelected ? colorSet.main : .white)
        }
        .padding()
        .buttonfity {
            configureLocation(coordinate: locationManager.location?.coordinate, address: nil, areaOfInterest: nil, isSelected: isSelected)
        }
    }
    
    var placesAssociatedText: some View {
        Text.regular(Labels.placeAssociatedWithCurrentLocation).foregroundColor(colorSet.textColor)
    }
    
    @ViewBuilder
    var suggestedPlace: some View {
        if let place = locationManager.placemark, let name = place.descriptiveName {
            if let areaOfInterests = place.areasOfInterest, areaOfInterests.count > 0 {
                ForEach(areaOfInterests, id: \.self) { area in
                    let isSelected = location?.address_ == name && location?.areaOfInterest_ == area
                    placeView(for: area + "\n" + name, isSelected: isSelected)
                        .buttonfity {
                            configureLocation(coordinate: locationManager.location?.coordinate, address: name, areaOfInterest: nil, isSelected: isSelected)
                        }
                }
            } else {
                let isSelected = location?.displayingaddress == name
                placeView(for: name, isSelected: isSelected)
                    .buttonfity {
                        configureLocation(coordinate: locationManager.location?.coordinate, address: name, areaOfInterest: nil, isSelected: isSelected)
                    }
            }
        } else {
            EmptyView()
        }
    }
    
    func placeView(for name: String, isSelected: Bool) -> some View {
        HStack {
            Text.regular(name).foregroundColor(.black)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "circle.fill")
                    .foregroundColor(isSelected ? colorSet.main : .white)
                    .font(.footnote)
            }
        }
        .padding()
    }
    
    var searchBar: some View {
        SearchBarView(searchText: $searchText)
    }
    
    private func configureLocation(coordinate: CLLocationCoordinate2D?, address: String?, areaOfInterest: String?, isSelected: Bool) {
        if isSelected {
            location = nil
            return
        }
        
        if let coordinate = coordinate {
            location = Location(context: context)
            location?.configure(coordinate: coordinate, address: address, areaOfInterest: areaOfInterest)
        }
    }
    
    struct DrawingConstants {
        static let tagInnerPadding: CGFloat = 8
        static let tagTrailingPadding: CGFloat = 2
        static let tagVerticalPadding: CGFloat = 5
    }
}
