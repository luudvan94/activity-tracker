//
//  SelectTripScreen.swift
//  Activity Tracker
//
//  Created by luu van on 2/28/22.
//

import SwiftUI
import CoreData

struct SelectTripScreen: View {
    typealias TripSelectedHandler = (Trip) -> Void
    @FetchRequest var trips: FetchedResults<Trip>
    @State private var showAddTripScreen = false
    
    var colorSet: DayTime.ColorSet
    var activityDate: Date?
    @Binding private var selectedTrips: Set<Trip>
    var onSelect: TripSelectedHandler
    
    init(filter: Searchable, colorSet: DayTime.ColorSet, activityDate: Date? = nil, selectedTrips: Binding<Set<Trip>>, onSelect: @escaping TripSelectedHandler) {
        let request = Trip.fetchRequest(with: filter.predicate)
        _trips = FetchRequest(fetchRequest: request)
        
        self.colorSet = colorSet
        self._selectedTrips = selectedTrips
        self.activityDate = activityDate
        self.onSelect = onSelect
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                VStack {
                    title
                    VStack {
                        content()
                    }.padding(.vertical)
                }.padding()
            }
            
            addNewTrip
        }
        .fullScreenCover(isPresented: $showAddTripScreen) {
            AddTripScreen(colorSet: colorSet, showAddTripScreen: $showAddTripScreen)
        }
    }
    
    var title: some View {
        Text.header(Labels.trips).foregroundColor(colorSet.textColor)
    }
    
    @ViewBuilder
    func content() -> some View {
        if trips.count > 0 {
            let sortedTrips = trips.sorted { $0.name.count < $1.name.count }
            VStack(alignment: .leading) {
                if let activityDate = activityDate {
                    Text.regular(Labels.tripsAvailable + activityDate.dayMonthYearFormattedString).foregroundColor(colorSet.textColor)
                }
                FlowLayout(mode: .scrollable, items: sortedTrips) { trip in
                    HStack {
                        Text(trip.name).foregroundColor(.black)
                        
                        Image(systemName: "circle.fill")
                            .font(.footnote)
                            .foregroundColor(selectedTrips.contains(trip) ? colorSet.main : .white)
                    }
                    .padding(DrawingConstants.folderInnerPadding)
                    .buttonfity(mainColor: .white, shadowColor: .shadow, action: {
                        onSelect(trip)
                    })
                    .padding(.trailing, DrawingConstants.folderTrailingPadding)
                    .padding(.vertical, DrawingConstants.folderVerticalPadding)
                }
            }
        } else {
            Text.regular(Labels.noTripAvailabel).foregroundColor(colorSet.textColor)
        }
    }
    
    @ViewBuilder
    var addNewTrip: some View {
        ZStack {
            HStack {
                Text.regular(Labels.addNewTrip).foregroundColor(.black).padding().buttonfity {
                    showAddTripScreen = true
                }
                
                Spacer()
            }
        }
        .foregroundColor(colorSet.textColor)
        .padding()
        .background(colorSet.shadow.clipped())
        .padding(.horizontal)
    }
    
    struct DrawingConstants {
        static let addNewTripInnerVerticalPadding: CGFloat = 5
        static let addNewTripInnerHorizontalPadding: CGFloat = 20
        static let folderInnerPadding: CGFloat = 8
        static let folderTrailingPadding: CGFloat = 2
        static let folderVerticalPadding: CGFloat = 5
    }
    
}

struct SelectTripScreen_Previews: PreviewProvider {
    static var previews: some View {
        SelectTripScreen(filter: Trip.Filter.init(selectedDate: Date()), colorSet: DayTime.noon.colors, activityDate: Date(), selectedTrips: .constant([])) { _ in }
    }
}
