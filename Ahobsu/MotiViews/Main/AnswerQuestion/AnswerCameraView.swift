//
//  AnswerInsertCameraView.swift
//  Ahobsu
//
//  Created by 이호찬 on 2019/12/21.
//  Copyright © 2019 ahobsu. All rights reserved.
//

import SwiftUI

struct AnswerCameraView: View {
    
    @State var showCamera: Bool = false
    @State var showImagePicker: Bool = false
    @State var showImageSourcePicker: Bool = false
    @State var image: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    @State var showEssayCameraView: Bool = false
    
    @Binding var isStatusBarHidden: Bool
    @ObservedObject var keyboard: Keyboard = Keyboard()
    @State var text = ""

    
    var missonData: Mission
    @State var isNetworking: Bool = false
    @State var answerRegisteredActive: Bool = false
    
    var body: some View {
        ZStack {
            NavigationMaskingView(titleItem: Text("답변하기"), trailingItem: EmptyView()) {
                        ZStack {
                            BackgroundView()
                                .edgesIgnoringSafeArea([.vertical])
                            VStack {
                                HStack {
                                    Text(missonData.title)
                                        .font(.system(size: 24))
                                        .lineSpacing(6)
                                        .foregroundColor(Color(.rosegold))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                Spacer()
                                if image != nil {
                                    if missonData.isContent {
            //                            ZStack {
                                            MainCardView(isWithLine: true)
                                                .overlay(
                                                    VStack {
                                                        Image(uiImage: image ?? UIImage())
                                                            .resizable()
                                                            .aspectRatio(1, contentMode: .fill)
                                                            .cornerRadius(6)
                                                        
                                                        ZStack {
                                                            if text == "" && keyboard.state.height == 0 {
                                                                VStack {
                                                                    Text("여기를 눌러 질문에 대한\n답을 적어주세요.")
                                                                        .foregroundColor(Color(.placeholderblack))
                                                                        .multilineTextAlignment(.center)
                                                                        .padding(EdgeInsets(top: (keyboard.state.height == 0 ? 30 : -270 + keyboard.state.height),
                                                                                            leading: 0,
                                                                                            bottom: 32,
                                                                                            trailing: 0))
            //                                                        Spacer()
                                                                }
                                                            }
                                                            TextView(text: $text)
                                                                .padding(EdgeInsets(top: (keyboard.state.height == 0 ? 30 : -270 + keyboard.state.height),
                                                                                    leading: 0,
                                                                                    bottom: 32,
                                                                                    trailing: 0))
                                                        }
                                                        Spacer()
                                                    }
                                                    .padding(.horizontal, 34)
                                                    .padding(.vertical, 22)
                                            )
                                                .padding(32)
                                    } else {
                                        MainCardView(isWithLine: true)
                                        .overlay(Image(uiImage: image!)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .padding(.horizontal, 34)
                                            .padding(.vertical, 22)
                                        )
                                        .padding(32)
                                    }
                                } else {
                                    Image("imgCam")
                                }
                                Spacer()
                                HStack {
                                    if self.image == nil {
                                        MainButton(action: {
                                            if self.image == nil {
                                                self.showImageSourcePicker = true
                                            } else {
                                                self.registerCameraAnswer()
                                            }},
                                                   title: image == nil ? "촬영하기" : "제출하기")
                                            
                                            .environment(\.isEnabled, !isNetworking)
                                            .actionSheet(isPresented: $showImageSourcePicker) {
                                                ActionSheet(title: Text("사진으로 답변"),
                                                            message: nil,
                                                            buttons: [.default(Text("카메라로 촬영하기"),
                                                                               action: {
                                                                                self.isStatusBarHidden = true
                                                                                self.showCamera = true
                                                            }),
                                                                      .default(Text("앨범에서 가져오기"),
                                                                               action: {
                                                                                self.sourceType = .photoLibrary
                                                                                self.showImagePicker = true
                                                                      }),
                                                                      .cancel()])
                                        }
                                        .sheet(isPresented: self.$showImagePicker,
                                               onDismiss: {
                                                DispatchQueue.main.async {
                                                    self.showEssayCameraView = true
                                                }
                                                // print(self.image ?? UIImage())
                                        },
                                               content: {
                                                ImagePicker(showCamera: self.$showCamera,
                                                            image: self.$image,
                                                            isStatusBarHidden: .constant(false),
                                                            sourceType: self.sourceType) }
                                        )
                                    } else {
                                        NavigationLink(destination: AnswerRegisteredView(),
                                                       isActive: $answerRegisteredActive)
                                        {
                                            MainButton(action: { self.registerCameraAnswer() },
                                                       title: "제출하기")
                                        }
                                    }
                                    
                                }
                                Spacer(minLength: 32)
                            }
                            .padding([.horizontal], 20)
                            .offset(x: 0, y: keyboard.state.height == 0 ? keyboard.state.height : -keyboard.state.height)
                                    .edgesIgnoringSafeArea((keyboard.state.height > 0) ? [.bottom] : [])
                                    .animation(.easeOut(duration: keyboard.state.animationDuration))
                        }
                        .onTapGesture {
                            self.endEditing()
                        }
                    }
            ZStack {
                ImagePicker(showCamera: $showCamera,
                            image: self.$image,
                            isStatusBarHidden: self.$isStatusBarHidden,
                            sourceType: self.sourceType)
                    .offset(x: 0, y: showCamera ? 0 : UIScreen.main.bounds.height).animation(.easeInOut)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}

extension AnswerCameraView {
    func registerCameraAnswer() {
        guard let image = image else { return }
        self.isNetworking = true
        
        let content: String? = missonData.isContent ? text : nil
        AhobsuProvider.registerAnswer(missionId: missonData.id,
                                      contentOrNil: content,
                                      imageOrNil: image,
                                      completion: { (response) in
                                        self.isNetworking = false
                                        if let _ = response?.data {
                                            self.answerRegisteredActive = true
                                        }},
                                      error: { (error) in
                                        self.isNetworking = false },
                                      expireTokenAction: {
                                        self.isNetworking = false },
                                      filteredStatusCode: nil)
    }
}

//struct AnswerCameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnswerCameraView(missonData: Mission(id: 1, title: "", isContent: true, isImage: true))
//    }
//}
