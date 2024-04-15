//
//  ImageListView.swift
//  LogD
//
//  Created by 정종인 on 4/15/24.
//

import SwiftUI
import Photos

struct ImageListView: View {
    @State private var thumbnails: [UIImage] = []

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(thumbnails, id: \.self) { img in
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
            }
        }
        .onAppear {
            fetchCustomAlbumPhotos()
        }
    }

    @MainActor
    private func fetchCustomAlbumPhotos() {
        var photoAssets = PHFetchResult<PHAsset>()
        let fetchOptions = PHFetchOptions()

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        // NSPredicate를 사용하여 creationDate가 어제부터 오늘까지인 항목만 가져오기
        fetchOptions.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate <= %@", argumentArray: [yesterday, today])
        photoAssets = PHAsset.fetchAssets(with: fetchOptions)
        dump("collection : \(photoAssets)")

        let imageManager = PHCachingImageManager()
        photoAssets.enumerateObjects { asset, count, stop in
            let options = PHImageRequestOptions()
            options.deliveryMode = .fastFormat
            options.isSynchronous = true

            let imageSize = CGSize(width: asset.pixelWidth,
                                   height: asset.pixelHeight)
            imageManager.requestImage(for: asset,
                                      targetSize: imageSize,
                                      contentMode: .aspectFill,
                                      options: options,
                                      resultHandler: {
                (image, info) -> Void in
                if let image {
                    self.addImgToArray(uploadImage: image)
                }
            })
        }
    }

    @MainActor
    private func addImgToArray(uploadImage: UIImage){
        self.thumbnails.append(uploadImage)
    }

}

#Preview {
    ImageListView()
}
