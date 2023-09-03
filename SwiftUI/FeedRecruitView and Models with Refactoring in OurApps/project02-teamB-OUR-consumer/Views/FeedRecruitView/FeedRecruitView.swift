//  FeedRecruitView.swift

import SwiftUI
import PhotosUI


struct FeedRecruitView: View {
    
    private let userID: String = UserDefaults.standard.string(forKey: Keys.userId.rawValue ) ?? ""
    private let padddingAmount: CGFloat = 20
    private let toastFieldWidth: Double = 110
    
    //MARK: - Toast Message 사용방법 - 1번 Toast 선언하기
    @State private var toastMessage: Toast? = nil
    @State private var privacySetting: PrivacySetting = PrivacySetting.Public
    @State private var content: String = ""
    @State private var locationAddress: String = ""
    @State private var postImagePaths: [String] = []
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var createdDate: Date = Date()
    @State private var newFeed: FeedRecruitModel = FeedRecruitModel(
        
        creator: "",
        content: "",
        location: "",
        privateSetting: false,
        reportCount: 0,
        postImagePaths: []
    )
    
    @EnvironmentObject private var feedStoreViewModel: FeedRecruitStore
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    //공개범위 뷰
                    FeedRecruitPrivateSettingView(privacySetting: $privacySetting)
                    
                    //위치설정 뷰
                    FeedRecruitLocationView(locationAddress: $locationAddress)
                        .padding(.horizontal)
                    
                }
                
                Group {
                    //content 글 작성뷰
                    FeedRecruitTextEditorView(content: $content)
                    
                    //사진추가 View
                    FeedRecruitPhotoAddView(selectedImages: $selectedImages)
                }
            }
            .padding(.horizontal, padddingAmount)
            .toolbar {
                
                ToolbarItem(placement:.navigationBarLeading) {
                    
                    Button("취소") { dismiss() }
                }
                
                ToolbarItem(placement:.navigationBarTrailing) {
                    
                    Button("등록") {
                        
                        if selectedImages.isEmpty {
                            postImagePaths.removeAll()
                            addToStore()
                            return
                            
                        } else {
                            Task {
                                do {
                                    postImagePaths.removeAll()
                                    postImagePaths = try await feedStoreViewModel.returnImagePath(items: selectedImages)
                                    addToStore()
                                } catch {
                                    toastMessage = Toast(style: .error, message: "등록 실패",  width: toastFieldWidth)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }
                    .disabled(content.isEmpty)
                }
            }
        }
        
        //MARK: - 2. NavigationStack 타이틀과 같은 위치에 아래를 추가하기
        .toastView(toast: $toastMessage)
        .navigationTitle("피드 등록")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

extension FeedRecruitView {
    
    func addToStore() {
        
        newFeed = FeedRecruitModel(
            creator: userID,
            content: content,
            location: locationAddress,
            privateSetting: privacySetting.setting,
            reportCount: 0,
            createdAt: createdDate.toString(),
            postImagePaths: postImagePaths)
        
        feedStoreViewModel.addFeed(newFeed)
        toastMessage = Toast(style: .success, message: "등록 완료",  width: toastFieldWidth)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            dismiss()
        }
    }
}
