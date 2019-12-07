//
//  SwiftUIPagerView.swift
//  Ahobsu
//
//  Created by 이호찬 on 2019/12/20.
//  Copyright © 2019 ahobsu. All rights reserved.
//

import SwiftUI

struct SwiftUIPagerView<Content: View & Identifiable>: View {

    @Binding var index: Int
    @State private var offset: CGFloat = 0
    @State private var isGestureActive: Bool = false

    // 1
    var pages: [Content]

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: -20) {
                    ForEach(self.pages) { page in
                        page
                            .frame(width: geometry.size.width - 60, height: nil)
                    }
                }
            }
            // 2
            .content.offset(x: self.isGestureActive ? self.offset : -(geometry.size.width - 80) * CGFloat(self.index))
            // 3
            .frame(width: geometry.size.width, height: nil, alignment: .leading)
            .gesture(DragGesture().onChanged({ value in
                // 4
                self.isGestureActive = true
                // 5
                self.offset = value.translation.width + -(geometry.size.width - 80) * CGFloat(self.index)
            }).onEnded({ value in
                if -value.predictedEndTranslation.width > (geometry.size.width - 80) / 2, self.index < self.pages.endIndex - 1 {
                    self.index += 1
                }
                if value.predictedEndTranslation.width > (geometry.size.width - 80) / 2, self.index > 0 {
                    self.index -= 1
                }
                // 6
                withAnimation(.easeOut(duration: 0.2)) { self.offset = -(geometry.size.width - 80) * CGFloat(self.index) }

                // 7
                DispatchQueue.main.async { self.isGestureActive = false }
            }))
            .padding([.leading], 60)
        }
    }
}