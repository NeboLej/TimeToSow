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
            Text("Испытания")
                .font(.myTitle(24))
                .foregroundStyle(.black)
            challengesList()
            Spacer()
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
                Text(challenge.description)
                    .font(.callout)
                    .foregroundStyle(.black)
                ProgressView(value: challenge.progress, total: 1)
            }
            Spacer()
            if let rewardDecor = challenge.rewardDecor {
                let name = (challenge.rewardDecor?.resourceName ?? "") + (challenge.rewardDecor?.animationOptions != nil ? ".gif" : ".png")
                
                let _ = print(name)
                if name.contains(".gif") {
                    AnimatedImage(name: name, bundle: .main)
                        .resizable()
                        .customLoopCount(rewardDecor.animationOptions?.repeatCount ?? 1)
                        .scaledToFit()
                        .frame(width: rewardDecor.width, height: rewardDecor.height)
                        
                } else {
                    Image(name, bundle: .main)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .challenge)
}
