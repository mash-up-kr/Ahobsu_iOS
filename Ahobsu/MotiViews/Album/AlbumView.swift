//
//  AlbumView.swift
//  Ahobsu
//
//  Created by 김선재 on 28/01/2020.
//  Copyright © 2020 ahobsu. All rights reserved.
//

import SwiftUI

extension String {
    static func toAlbumDateString(from date: Date) -> String {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        let monthEnum = MonthEnum(month: month)
        let returnStr = "\(year). \(monthEnum.longMonthString())"
        
        return returnStr
    }
    
    static func toAlbumDateString(year: Int, month: Int) -> String {
        let monthEnum = MonthEnum(month: month)
        let returnStr = "\(year). \(monthEnum.longMonthString())"
        
        return returnStr
    }
}

struct AlbumView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var answerMonth: AnswerMonth?
    
    @State private var currentYear: Int = 0
    @State private var currentMonth: Int = 0
    
    @State private var isReloadNeeded: Bool = false
    
    func loadAlbums() {
        AhobsuProvider.getAnswersMonth(year: self.currentYear,
                                       month: self.currentMonth,
                                       completion: { (wrapper) in
                                        if let answerMonth = wrapper?.data {
                                            withAnimation(.easeIn(duration: 0.5)) {
                                                self.answerMonth = answerMonth
                                            }
                                        }
                                        
                                        self.isReloadNeeded = false
        }, error: { (error) in
            self.isReloadNeeded = true
        }, expireTokenAction: {
            
        }, filteredStatusCode: nil)
    }
    
    func loadAlbumAction() {
        let calendar = Calendar.current
        let date = Date()
        
        self.currentYear = calendar.component(.year, from: date)
        self.currentMonth = calendar.component(.month, from: date)
        
        self.loadAlbums()
    }

    var body: some View {
        NavigationMaskingView(titleItem: Text("앨범"), trailingItem: EmptyView()) {
            VStack(spacing: 0.0) {
                if isReloadNeeded == false {
                    AlbumList(answerMonth: answerMonth,
                              month: currentMonth)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding([.leading, .trailing], 15.0)
                        .padding(.top, 30.0)
                    PaginationView(loadAlbumsDelegate: { self.loadAlbums() }, year: $currentYear, month: $currentMonth)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 88.0)
                } else {
                    NetworkErrorView {
                        self.loadAlbumAction()
                    }
                }
            }
        }
        .background(BackgroundView().edgesIgnoringSafeArea(.vertical))
        .onAppear {
            self.loadAlbumAction()
        }
    }
}

struct AlbumList: View {
    
    var answerMonth: AnswerMonth?
    var month: Int
    
    var body: some View {
        VStack {
            if answerMonth != nil {
                ScrollView {
                    GridStack(rows: Int(Double(self.answerMonth!.monthAnswer.count) / 2.0 + 0.5), columns: 2) { (row, column) in
                        if row * 2 + column + 1 <= self.answerMonth!.monthAnswer.count {
                            PartsCombinedAnswer(answers: self.answerMonth!.monthAnswer[row * 2 + column],
                                                week: row * 2 + column + 1,
                                                month: self.month)
                        } else {
                            Text("")
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }
                    }
                }
            } else {
                AnswerEmptyView()
            }
        }
    }
}

struct AnswerEmptyView: View {
    
    var imageName: String { "icEmpty" }
    var imagePaddingBottom: CGFloat { 16.0 }
    
    var sublineText: String { "이달에는 수집된 카드가 없습니다." }
    var sublineTextFont: Font { Font.custom("IropkeBatangOTFM", size: 14.0) }
    var sublineLineSpacing: CGFloat { 6.0 }
    
    var body: some View {
        VStack {
            Spacer()
            Image("icEmpty")
                .padding(.bottom, imagePaddingBottom)
            Text(sublineText)
                .font(sublineTextFont)
                .lineSpacing(sublineLineSpacing)
                .foregroundColor(Color(UIColor.rosegold))
            Spacer()
        }
    }
}

struct PartsCombinedAnswer: View {
    
    var answers: [Answer?]? = nil
    var week: Int = 0
    var title: String = ""
    var shortMonth: String = ""
    
    var number: Int = 0
    
    init(answers: [Answer?]?, week: Int, month: Int) {
        self.answers = answers
        self.week = week
        
        if week == 1 {
            title = "1st week"
        } else if week == 2 {
            title = "2nd week"
        } else if week == 3 {
            title = "3rd week"
        } else {
            title = "\(week)th week"
        }
        
        shortMonth = MonthEnum(month: month).rawValue
    }
    
    init(answers: [Answer?]?, no: Int) {
        self.answers = answers
        self.number = no
        
        title = "No.\(self.number)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            HStack(alignment: .center) {
                Rectangle().fill(Color(.rosegold))
                    .frame(height: 1.0)
                Text(title).font(.custom("IropkeBatangOTFM", size: 16.0))
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                Rectangle().fill(Color(.rosegold))
                    .frame(height: 1.0)
            }
            NavigationLink(destination: AlbumWeekView(answers: answers ?? [nil], navigationTitle: "\(shortMonth). \(title)", weekNumber: week))
            {
                ZStack {
                    if answers != nil {
                        ForEach(self.answers!.compactMap { $0?.file.cardUrl },
                                id: \.self,
                                content: { (cardUrl) in
                                    ImageView(withURL: cardUrl)
                                        .aspectRatio(0.62, contentMode: .fit)
                                        .padding(20)
                        })
                    }
                }.frame(height: 273.0)
            }.buttonStyle(PlainButtonStyle())
        }
    }
    
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
    
    var body: some View {
        VStack {
            ForEach(0 ..< rows) { row in
                HStack(spacing: 25.0) {
                    ForEach(0 ..< self.columns) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}

struct PaginationView: View {
    
    var loadAlbumsDelegate: () -> Void
    
    @Binding var year: Int
    @Binding var month: Int
    
    var body: some View {
        VStack(spacing: 0.0) {
            HStack(alignment: .center, spacing: 8.0) {
                Button(action: {
                    /* 뒤로 가기 */
                    if self.month == 1 {
                        self.month = 12
                        self.year -= 1
                    } else {
                        self.month -= 1
                    }
                    
                    self.loadAlbumsDelegate()
                }, label: {
                    Image("icArrowLeft")
                        .renderingMode(.original)
                })
                    .frame(width: 48.0, height: 48.0)
                Text(String.toAlbumDateString(year: year, month: month))
                    .lineSpacing(16.0).lineLimit(1)
                    .font(.custom("IropkeBatangOTFM", size: 20.0))
                    .frame(width: 160.0)
                Button(action: {
                    /* 앞으로 가기 */
                    if self.month == 12 {
                        self.month = 1
                        self.year += 1
                    } else {
                        self.month += 1
                    }
                    
                    self.loadAlbumsDelegate()
                }, label: {
                    Image("icArrowRight")
                        .renderingMode(.original)
                })
                    .frame(width: 48.0, height: 48.0)
            }
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 87.0)
            .background(Color.black)
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView()
    }
}
