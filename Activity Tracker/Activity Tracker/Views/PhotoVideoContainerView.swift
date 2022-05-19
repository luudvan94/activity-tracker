//
//  PhotoVideoContainerView.swift
//  Activity Tracker
//
//  Created by Luu Van on 5/4/22.
//

import SwiftUI

struct PhotoVideoContainerView<ContentView>: View where ContentView: View {
	@Binding var shouldShow: Bool
	@ViewBuilder var content: () -> ContentView

	@State private var opacity = 1.0

	@State var dragOffset: CGSize = CGSize.zero
	@State var dragOffsetPredicted: CGSize = CGSize.zero

	var body: some View {
		ZStack {
			Color.black.ignoresSafeArea()

			VStack {
				ZStack {
					content()
				}
			}

			VStack {
				HStack {
                    cancel
					Spacer()
				}
				Spacer()
			}
			.padding()
		}
		.gesture(DragGesture()
			.onChanged { value in
				self.dragOffset = value.translation
				self.dragOffsetPredicted = value.predictedEndTranslation
			}
			.onEnded { value in
				if((abs(self.dragOffset.height) + abs(self.dragOffset.width) > 570) || ((abs(self.dragOffsetPredicted.height)) / (abs(self.dragOffset.height)) > 3) || ((abs(self.dragOffsetPredicted.width)) / (abs(self.dragOffset.width))) > 3) {
					withAnimation {
						self.opacity = 0
					}
					self.shouldShow = false

					return
				}
				withAnimation {
					self.dragOffset = .zero
					self.opacity = 1.0
				}
			}
		)
		.onAppear() {
			self.dragOffset = .zero
			self.dragOffsetPredicted = .zero
		}
		.opacity(opacity)
	}

	var cancel: some View {
		Button(action: {
			shouldShow = false
		}) {
			Image(systemName: "xmark")
				.foregroundColor(Color(UIColor.white))
				.font(.system(size: UIFontMetrics.default.scaledValue(for: 24)))
		}
	}
}
