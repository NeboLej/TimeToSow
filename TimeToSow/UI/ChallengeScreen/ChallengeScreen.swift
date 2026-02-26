//
//  ChallengeScreen.swift
//  TimeToSow
//
//  Created by Nebo on 22.01.2026.
//

import SwiftUI
import SDWebImageSwiftUI

typealias ColorPeir = (Color, Color)

enum ColorSet: CaseIterable {
    case grayBlue, brownCream, yellowBurgundy, yellowGreen, yellowBlue
    case burgundyPink, pinkBeige
    
    var colors: ColorPeir {
        switch self {
        case .grayBlue: (Color(hex: "#B7EFFF"), Color(hex: "#575757"))
        case .pinkBeige: (Color(hex: "#FFF6CF"), Color(hex: "#FF5A96"))
        case .brownCream: (Color(hex: "#FDFBD7"), Color(hex: "#815E35"))
        case .yellowBurgundy: (Color(hex: "#721E1E"), Color(hex: "#E2D797"))
        case .yellowGreen: (Color(hex: "#83C082"), Color(hex: "#FAFFBA"))
        case .yellowBlue: (Color(hex: "#949CFF"), Color(hex: "#FFED86"))
        case .burgundyPink: (Color(hex: "#FFD2EB"), Color(hex: "#430119"))
        }
    }
}

struct ChallengeScreen: View {
    
    @State var store: ChallengeStore
    
    private let colors: [ColorPeir] = ColorSet.allCases.map(\.colors)
    
    var body: some View {
        VStack {
            if store.state.seasonIsActive {
                ScrollView {
                    Text(Lo.ChallengeScreen.title)
                        .font(.myTitle(30))
                        .foregroundStyle(.black)
                    Text(RemoteText.text(store.state.seasonName))
                        .multilineTextAlignment(.center)
                        .font(.myTitle(24))
                        .foregroundStyle(.black)
                    
                    headerBanner()
                    
                    separatorView()
                        .padding(.vertical, 16)
                    
                    challengesList()
                        .padding(.horizontal, 8)
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
        Text(Lo.ChallengeScreen.emptyState)
            .font(Font.myNumber(20))
            .foregroundStyle(.black.opacity(0.7))
    }
    
    @ViewBuilder private func separatorView() -> some View {
        HStack {
            Group {
                Rectangle()
                    .frame(width: 45)
                Rectangle()
                    .frame(width: 8)
                Rectangle()
                    .frame(width: 45)
            }
            .foregroundStyle(.black.opacity(0.4))

        }
        .frame(height: 3)
    }
        
    
    @ViewBuilder private func headerBanner() -> some View {
        VStack(alignment: .trailing) {
            HStack {
                Text(Lo.ChallengeScreen.allChallengesDescriptioin)
                    .font(Font.myTitle(18))
                    .foregroundStyle(.black.opacity(0.65))
                Spacer()
            }
            
            Text(Lo.ChallengeScreen.endSeasonDate(store.state.seasonEndDate.toReadableDate()))
                .font(.myNumber(14))
                .foregroundStyle(.black.opacity(0.8))
                .padding(.top, 12)
//
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.strokeAcsent2.opacity(0.4))
        .cornerRadius(12, corners: .allCorners)
        .padding(.horizontal, 8)
    }
    
    @ViewBuilder
    private func challengesList() -> some View {
        ForEach(store.state.challengeProgress) { challenge in
            let index = store.state.challengeProgress.firstIndex(of: challenge) ?? 0
            challengeProgressCell(challenge, colorPair: colors[index % colors.count])
        }
    }
    
    @ViewBuilder
    private func challengeProgressCell(_ challenge: ChallengeProgress, colorPair: ColorPeir) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(RemoteText.text(challenge.name))
                    .font(.myNumber(20))
                    .foregroundStyle(colorPair.1)
                    .padding(.bottom, 8)
                    .padding(.top, 4)
                Text(challenge.description)
                    .font(.myRegular(16))
                    .foregroundStyle(colorPair.1.opacity(0.8))
                HStack {
                    Text("\(Int(challenge.progress * 100))%")
                        .font(.myNumber(16))
                        .foregroundStyle(colorPair.1)
                    progressView(value: challenge.progress)
                } .padding(.bottom, 8)

            }
            Spacer()
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 2)
                .padding(.vertical, 4)
                .foregroundStyle(.black.opacity(0.1))
            
            VStack {
                if let rewardDecor = challenge.rewardDecor {
                    WebImage(url: rewardDecor.imageUrl)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .frame(height: rewardDecor.height * 2)
                    Text(RemoteText.text(rewardDecor.name))
                        .font(.myNumber(16))
                        .foregroundStyle(colorPair.1)
                        .multilineTextAlignment(.center)
                }
            }.frame(width: 100)
            
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(colorPair.0)
        .textureOverlay()
        .cornerRadius(12, corners: .allCorners)
    }
    
    @ViewBuilder
    private func progressView(value: Double) -> some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                Rectangle()
                    .cornerRadius(6, corners: .allCorners)
                    .foregroundStyle(.black.opacity(0.3))
                
                Rectangle()
                    .frame(width: geometry.size.width * CGFloat(value))
                    .cornerRadius(6, corners: .allCorners)
                    .foregroundStyle(.strokeAcsent2)
            }
        }.frame(height: 12)
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .challenge)
}
