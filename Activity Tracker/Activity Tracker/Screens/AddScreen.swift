//
//  AddScreen.swift
//  Activity Tracker
//
//  Created by luu van on 2/24/22.
//

import SwiftUI
import CoreData

struct AddScreen: View {
    @EnvironmentObject var appSetting: AppSetting
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @State private var showAddNewActivityScreen = false
    @State private var showAddNewTagScreen = false
    @State private var showAddNewTripScreen = false
    
    var body: some View {
        ZStack {
            background
            
            VStack(alignment: .leading) {
                title.padding([.top, .horizontal])
                
                RoundedBorderContainerView {
                    addMenu
                }.padding()
            }
        }
        .fullScreenCover(isPresented: $showAddNewActivityScreen) {
            AddEditActivityScreen(activity: Activity(context: context), isAdding: true, colorSet: colorSet, showAddEditScreen: $showAddNewActivityScreen)
                .environment(\.managedObjectContext, context)
        }
        .fullScreenCover(isPresented: $showAddNewTagScreen) {
            AddTagScreen(colorSet: colorSet)
                .environment(\.managedObjectContext, context)
        }
        .fullScreenCover(isPresented: $showAddNewTripScreen) {
            AddTripScreen(colorSet: colorSet, showAddTripScreen: $showAddNewTripScreen)
                .environment(\.managedObjectContext, context)
        }
    }
    
    var colorSet: DayTime.ColorSet {
        appSetting.colorSet
    }
    
    var background: some View {
        colorSet.main.ignoresSafeArea()
    }
    
    var title: some View {
        Text.header(Labels.addNew).foregroundColor(colorSet.textColor)
    }
    
    var addMenu: some View {
        VStack(spacing: 20) {
            newActivity
            newTrip
            
            HStack(spacing: 10) {
                newTag
            }
        }
    }
    
    func newMenu(title: String, colorSet: DayTime.ColorSet, action: @escaping () -> Void) -> some View {
        ZStack {
            Color.clear
            Text.header(title)
                .foregroundColor(colorSet.textColor)
                .padding(.vertical)
        }
        .padding()
        .buttonfity(mainColor: colorSet.main, shadowColor: colorSet.shadow, action: action)
    }
    
    var newActivity: some View {
        MenuView(content: {
            HStack {
                Image(systemName: "figure.walk.diamond.fill")
                    .foregroundColor(DayTime.night.colors.shadow).font(.largeTitle)
                Text.header("activity")
                    .foregroundColor(DayTime.dayLight.colors.textColor)
            }.padding()
        }, colorSet: DayTime.dayLight.colors, action: {
            showAddNewActivityScreen = true
        })
    }
    
    var newTrip: some View {
        MenuView(content: {
            HStack {
                Image(systemName: "airplane")
                    .foregroundColor(DayTime.dayLight.colors.shadow).font(.largeTitle)
                Text.header("trip")
                    .foregroundColor(DayTime.night.colors.textColor)
            }.padding()
        }, colorSet: DayTime.night.colors, action: {
            showAddNewTripScreen = true
        })
    }
    
    var newTag: some View {
        MenuView(content: {
            VStack {
                Image(systemName: "tag.fill")
                    .foregroundColor(DayTime.night.colors.shadow).font(.largeTitle)
                Text.header("tag")
                    .foregroundColor(DayTime.noon.colors.textColor)
            }.padding()
        }, colorSet: DayTime.noon.colors, action: {
            showAddNewTagScreen = true
        })
    }
    
}

struct AddScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddScreen()
    }
}
