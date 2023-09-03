//
//  FeedRecruitStore.swift
//  project02-teamB-OUR-consumer
//
//  Created by kaikim on 2023/08/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import PhotosUI
import _PhotosUI_SwiftUI

final class FeedRecruitStore: ObservableObject {
    
    @Published var feedStores: [FeedRecruitModel] = []
    
    private let service = RecruitService()
    private let dbRef = Firestore.firestore().collection("posts")
    
    func fetchFeeds() {
        service.fetchAll(collection: .posts) { results in
            self.feedStores = results
        }
    }
    
    func addFeed( _ data: FeedRecruitModel ) {
        service.add(collection: .posts, data: data)
    }
    
    
    func updateData( docID: String, _ data: FeedRecruitModel ) {
        service.update(collection: .posts, documentID: docID, data: data)
    }
    
    //이미지 FireBase Storage에 저장
    func returnImagePath(items: [PhotosPickerItem]) async throws -> [String]{ 
        
        var urlString:[String] = []
        
        for item in items {
            
            guard let data = try? await item.loadTransferable(type: Data.self) else { throw URLError(.badURL) }
            guard let uiImage = UIImage(data: data) else { throw URLError(.badURL) }
            guard let compressImage = uiImage.jpegData(compressionQuality: 0.5) else { throw URLError(.badURL) }
            
            do {
                let url = try await FeedStorageManager.shared.saveImage(data: compressImage, id: dbRef.document().documentID)
                    urlString.append(url.absoluteString)
            } catch {
                print("리턴이미지패스 에러 \(error.localizedDescription)")
            }
        }
        if !urlString.isEmpty { return urlString } else { throw URLError(.badURL) }
    }
}
