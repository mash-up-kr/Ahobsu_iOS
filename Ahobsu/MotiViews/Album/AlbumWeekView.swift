//
//  AlbumWeekView.swift
//  Ahobsu
//
//  Created by 김선재 on 13/02/2020.
//  Copyright © 2020 ahobsu. All rights reserved.
//

import SwiftUI

struct AlbumWeekView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var answers: [Answer?]
    @State var navigationTitle: String
    @State var weekNumber: Int
    
    var body: some View {
        NavigationMaskingView(titleItem: Text(navigationTitle),
                              trailingItem: EmptyView()) {
            DayWeekView(isFills: answers.map { $0 != nil })
                .frame(height: 72, alignment: .center)
            ZStack {
                NavigationLink(destination: AnswerCompleteView(answers)) {
                    MainCardView(isWithLine: true)
                        .aspectRatio(257.0 / 439.0, contentMode: .fit)
                        .padding([.horizontal], 59)
                        .overlay(
                            ZStack {
                                ForEach(answers.compactMap { $0?.file.cardUrl },
                                        id: \.self,
                                        content: { (cardUrl) in
                                            
                                            ImageView(withURL: cardUrl)
                                                .aspectRatio(257.0 / 439.0, contentMode: .fit)
                                                .padding(10)
                                })
                            }
                    )
                }
            }.frame(maxHeight: .infinity)
        }
        .background(BackgroundView().edgesIgnoringSafeArea(.vertical))
    }
}
