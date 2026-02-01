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
        VStack {
            if store.state.seasonIsActive {
                ScrollView {
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
            } else {
                emptyState()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.mainBackground)
    }
    
    @ViewBuilder private func emptyState() -> some View {
        Text("Нет активных испытаний")
            .font(Font.myNumber(20))
            .foregroundStyle(.black.opacity(0.7))
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
