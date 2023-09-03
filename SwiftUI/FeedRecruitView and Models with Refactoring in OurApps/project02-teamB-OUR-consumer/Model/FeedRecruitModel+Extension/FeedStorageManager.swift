import Foundation
import FirebaseStorage
import FirebaseAuth
import Firebase

final class FeedStorageManager {
    
    private let storage = Storage.storage().reference()
    static let shared = FeedStorageManager()
    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    private init() {}
    
    private func userReference(id: String) -> StorageReference {
        storage.child("FeedPosts").child(id)
    }
    
    private func getSavedImage(id: String, path: String) async throws -> Data {
        try await userReference(id: id).child(path).data(maxSize: 3 * 1024 * 1024)
    }
    
    func saveImage(data: Data, id: String) async throws -> URL {

        let path = "\(UUID().uuidString).jpeg"
        
        do {
            //파베에 사진 저장하기
            let _ = try await userReference(id: id).child(path).putDataAsync(data, metadata: nil)
            
            // 저장된 사진의 url 받아오기
            let test = try await userReference(id: id).child(path).downloadURL()
            
            // url 리턴하기
            return test
        } catch {
            
            throw StorageErrorCode.quotaExceeded
        }
    }
}
