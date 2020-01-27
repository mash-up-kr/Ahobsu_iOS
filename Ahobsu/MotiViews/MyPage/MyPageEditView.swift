//
//  MyPageEditView.swift
//  Ahobsu
//
//  Created by JU HO YOON on 2020/01/27.
//  Copyright © 2020 ahobsu. All rights reserved.
//

import SwiftUI
import Combine

struct MyPageEditView: View {

    @Binding var user: User
    @ObservedObject var myPageEdit = MyPageEdit()

    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 30)
                MyPageView.Separator()
                ListCell(title: "닉네임", detail: user.name)
                MyPageView.Separator().opacity(0.5)
                ListCell(title: "생년월일", detail: user.birthday)
                MyPageView.Separator().opacity(0.5)
                ListCell(title: "성별", detail: user.gender)
                MyPageView.Separator()
                ListCell(title: "", detail: "로그아웃")
                Button(action: {
                    self.myPageEdit.deleteUser()
                }, label: {
                    ListCell(title: "", detail: "탈퇴하기").opacity(0.5)
                })
            }
        }
        .padding(.horizontal, 15)
        .navigationBarTitle("수정하기").onReceive(myPageEdit.$deletingUserSucccess) { (success) in
            if success {
                self.navigateRootView()
            }
        }
    }
}

// Helper
extension MyPageEditView {
    private func navigateRootView() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
            let window = sceneDelegate.window {
            window.rootViewController = UIHostingController(rootView: SignInView(window: window))
            UIView.transition(with: window,
                              duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}

struct MyPageEditView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageEditView(user: .constant(.sampleData))
    }
}

extension MyPageEditView {
    struct ListCell: View {
        var title: String
        var detail: String
        var body: some View {
            HStack {
                Text(title)
                Spacer()
                Text(detail)
                if title.isEmpty == false {
                    Spacer()
                }
            }.frame(minHeight: 52)
            .foregroundColor(Color(.rosegold))
        }
    }
}
