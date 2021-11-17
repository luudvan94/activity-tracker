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

struct DetailScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @State private var showEditScreen = false
    @State private var selectedImage: Image?
    @State private var showImageViewer = false
    @State private var showConfirm = false
    
    
    @ObservedObject var activity: Activity
    var colorSet: TimeColor.ColorSet {
        Helpers.colorByTime(activity.time)
    }
    
    var body: some View {
        ZStack {
            colorSet.main
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    dayAndTime
                    tags
                    note
                    photoList
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        edit
                        Spacer()
                        remove
                        Spacer()
                    }
                    .padding()
                }
                .padding()
            }
        }
        .ignoresSafeArea(.all, edges: Edge.Set.bottom)
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
                    .buttonfity(mainColor: .white, shadowColor: .shadow, action: {})
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
    
    @ViewBuilder
    var photoList: some View {
        if activity.photos.count > 0 {
            let columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 2)
            let images = activity.photos.compactMap { $0.image }
            VStack(alignment: .leading) {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(DrawingConstants.photoAspectRatio, contentMode: .fit)
                            .cornerRadius(DrawingConstants.photoCornerRadius)
                            .shadow(radius: 2)
                            .onTapGesture {
                                selectedImage = Image(uiImage: image)
                                showImageViewer = true
                            }
                    }
                }
            }
        } else {
            EmptyView()
        }
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
        DetailScreen(activity: Activity())
    }
}
