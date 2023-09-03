//
//  FeedRecruitModel.swift
//  project02-teamB-OUR-consumer
//
//  Created by kaikim on 2023/08/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct FeedRecruitModel: Codable, Identifiable {
    
    @DocumentID var id: String?
    var creator: String?
    var content: String?
    var location: String?
    var privateSetting: Bool?  // FireBase에 True,False로 들어가야하기 때문에
    var reportCount: Int?
    var createdAt: String?
    var postImagePaths: [String]
}

enum PrivacySetting {
    
    case Public
    case Private
    
    // 각 case에 맞게 FireBase/View에 보여주기 위함
    var setting: Bool {
        switch self {
        case .Public:
            return false
        case .Private:
            return true
        }
    }
}
