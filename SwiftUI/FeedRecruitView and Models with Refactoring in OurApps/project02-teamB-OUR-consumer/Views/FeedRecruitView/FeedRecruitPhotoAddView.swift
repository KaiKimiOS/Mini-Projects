//
//  FeedRecruitPhotoAddView.swift
//  project02-teamB-OUR-consumer
//
//  Created by 윤해수 on 2023/08/22.
//

import SwiftUI
import PhotosUI

struct FeedRecruitPhotoAddView: View {
 
    @State private var imageDatas: [UIImage] = []
    @Binding var selectedImages: [PhotosPickerItem]
    
    var body: some View {
        
        VStack {
            HStack {
                Text("사진추가")
                    .foregroundColor(.accentColor)
                Spacer()
            }
            .padding(.top)
            
            //사진데이터가 없을경우
            if selectedImages.isEmpty {
                
                PhotosPicker(
                    selection: $selectedImages,
                    matching: .any(of: [.images,.videos]),
                    photoLibrary: .shared()){
                    
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                        .font(.system(size: 40, weight: .thin))
                        .padding(40)
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    }
                
            } else {  //사진 데이터가 있을경우
                
                HStack{
                    ScrollView(.horizontal, showsIndicators: true) {
                        
                        HStack{
                            
                            PhotosPicker(
                                selection: $selectedImages,
                                matching: .any(of: [.images,.videos]),
                                photoLibrary: .shared()) {
                                    
                                    Image(systemName: "plus")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 40, weight: .thin))
                                        .frame(maxWidth: 150, maxHeight: 150)
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                                }
                            ForEach(imageDatas, id:\.self) { image in
                                
                                VStack{
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:150, height:150)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: selectedImages) { newImages in
            
            var images: [UIImage] = []
            
            Task{
                
                for image in newImages {
                    if let data =  try await image.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: data) {
                            images.append(uiImage)
                        }
                    }
                }
                imageDatas = images
            }
        }

    }
}
