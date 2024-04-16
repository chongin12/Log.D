//
//  ImageListView.swift
//  LogD
//
//  Created by 정종인 on 4/15/24.
//

import SwiftUI
import Photos

private enum FilmLoadingStatus {
    case initial
    case loading
    case success([Film])
    case failure
    case empty
}

struct ImageListView: View {
    @State private var filmLoadingStatus: FilmLoadingStatus = .initial

    @State private var mainFilmID: Film.ID? = nil

    var body: some View {
        GeometryReader { proxy in
            switch filmLoadingStatus {
            case .initial:
                Text("Initial")
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity)
            case .success(let films):
                ScrollView(.horizontal) {
                    FilmsView(films)
                        .scrollTargetLayout()
                }
                .scrollPosition(id: $mainFilmID)
                .contentMargins(.horizontal, proxy.size.width / 4.0)
                .scrollTargetBehavior(.viewAligned(limitBehavior: .automatic))
                .scrollIndicators(.hidden)
                .onAppear {
                    self.mainFilmID = films.last?.id
                }
            case .failure:
                Text("Failed")
            case .empty:
                Text("Empty : Not Images")
            }
        }
        .padding(.vertical)
        .background(.background.opacity(0.85))
        .aspectRatio(16.0 / 9.0, contentMode: .fit)
        .presentationBackground(.thickMaterial)
        .onAppear {
            self.filmLoadingStatus = .loading
            Task {
                await fetchCustomAlbumPhotos()
            }
        }
    }

    @ViewBuilder
    private func FilmsView(_ films: [Film]) -> some View {
        LazyHStack {
            ForEach(films, id: \.id) { film in
                ZStack(alignment: .bottom) {
                    film.image
                        .resizable()
                        .scaledToFit()
                        .background(Color.gray)
                        .border(mainFilmID == film.id ? Color.yellow : Color.black, width: 3)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 8)
                        .scrollTransition(axis: .horizontal) { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                                .offset(y: phase.isIdentity ? 0 : 20.0)
                        }
                    if mainFilmID == film.id, let date = film.date {
                        VStack {
                            Spacer()
                            let formattedDay = RelativeDateTimeFormatter().localizedString(for: date, relativeTo: .now)
                            let formattedTime = date.formatted(date: .omitted, time: .shortened)
                            Text(formattedDay + ", " + formattedTime)
                                .font(.caption)
                                .fontWeight(.light)
                                .padding(8)
                                .background(in: Capsule())
                                .backgroundStyle(.background.secondary.opacity(0.8))
                        }
                    }
                }
                .frame(maxHeight: .infinity)
            }
        }
    }

    private func fetchCustomAlbumPhotos() async {
        var photoAssets = PHFetchResult<PHAsset>()
        let fetchOptions = PHFetchOptions()

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: +1, to: today)!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: today)!

        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        // NSPredicate를 사용하여 creationDate가 엊그제부터 내일까지인 항목만 가져오기
        fetchOptions.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate <= %@", argumentArray: [weekAgo, tomorrow])
        photoAssets = PHAsset.fetchAssets(with: fetchOptions)

        var films = [Film]()

        defer {
            self.imageLoadSuccess(films: films)
        }

        let imageManager = PHCachingImageManager()
        photoAssets.enumerateObjects { asset, count, stop in
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic
            options.isSynchronous = true

            let imageSize = CGSize(width: asset.pixelWidth,
                                   height: asset.pixelHeight)
            imageManager.requestImage(
                for: asset,
                targetSize: imageSize,
                contentMode: .aspectFill,
                options: options,
                resultHandler: { (image, info) -> Void in
                    if let image, films.count < 1000 { // 너무 많이 가져오면 터짐
                        films.append(Film(date: asset.creationDate, image: Image(uiImage: image)))
                    }
                }
            )
        }
    }

    private func imageLoadSuccess(films: [Film]){
        if films.isEmpty {
            self.filmLoadingStatus = .empty
        } else {
            self.filmLoadingStatus = .success(films)
        }
    }

}

#Preview {
    ImageListView()
}
