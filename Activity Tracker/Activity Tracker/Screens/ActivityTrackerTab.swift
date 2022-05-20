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
    @Environment(\.scenePhase) var scenePhase
    
    @State private var isAddingNew = false
    @StateObject private var searchFilterData = SearchFilterData()
    @StateObject private var appSetting = AppSetting()
    @StateObject private var locationManager = LocationManager()
    
    var colorSet: DayTime.ColorSet {
        appSetting.colorSet
    }
    
    var body: some View {
        GeometryReader { geometry in
            let bottomBarSize = sizeForButtonBar(in: geometry.size)
            
            ZStack(alignment: .bottom) {
                displayingScreen()
                
                bottomBar
                    .frame(width: bottomBarSize.width, height: bottomBarSize.height)
                    .background(Color.white)
                    .clipShape(bottomBarRoundedShape)
                    .overlay(bottomBarRoundedShape.stroke(colorSet.main, lineWidth: DrawingConstants.bottomBarBorderWidth))
                    .overlay(AddNewView().offset(y: -(4*bottomBarSize.height/5)))
                    .ignoresSafeArea()
            }
            .ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
            .environmentObject(searchFilterData)
            .environmentObject(appSetting)
            .environmentObject(locationManager)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    appSetting.colorSet = Helpers.colorByTime()
                }
            }
            .fullScreenCover(isPresented: $isAddingNew) {
                AddEditActivityScreen(activity: Activity(context: context), isAdding: true, colorSet: colorSet, showAddEditScreen: $isAddingNew)
                    .environment(\.managedObjectContext, context)
                    .environmentObject(locationManager)
                    .environmentObject(appSetting)
            }
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
    
    @ViewBuilder
    private func AddNewView() -> some View {
        AddNewButtonView(colorSet: colorSet, onTap: {
            withAnimation(.linear(duration: 0.2)) {
                isAddingNew.toggle()
            }
        })
    }
    
    var bottomBar: some View {
        HStack {
            Spacer()
            homeItem.onTapGesture {
                appSetting.selectTab(.home)
            }
            .foregroundColor(appSetting.displayingTab == AppSetting.Tab.home ? appSetting.colorSet.shadow : .black )
            Spacer()
            Spacer()
            searchItem.onTapGesture {
                appSetting.selectTab(.search)
            }
            .foregroundColor(appSetting.displayingTab == AppSetting.Tab.search ? appSetting.colorSet.shadow : .black)
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
    
    var addItem: some View {
        Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
    }
    
    var bottomBarRoundedShape: some Shape {
        RoundedCorner(radius: DrawingConstants.bottomBarCornerRadius, corners: [.topLeft, .topRight])
    }
    
    private func sizeForButtonBar(in size: CGSize) -> CGSize {
        CGSize(
            width: size.width,
            height: size.height * DrawingConstants.bottomBarHeightPropotion
        )
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
