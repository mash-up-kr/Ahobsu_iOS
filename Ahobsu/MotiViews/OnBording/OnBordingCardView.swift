//
//  OnBordingCardView.swift
//  Ahobsu
//
//  Created by 한종호 on 29/01/2020.
//  Copyright © 2020 ahobsu. All rights reserved.
//

import SwiftUI

struct OnBordingCardView: View {
    
    @State var onBordingModel: OnBordingModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            Text(onBordingModel.headline)
                .font(.custom("IropkeBatangM", size: 20.0))
                .lineSpacing(16.0)
                .multilineTextAlignment(.center)
            Text(onBordingModel.detail)
                .font(.custom("IropkeBatangM", size: 12.0))
                .lineSpacing(8.0)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
            Image(onBordingModel.imageName)
                .padding(.top, 16.0)
                .padding(.horizontal, 20.0)
        }
    }
}

struct OnBordingCardView_Previews: PreviewProvider {
    static var previews: some View {
        let models: [OnBordingModel] = OnBordingModel.createOnBordingModel()
        
        return Group {
            ForEach(models, id: \.self) { model in
                OnBordingCardView(onBordingModel: model)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                    .previewDisplayName("iPhone 8")
            }
        }
    }
}
