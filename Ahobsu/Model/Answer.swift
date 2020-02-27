//
//  Answer.swift
//  Ahobsu
//
//  Created by 김선재 on 01/02/2020.
//  Copyright © 2020 ahobsu. All rights reserved.
//

import Foundation

struct Answer: Decodable, Identifiable {
    let id: Int
    let userId: Int
    let missionId: Int
    let imageUrl: String?
    let cardUrl: String?
    var content: String?
    let date: String
    let setDate: String
    let mission: Mission
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case missionId
        case imageUrl
        case cardUrl
        case content
        case date
        case setDate
        case mission
    }
}

extension Answer: Hashable {
    static func == (lhs: Answer, rhs: Answer) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Answer {
    enum AnswerType {
        case essay
        case camera
        case essayCamera
    }
    
    func getAnswerType() -> AnswerType {
        if imageUrl == nil {
            return .essay
        } else {
            if mission.isContent {
                return .essayCamera
            } else {
                return .camera
            }
        }
    }
}

extension Answer {
    func isTodayAnswer() -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let todayStr = formatter.string(from: Date())
        
        return self.date == todayStr
    }
}

extension Answer {
    static func dummyCardView() -> [Answer] {
        var answersData: [Answer] = []
        
        for idx in 0...6 {
            answersData.append(
                Answer(id: idx,
                       userId: 0,
                       missionId: 0,
                       imageUrl: "https://wallpapershome.com/images/pages/pic_h/11603.jpg",
                       cardUrl: "",
                       content: "Hello",
                       date: "2020-02-01",
                       setDate: "2020-02-01",
                       mission: Mission(id: 0, title: "더미 질문", isContent: true, isImage: true))
            )
        }
        
        return answersData
    }
}
