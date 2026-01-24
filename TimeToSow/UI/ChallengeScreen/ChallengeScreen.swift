//
//  ChallengeScreen.swift
//  TimeToSow
//
//  Created by Nebo on 22.01.2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChallengeScreen: View {
    
    @State var store: ChallengeStore
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Испытания")
                    .font(.myTitle(30))
                    .foregroundStyle(.black)
                Text(store.state.seasonName)
                    .font(.myTitle(24))
                    .foregroundStyle(.black)
                Text(store.state.seasonDescription)
                    .foregroundStyle(.black)

                challengesList()
                Spacer()
            }
        }.background(.mainBackground)
    }
    
    @ViewBuilder
    private func challengesList() -> some View {
        ForEach(store.state.challengeProgress) { challenge in
            challengeProgressCell(challenge)
        }
    }
    
    @ViewBuilder
    private func challengeProgressCell(_ challenge: ChallengeProgress) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(challenge.name)
                    .font(.myNumber(20))
                    .foregroundStyle(.black)
                    .padding(.bottom, 8)
                    .padding(.top, 4)
                Text(challenge.description)
                    .font(.callout)
                    .foregroundStyle(.black.opacity(0.55))
                ProgressView(value: challenge.progress, total: 1)
                    .padding(.vertical, 4)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 2)
                .padding(.vertical, 10)
                .foregroundStyle(.black.opacity(0.3))
            
            VStack {
                
                if let rewardDecor = challenge.rewardDecor {
//                    let name = (challenge.rewardDecor?.resourceName ?? "") + (challenge.rewardDecor?.animationOptions != nil ? ".gif" : ".png")
//                    
//                    let name
                    let name = challenge.rewardDecor?.resourceUrl ?? ""
                    
                    let _ = print(name)
                    if name.contains(".gif") {
                        AnimatedImage(name: name, bundle: .main)
                            .resizable()
                            .customLoopCount(rewardDecor.animationOptions?.repeatCount ?? 1)
                            .scaledToFit()
                            .padding()
//                            .frame(width: rewardDecor.width * 1.7)
                    } else {
                        WebImage(url: challenge.rewardUrl)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(height: rewardDecor.height * 1.7)
                        
//                        Image.file(name)
//                            .resizable()
//                            .scaledToFit()
//                            .padding()
////                            .frame(width: rewardDecor.width * 1.7)
                    }
                    Text(rewardDecor.name)
                        .multilineTextAlignment(.center)
                }
            }.frame(width: 100)

        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.strokeAcsent1.opacity(0.3))
        .textureOverlay()
        .cornerRadius(12, corners: .allCorners)
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .challenge)
}

extension Image {
    static func file(
        _ name: String,
        bundle: Bundle = .main,
        subdirectory: String? = nil
    ) -> Image {
        if let uiImage = ImageFileCache.shared.image(
            named: name,
            bundle: bundle,
            subdirectory: subdirectory
        ) {
            return Image(uiImage: uiImage)
        }

        return Image(systemName: "photo")
    }
}


extension Image {
    init?(fileName: String, ext: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: ext),
              let uiImage = UIImage(contentsOfFile: path) else {
            return nil
        }
        self = Image(uiImage: uiImage)
    }
}

final class ImageFileCache {
    static let shared = ImageFileCache()

    private let cache = NSCache<NSString, UIImage>()

    func image(
        named name: String,
        bundle: Bundle = .main,
        subdirectory: String? = nil
    ) -> UIImage? {
        let key = "\(bundle.bundlePath)/\(subdirectory ?? "")/\(name)" as NSString

        if let cached = cache.object(forKey: key) {
            return cached
        }

        let parts = name.split(separator: ".", maxSplits: 1)
        let resource = String(parts.first ?? "")
        let ext = parts.count > 1 ? String(parts.last!) : nil

        guard let url = bundle.url(forResource: resource, withExtension: ext, subdirectory: subdirectory),
              let image = UIImage(contentsOfFile: url.path) else {
            return nil
        }

        cache.setObject(image, forKey: key)
        return image
    }
}
