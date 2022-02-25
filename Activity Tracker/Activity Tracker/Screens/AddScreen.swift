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
            AddTagScreen(colorSet: colorSet, showAddTagScreen: $showAddNewTagScreen)
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
        Text.header("Add new")
    }
    
    var addMenu: some View {
        VStack(spacing: 20) {
            newActivity
            newGroup
            
            HStack(spacing: 10) {
                newTag
                newSet
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
    
    var newGroup: some View {
        MenuView(content: {
            HStack {
                Image(systemName: "rectangle.3.group.fill")
                    .foregroundColor(DayTime.dayLight.colors.shadow).font(.largeTitle)
                Text.header("group")
                    .foregroundColor(DayTime.night.colors.textColor)
            }.padding()
        }, colorSet: DayTime.night.colors, action: {})
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
    
    var newSet: some View {
        MenuView(content: {
            VStack {
                Image(systemName: "rectangle.tophalf.inset.filled")
                    .foregroundColor(DayTime.sunset.colors.shadow).font(.largeTitle)
                Text.header("set")
                    .foregroundColor(DayTime.sunrise.colors.textColor)
            }.padding()
        }, colorSet: DayTime.sunrise.colors, action: {})
    }
    
}

struct AddScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddScreen()
    }
}
