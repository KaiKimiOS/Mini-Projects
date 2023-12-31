//
//  AnnounceModel.swift
//  project02-teamB-OUR-consumer
//
//  Created by 김종찬 on 2023/08/30.
//

import Foundation

struct Announcement: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var context: String
    var createdAt: Double = Date().timeIntervalSince1970
    var category: String
    
    var createdDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        
        let dateCreatedAt = Date(timeIntervalSince1970: createdAt)
        
        return dateFormatter.string(from: dateCreatedAt)
    }
}

extension Announcement {
    static var sample = Announcement(title: "안내사항", context: "안내사항입니다", category: "공지")
}
