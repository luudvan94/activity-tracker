//
//  DetailScreen.swift
//  Activity Tracker
//
//  Created by luu van on 11/11/21.
//

import SwiftUI
import SwiftUIFlowLayout
import CoreData

struct DetailScreen: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @State private var showEditScreen = false
    @ObservedObject var activity: Activity
    var colorSet: TimeColor.ColorSet {
        Helpers.colorByTime(activity.time)
    }
    
    var body: some View {
        ZStack {
            colorSet.main
            
            ScrollView {
                VStack(alignment: .leading) {
                    dayAndTime
                    tags
                    note
                    
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
    }
    
    var dayAndTime: some View {
        Group {
            Text.header(activity.time.weekDayMonthYearFormattedString)
            Text.header(activity.time.hourAndMinuteFormattedString)
        }
        .foregroundColor(colorSet.textColor)
    }
    
    @ViewBuilder
    var tags: some View {
        let sortedTags = activity.tags.sorted { $0.name.count > $1.name.count }
        FlowLayout(mode: .scrollable, items: sortedTags) { tag in
            Text(tag.name)
                .foregroundColor(.black)
                .padding(DrawingConstants.tagInnerPadding)
                .buttonfity(mainColor: .white, shadowColor: .shadow, action: {})
                .padding(.trailing, DrawingConstants.tagTrailingPadding)
                .padding(.vertical, DrawingConstants.tagVerticalPadding)
        }
    }
    
    var note: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .strokeBorder(style: StrokeStyle(lineWidth: DrawingConstants.noteBorderLineWidth, dash: [DrawingConstants.noteBorderDash]))
            
            Text.regular(activity.note)
                .foregroundColor(Helpers.colorByTime(activity.time).textColor)
                .padding(DrawingConstants.notePadding)
        }
        .padding(.vertical)
        .foregroundColor(colorSet.textColor)
    }
    
    var edit: some View {
        Text.regular("edit")
            .foregroundColor(.blue)
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {
                showEditScreen = true
            })
    }
    
    var remove: some View {
        Text.regular("remove")
            .foregroundColor(.red)
            .padding()
            .buttonfity(mainColor: .white, shadowColor: .shadow, action: {})
    }
    
    struct DrawingConstants {
        static let noteBorderLineWidth: CGFloat = 2
        static let noteBorderDash: CGFloat = 10
        static let notePadding: CGFloat = 20
        static let tagInnerPadding: CGFloat = 8
        static let tagTrailingPadding: CGFloat = 2
        static let tagVerticalPadding: CGFloat = 5
        static let spaceBetweenEditRemove: CGFloat = 20
    }
}

struct DetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailScreen(activity: Activity())
    }
}
