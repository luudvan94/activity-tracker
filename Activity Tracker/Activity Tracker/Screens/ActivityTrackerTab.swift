//
//  ActivityTrackerTab.swift
//  Activity Tracker
//
//  Created by luu van on 11/10/21.
//

import SwiftUI
import CoreData

struct ActivityTrackerTab: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
    @State private var isAddingNew = false
    @State private var showAddNewActivityScreen = false
    @State private var showAddNewTagScreen = false
    @StateObject private var searchFilterData = SearchFilterData()
    @StateObject private var appSetting = AppSetting()
    
    var colorSet: TimeColor.ColorSet {
        appSetting.colorSet
    }
    
    var body: some View {
        GeometryReader { geometry in
            let bottomBarSize = sizeForButtonBar(in: geometry.size)
            
            ZStack(alignment: .bottom) {
                displayingScreen()
                
                if isAddingNew {
                    Color.white.opacity(0.8).ignoresSafeArea()
                        .transition(.asymmetric(insertion: .opacity, removal: .opacity))
                        .onTapGesture {
                            withAnimation(.linear(duration: 0.2)) {
                                isAddingNew = false
                            }
                        }
                }
                
                bottomBar
                    .frame(width: bottomBarSize.width, height: bottomBarSize.height)
                    .background(Color.white)
                    .clipShape(bottomBarRoundedShape)
                    .overlay(bottomBarRoundedShape.stroke(colorSet.main, lineWidth: DrawingConstants.bottomBarBorderWidth))
                    .overlay(AddNewView().offset(y: -(4*bottomBarSize.height/5)))
                    .ignoresSafeArea()
            }
            .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
            .fullScreenCover(isPresented: $showAddNewActivityScreen) {
                AddEditActivityScreen(activity: Activity(context: context), isAdding: true, colorSet: colorSet, showAddEditScreen: $showAddNewActivityScreen)
                    .environment(\.managedObjectContext, context)
            }
            .fullScreenCover(isPresented: $showAddNewTagScreen) {
                AddTagScreen(colorSet: colorSet, showAddTagScreen: $showAddNewTagScreen)
                    .environment(\.managedObjectContext, context)
            }
            .onAppear {
                appSetting.colorSet = Helpers.colorByTime()
            }
            .environmentObject(searchFilterData)
            .environmentObject(appSetting)
        }
    }
    
    @ViewBuilder
    func displayingScreen() -> some View {
        switch appSetting.displayingTab {
        case .home: HomeScreen()
        case .search: SearchScreen()
        default: EmptyView()
        }
    }
    
    var bottomBar: some View {
        HStack {
            Spacer()
            homeItem.onTapGesture {
                appSetting.selectTab(.home)
            }
            .foregroundColor(appSetting.displayingTab == AppSetting.Tab.home ? appSetting.colorSet.main : .black )
            Spacer()
            Spacer()
            searchItem.onTapGesture {
                appSetting.selectTab(.search)
            }
            .foregroundColor(appSetting.displayingTab == AppSetting.Tab.search ? appSetting.colorSet.main : .black)
            Spacer()
        }
        .font(.title)
        .padding(.horizontal, 20)
    }
    
    var homeItem: some View {
        Image(systemName: "house.fill")
    }
    
    var searchItem: some View {
        Image(systemName: "magnifyingglass.circle.fill")
    }
    
//    var userItem: some View {
//        Image(systemName: "person.fill")
//    }
    
    var bottomBarRoundedShape: some Shape {
        RoundedCorner(radius: DrawingConstants.bottomBarCornerRadius, corners: [.topLeft, .topRight])
    }
    
    private func sizeForButtonBar(in size: CGSize) -> CGSize {
        CGSize(
            width: size.width,
            height: size.height * DrawingConstants.bottomBarHeightPropotion
        )
    }
    
    @ViewBuilder
    private func AddNewView() -> some View {
        AddNewButtonView(isAdding: $isAddingNew, colorSet: colorSet, onTap: {
            withAnimation(.linear(duration: DrawingConstants.addNewButtonAnimationDuration)) {
                isAddingNew.toggle()
            }
        })
            .scaleEffect(DrawingConstants.addNewButtonScale)
            .overlay(
                HStack(spacing: 50) {
                    newTag
                    newActivity
                }
                    .offset(y: DrawingConstants.addNewButtonOffsetY)
                    .opacity(isAddingNew ? 1 : 0)
            )
    }
    
    var newActivity: some View {
        Button(action: {
            withAnimation {
                showAddNewActivityScreen = true
                isAddingNew = false
            }
        }) {
            Image(systemName: "figure.walk").foregroundColor(colorSet.shadow).font(.largeTitle)
        }
    }
    
    var newTag: some View {
        Button(action: {
            withAnimation {
                showAddNewTagScreen = true
                isAddingNew = false
            }
        }) {
            Image(systemName: "tag.fill").foregroundColor(colorSet.shadow).font(.largeTitle)
        }
    }
    
    struct DrawingConstants {
        static let bottomBarHeightPropotion: CGFloat = 1/10
        static let bottomBarCornerRadius: CGFloat = 40
        static let bottomBarShadowRadius: CGFloat = 5
        static let bottomBarBorderWidth: CGFloat = 5
        static let addNewButtonScale: CGFloat = 0.9
        static let addNewButtonOffsetY: CGFloat = -100
        static let addNewButtonAnimationDuration: CGFloat = 0.2
    }
}

struct ActivityTrackerTab_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTrackerTab()
    }
}
