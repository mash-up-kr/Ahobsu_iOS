//
//  AnswerComplete.swift
//  Ahobsu
//
//  Created by admin on 2019/11/23.
//  Copyright © 2019 ahobsu. All rights reserved.
//
import SwiftUI

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

struct AnswerCompleteView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var viewControllers: [UIHostingController<AnswerCompleteCardView>]
    
    var models: [Answer?]
    
    @State var currentPage = 0
    
    init(_ model: [Answer?]) {
        self.models = model
        
        self.viewControllers = model.map({
            let controller = UIHostingController(rootView: AnswerCompleteCardView(answer: $0))
            
            controller.view.backgroundColor = UIColor.clear
            
            return controller
        })
    }
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image("icArrowLeft")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
            }
        })
    }
    
    var body: some View {
        NavigationMaskingView(titleItem: Text(models[currentPage]?.date ?? "").font(.custom("IropkeBatangM", size: 24.0)),
                              trailingItem: EmptyView()) {
                                ZStack {
                                    BackgroundView()
                                        .edgesIgnoringSafeArea([.vertical])
                                    VStack {
                                        AnswerCompletePageControl(numberOfPages: viewControllers.count,
                                                                  currentPage: $currentPage)
                                            .padding(.bottom, 16.0)
                                        PageViewController(controllers: viewControllers, currentPage: $currentPage)
                                    }
                                }
        }
    }
}

struct AnswerCompleteView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        return Group {
            AnswerCompleteView(Answer.dummyCardView())
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
        }
    }
}
