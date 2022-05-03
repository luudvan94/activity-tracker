//
//  DetailScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI
import SwiftUIFlowLayout
import CoreData
import ImageViewer
import AVKit

struct ActivityDetailScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var searchFilterData: SearchFilterData
    @EnvironmentObject var appSetting: AppSetting
    
    @State private var showEditScreen = false
    @State private var selectedImage: Image?
    @State private var selectedVideo: Video?
    @State private var showImageViewer = false
    @State private var showConfirm = false
        
    @ObservedObject var activity: Activity
    var colorSet: DayTime.ColorSet {
        Helpers.colorByTime(activity.time)
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            colorSet.main.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    dayAndTime
                    tags
                    note
                    
                    if activity.coordinate != nil {
                        map
                    }
                    
                    photoVideoList
                    
                    Spacer()
                }
                .padding()
            }
            editRemove.ignoresSafeArea()
        }
        .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
        .fullScreenCover(isPresented: $showEditScreen) {
            AddEditActivityScreen(activity: activity, isAdding: false, colorSet: colorSet, showAddEditScreen: $showEditScreen)
                .environment(\.managedObjectContext, context)
        }
        .overlay(
            ImageViewer(image: $selectedImage, viewerShown: $showImageViewer)
        )
        .showConfirm(shouldShow: showConfirm, message: Labels.removeActivity, cancelaction: { showConfirm = false }, confirmAction: {
            removeActivity()
            presentationMode.wrappedValue.dismiss()
        })
        .sheet(item: $selectedVideo) { video in
            VideoPlayer(player: AVPlayer(url: video.url!))
        }
    }
    
    var dayAndTime: some View {
        VStack(alignment: .leading) {
            Text.header(activity.time.weekDayMonthYearFormattedString)
            Text.header(activity.time.hourAndMinuteFormattedString)
        }
        .foregroundColor(colorSet.textColor)
    }
    
    @ViewBuilder
    var tags: some View {
        let sortedTags = activity.tags.sorted { $0.name.count > $1.name.count }
        VStack(alignment: .leading) {
            Text.regular("tags").foregroundColor(colorSet.textColor)
            FlowLayout(mode: .scrollable, items: sortedTags) { tag in
                Text(tag.name)
                    .foregroundColor(.black)
                    .padding(DrawingConstants.tagInnerPadding)
                    .buttonfity(mainColor: .white, shadowColor: .shadow, action: {
                        searchFilterData.tags = [tag]
                        appSetting.displayingTab = .search
                        presentationMode.wrappedValue.dismiss()
                    })
                    .padding(.trailing, DrawingConstants.tagTrailingPadding)
                    .padding(.bottom, DrawingConstants.tagVerticalPadding)
            }
        }
    }
    
    var note: some View {
        VStack(alignment: .leading) {
            Text.regular("note")
            
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .strokeBorder(style: StrokeStyle(lineWidth: DrawingConstants.noteBorderLineWidth, dash: [DrawingConstants.noteBorderDash]))
                
                Text.regular(activity.note)
                    .foregroundColor(Helpers.colorByTime(activity.time).textColor)
                    .padding(DrawingConstants.notePadding)
            }
        }
        .foregroundColor(colorSet.textColor)
    }
    
    var map: some View {
        HStack {
            Image(systemName: "mappin.circle.fill").font(.title3).foregroundColor(colorSet.shadow)
            Text.regular(Labels.location)
        }
        .padding()
        .buttonfity {
            appSetting.display(map: true)
            appSetting.displayingTab = .search
            appSetting.mapCenteredActivity = activity
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var photoVideoList: some View {
        PhotoVideoListView(photos: activity.photos, videos: activity.videos, colorSet: colorSet)
    }
    
    @ViewBuilder
    var editRemove: some View {
        ZStack {
            HStack {
                HStack {
                    edit
                    
                    Spacer()
                    
                    remove
                }
            }
            .padding(.bottom)
        }
        .foregroundColor(colorSet.textColor)
        .padding()
        .background(colorSet.shadow.clipped())
    }
    
    var edit: some View {
        Text.regular(Labels.edit)
            .foregroundColor(.blue)
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {
                showEditScreen = true
            })
    }
    
    var remove: some View {
        Text.regular(Labels.remove)
            .foregroundColor(.red)
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {
                showConfirm = true
            })
    }
    
    private func removeActivity() {
        Video.remove(urls: activity.videos.compactMap { $0.url })
        Activity.remove(activity, in: context)
    }
    
    struct DrawingConstants {
        static let noteBorderLineWidth: CGFloat = 2
        static let noteBorderDash: CGFloat = 10
        static let notePadding: CGFloat = 20
        static let tagInnerPadding: CGFloat = 8
        static let tagTrailingPadding: CGFloat = 2
        static let tagVerticalPadding: CGFloat = 5
        static let spaceBetweenEditRemove: CGFloat = 20
        static let photoAspectRatio: CGFloat = 1
        static let photoCornerRadius: CGFloat = 10
    }
}

struct DetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailScreen(activity: Activity())
    }
}
