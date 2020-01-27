//
//  MyPageView.swift
//  Ahobsu
//
//  Created by JU HO YOON on 2020/01/26.
//  Copyright © 2020 ahobsu. All rights reserved.
//

import SwiftUI

struct MyPageView: View {

    @State var user: User = User.sampleData

    var body: some View {
        ScrollView {
            VStack {
                HeaderView(name: user.name)
                Separator()
                ListCell(title: "닉네임", detail: user.name)
                ListCell(title: "생년월일", detail: user.birthday)
                ListCell(title: "성별", detail: user.gender)
                Separator()
                ListCell(title: "버전정보", detail: "현재 0.0.0 / 최신 0.0.0")
                ListCell(title: "", detail: "문의하기")
                Spacer()
            }
        }
        .padding(.horizontal, 15)
        .navigationBarTitle("마이페이지", displayMode: .inline)
        .font(.system(size: 16))
        .background(BackgroundView())
        .navigationBarItems(trailing: NavigationLink(destination: MyPageEditView(user: $user)) {
            Image("icRewriteNormal").frame(width: 48, height: 48, alignment: .center)
        })
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}

extension MyPageView {

    struct HeaderView: View {
        var name: String
        var body: some View {
            VStack {
                Spacer(minLength: 20)
                Image("imgMypage")
                Spacer(minLength: 16)
                Text("\(name) 님")
                Spacer(minLength: 26)
            }.foregroundColor(Color(.rosegold))
        }
    }

    struct Separator: View {
        var body: some View {
            Rectangle()
                .frame(minHeight: 1, maxHeight: 1)
                .background(Color(.lightgold))
                .foregroundColor(Color(.rosegold))
        }
    }

    struct ListCell: View {
        var title: String
        var detail: String
        var body: some View {
            HStack {
                Text(title)
                Spacer()
                Text(detail)
            }.frame(minHeight: 52)
            .foregroundColor(Color(.rosegold))
        }
    }
}
