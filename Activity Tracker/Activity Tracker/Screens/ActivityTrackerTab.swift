//
//  ActivityTrackerTab.swift
//  Activity Tracker
//
//  Created by luu van on 11/10/21.
//

import SwiftUI

struct ActivityTrackerTab: View {
    @State private var selectedTab = Tab.home
    @State private var isAddingNew = false
    let colorSet = Helpers.colorByTime()
    
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
            }.ignoresSafeArea(SafeAreaRegions.all, edges: Edge.Set.bottom)
        }
    }
    
    @ViewBuilder
    func displayingScreen() -> some View {
        switch selectedTab {
        case .home: HomeScreen(colorSet: Helpers.colorByTime())
        case .search: SearchScreen()
        default: EmptyView()
        }
    }
    
    var bottomBar: some View {
        HStack {
            homeItem.onTapGesture {
                if selectedTab != Tab.home {
                    selectedTab = .home
                }
            }
            .foregroundColor(selectedTab == Tab.home ? colorSet.main : Color.black)
            Spacer()
            searchItem.onTapGesture {
                if selectedTab != Tab.search {
                    selectedTab = .search
                }
            }
            .foregroundColor(selectedTab == Tab.search ? colorSet.main : Color.black)
            Spacer()
            userItem
        }
        .font(.title)
        .padding(.horizontal, 20)
    }
    
    var homeItem: some View {
        Image(systemName: "house.fill")
    }
    
    var searchItem: some View {
        Image(systemName: "magnifyingglass")
    }
    
    var userItem: some View {
        Image(systemName: "person.fill")
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
    
    @ViewBuilder
    private func AddNewView() -> some View {
        AddNewButtonView(isAdding: $isAddingNew, colorSet: colorSet, onTap: {
            withAnimation(.linear(duration: 0.2)) {
                isAddingNew.toggle()
            }
        })
            .overlay(
                HStack(spacing: 50) {
                    newTag
                    newActivity
                }
                    .offset(y: -100)
                    .opacity(isAddingNew ? 1 : 0)
            )
    }
    
    var newActivity: some View {
        Button(action: {}) {
            Image(systemName: "figure.walk").foregroundColor(colorSet.main).font(.largeTitle)
        }
    }
    
    var newTag: some View {
        Button(action: {}) {
            Image(systemName: "tag.fill").foregroundColor(colorSet.main).font(.largeTitle)
        }
    }
    
    struct DrawingConstants {
        static let bottomBarHeightPropotion: CGFloat = 1/10
        static let bottomBarCornerRadius: CGFloat = 40
        static let bottomBarShadowRadius: CGFloat = 5
        static let bottomBarBorderWidth: CGFloat = 5
    }
    
    enum Tab {
        case home
        case search
        case user
    }
}

struct ActivityTrackerTab_Previews: PreviewProvider {
    static var previews: some View {
        ActivityTrackerTab()
    }
}
