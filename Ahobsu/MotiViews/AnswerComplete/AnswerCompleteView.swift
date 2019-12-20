//
//  AnswerComplete.swift
//  Ahobsu
//
//  Created by admin on 2019/11/23.
//  Copyright © 2019 ahobsu. All rights reserved.
//

import SwiftUI

enum AnswerMode {
    case essay
    case camera
    case essayCamera
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let ncv = uiViewController.navigationController {
            self.configure(ncv)
        }
    }
}

struct BackgroindView: View {
    var body: some View {
        VStack {
            LinearGradient(gradient: Gradient(
                colors: [Color(UIColor.init(red: 26/255, green: 22/255, blue: 22/255, alpha: 1.0)),
                     Color.black]),
               startPoint: .top,
               endPoint: .bottom
            )
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

struct AnswerCompleteView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var answerMode: AnswerMode
    @State var currentPage: Int

//    var contentView: some View {
//        switch answerMode {
//        case .essay:
//            return AnyView(AnswerComplete_Essay())
//        case .camera:
//            return AnyView(AnswerComplete_Camera())
//        case .essayCamera:
//            return AnyView(AnswerComplete_EssayCamera())
//        }
//    }

    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
            Image("icArrowLeft") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                BackgroindView()
                    .edgesIgnoringSafeArea([.vertical])
                ScrollView {
                    VStack {
                        PageControl(numberOfPages: 7,
                                    currentPage: $currentPage)
                            .padding(.bottom, 16.0)
                        HStack {
                            Text("해커톤이 끝났어요.\n지금 기분으로\n글을 써볼까요?")
                            .font(.custom("Baskerville", size: 24.0))
                            .foregroundColor(Color(UIColor.rosegold))
                            .lineSpacing(12.0)
                            Spacer()
                            Button(action: update) {
                                Image("icRewriteNormal")
                                    .renderingMode(.original)
                                    .frame(width: 48.0, height: 48.0)
                            }
                        }
                        .padding([.leading], 20.0)
                        .padding([.trailing], 4.0)
                        Spacer()
                    }
                }
        }.navigationBarItems(leading: btnBack)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(
            Text("2019. Nov. 21")
            .font(.custom("Baskerville", size: 24.0)), displayMode: .inline
        )
        }
    }

    func update() {

    }
}

struct AnswerCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AnswerCompleteView(answerMode: .essay, currentPage: 0)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max - Essay")

//            AnswerCompleteView(answerMode: .camera)
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
//                .previewDisplayName("iPhone 11 Pro Max - Camera")
//
//            AnswerCompleteView(answerMode: .essayCamera)
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
//                .previewDisplayName("iPhone 11 Pro Max - EssayCamera")
        }
    }
}
