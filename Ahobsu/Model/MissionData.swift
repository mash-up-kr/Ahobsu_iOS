//
//  Mission.swift
//  Ahobsu
//
//  Created by admin on 2019/11/24.
//  Copyright © 2019 ahobsu. All rights reserved.
//

import Foundation

struct MissionData: Decodable {
    let id: Int
    let title: String
    let isContent: Int
    let isImage: Int

  enum CodingKeys: String, CodingKey {
    case id
    case title
    case isContent
    case isImage
  }
}
