//
//  AddEditActivityScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/12/21.
//

import SwiftUI
import SwiftUIFlowLayout
import CoreData
import CoreLocation
import CoreLocationUI

struct AddEditActivityScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @EnvironmentObject var locationManager: LocationManager
    @ObservedObject var activity: Activity
    @Binding var showAddEditScreen: Bool
    
    var isAdding: Bool
    var colorSet: DayTime.ColorSet {
        Helpers.colorByTime(time_)
    }
    @State private var showSelectTagsScreen = false
    @State private var showDateSelector = false
    @State private var showAddPhotoScreen = false
    @State private var showSelectTripScreen = false
    @State private var time_: Date
    @State private var tags_: Set<Tag>
    @State private var note_: String
    @State private var errorMessage: String?
    @State private var photos_: [Photo]
    @State private var videos_: [Video]
    @State private var location_: Location?
    @State private var showCameraLibraryScreen = false
    @State private var showSuggestedPlacesScreen = false
    
    init(activity: Activity, isAdding: Bool, colorSet: DayTime.ColorSet, showAddEditScreen: Binding<Bool>) {
        _time_ = State(initialValue: activity.time)
        _tags_ = State(initialValue: activity.tags)
        _note_ = State(initialValue: activity.note == Labels.noNote ? "" : activity.note)
        _photos_ = State(initialValue: activity.photos.map { $0 })
        _videos_ = State(initialValue: activity.videos.map { $0 })
        _location_ = State(initialValue: activity.location_)
        self._showAddEditScreen = showAddEditScreen
        self.isAdding = isAdding
        self.activity = activity
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            colorSet.main.ignoresSafeArea()
            
            ScrollViewReader { proxy in
                ScrollView {
                    CancelDoneView(
                        onCancel: {
                            showAddEditScreen = false
                            
                        },
                        onDone: onTapDone,
                        colorSet: colorSet
                    ).id(0)
                    .padding()
                    
                    title
                    VStack(alignment: .leading, spacing: DrawingConstants.defaultSpacing) {
                        timeSelector
                        
                        VStack {
                            tagSelector.padding(.vertical)
                            selectedTags
                        }
                        
                        VStack(alignment: .leading) {
                            locationSelector
                            markedLocation
                        }
                        
                        VStack(alignment: .leading) {
                            newPhoto.padding(.bottom, 10)
                            photoSelector
                        }
                        
                        note
                    }
                    .id(1)
                    .padding()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIWindow.keyboardDidShowNotification), perform: { _ in
                    withAnimation {
                        proxy.scrollTo(1, anchor: .bottom)
                    }
                })
            }
        }
        .showError(shouldShow: errorMessage != nil, message: errorMessage ?? "", action: { errorMessage = nil })
        .sheet(isPresented: $showSelectTagsScreen) {
            SelectTagsScreen(selectedTags: $tags_, colorSet: colorSet)
        }
        .sheet(isPresented: $showDateSelector) {
            DatePickerView(currentDate: $time_, dateComponents: [.date, .hourAndMinute])
        }
        .sheet(isPresented: $showAddPhotoScreen) {
            AddEditPhotoVideoScreen(photos: $photos_, videos: $videos_, showCameraLibraryScreen: $showCameraLibraryScreen, colorSet: colorSet)
        }
        .sheet(isPresented: $showSuggestedPlacesScreen) {
            SuggestedPlacesScreen(location: $location_, colorSet: colorSet)
        }
        .onChange(of: time_) { _ in showDateSelector = false }
        .onAppear {
        }
    }
    
    var title: some View {
        Text.header(isAdding ? Labels.newActivity : Labels.editActivity)
            .foregroundColor(colorSet.textColor)
    }
    
    var timeSelector: some View {
        HStack {
            Text.regular(time_.weekDayMonthYearFormattedString + " " + time_.hourAndMinuteFormattedString).foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "clock.fill")
                .foregroundColor(colorSet.main)
                .font(.title2)
        }
        .padding()
        .buttonfity(mainColor: .white, shadowColor: .shadow, action: { showDateSelector = true })
    }
    
    var tagSelector: some View {
        HStack {
            Text.regular(Labels.selectYourTags).foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "tag.fill")
                .foregroundColor(colorSet.main)
                .font(.title2)
        }
        .padding()
        .buttonfity {
            showSelectTagsScreen = true
        }
    }
    
    @ViewBuilder
    var selectedTags: some View {
        let sortedTags = tags_.sorted { $0.name > $1.name }.map { $0.name }
        FlowLayout(mode: .scrollable, binding: $tags_, items: sortedTags) { tag in
            Text.regular(tag)
                .foregroundColor(.black)
                .padding(DrawingConstants.tagInnerPadding)
                .background(Color.white)
                .cornerRadius(DrawingConstants.tagCornerRadius)
        }
    }
    
    var newPhoto: some View {
        HStack {
            Image(systemName: "camera.fill")
                .foregroundColor(colorSet.main)
                .font(.title2)
        }
        .padding()
        .buttonfity {
            showAddPhotoScreen = true
            showCameraLibraryScreen = true
        }
    }
    
    @ViewBuilder
    var photoSelector: some View {
        let photosDescription = photos_.count == 0 ? Labels.addViewPhoto : "\(photos_.count) photos"
        VStack(alignment: .leading) {
            HStack {
                Text.regular(photosDescription).foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "photo.fill")
                    .foregroundColor(colorSet.main)
                    .font(.title2)
            }
            .padding()
            .buttonfity {
                showAddPhotoScreen = true
            }
        }
        .foregroundColor(colorSet.textColor)
    }
    
    var note: some View {
        VStack(alignment: .leading) {
            Text.regular(Labels.note).foregroundColor(colorSet.textColor)
            ExpandingTextView(text: $note_, font: .body)
                .cornerRadius(20)
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    var locationSelector: some View {
        HStack {
            Text.regular(Labels.withLocationTracking).foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "location.fill")
                .foregroundColor(colorSet.main)
                .font(.title2)
        }
        .padding()
        .buttonfity {
            showSuggestedPlacesScreen = true
        }
    }
    
    @ViewBuilder
    var markedLocation: some View {
        if let location = location_ {
            Text.regular(location.displayingaddress)
                .foregroundColor(.black)
                .padding(DrawingConstants.tagInnerPadding)
                .background(Color.white)
                .cornerRadius(DrawingConstants.tagCornerRadius)
                .padding(.vertical)
        } else { EmptyView() }
    }
    
    private func onTapDone() {
        do {
            try Activity.save(activity: activity, with: (time_, tags_, Set(photos_), Set(videos_), note_,  location_), in: context)
            showAddEditScreen = false
        } catch let error as DataError {
            withAnimation {
                errorMessage = error.message
            }
        } catch {
            fatalError("Unknown error")
        }
    }
    
    private func onNewPlace(_ place: CLPlacemark) {
        showSuggestedPlacesScreen = true
    }
    
    struct DrawingConstants {
        static let cancelDoneButtonInnerPadding: CGFloat = 8
        static let noteCornerRadius: CGFloat = 20
        static let noteMinHeight: CGFloat = 100
        static let tagInnerPadding: CGFloat = 8
        static let tagCornerRadius: CGFloat = 10
        static let defaultSpacing: CGFloat = 30
    }
}

struct AddEditActivityScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddEditActivityScreen(activity: Activity(context: PersistenceController.preview.container.viewContext), isAdding: true, colorSet: DayTime.noon.colors, showAddEditScreen: .constant(true))
    }
}
