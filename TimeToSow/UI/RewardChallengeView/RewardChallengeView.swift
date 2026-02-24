//
//  RewardChallengeView.swift
//  TimeToSow
//
//  Created by Nebo on 02.02.2026.
//

import SwiftUI
import SDWebImageSwiftUI


struct ChallengeCompleteView: View {
    @State var store: RewardChallengeStore
    
    @State private var selectedCallenge: Challenge?
    @State private var rotation: Double = -0
    @State private var scale: CGFloat = 0.2
    @State private var opacity: Double = 0
    
    @State private var collectionOffetY: CGFloat = 300
    
    var body: some View {
        VStack {
            Spacer()
            rewardView()
            Spacer()
            collection(challenges: store.state.challanges)
                .offset(y: collectionOffetY)
        }.onChange(of: store.state.isShow) { _, isShow in
            animateShow(isShow: isShow)
        }.onAppear {
            animateShow(isShow: store.state.isShow)
        }
    }
    
    private func animateShow(isShow: Bool) {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.55)) {
            collectionOffetY = isShow ? 0 : 300
        }
    }
    
    @ViewBuilder
    private func collection(challenges: [Challenge]) -> some View {
        ZStack {
            ForEach(Array(challenges.enumerated()), id: \.offset) { index, challenge in
                challangeCell(for: challenge)
                    .offset(x: 0, y: -10 * Double(index))
            }
        }
    }
    
    @ViewBuilder
    private func rewardView() -> some View {
        if let challenge = selectedCallenge,
           let reward = challenge.rewardDecor {
            
            ZStack(alignment: .bottom) {
                VStack {
                    Text(Lo.RewardChallenge.rewarding(RemoteText.text(reward.name)))
                        .multilineTextAlignment(.center)
                        .font(.myNumber(30))
                        .foregroundStyle(.black)
                    
                    DecorTypePreview(decorModel: reward, zoom: 3.5)
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(rotation))
                }
                .padding(40)
                .background(.mainBackground)
                .cornerRadius(.infinity, corners: .allCorners)
                
                HStack(spacing: 16) {
                    TextureButton(label: Lo.Button.inABox, color: .yellow,
                                  textColor: .black, font: .myNumber(20), icon: nil) {
                        finishRewardProcess(isShelf: false)
                    }
                    
                    TextureButton(label: Lo.Button.onShelf, color: .yellow,
                                  textColor: .black, font: .myNumber(20), icon: nil) {
                        finishRewardProcess(isShelf: true)
                    }
                }
                .padding([.horizontal, .top], 20)
                .offset(y: 10)
                
            }
            
            .opacity(opacity)
            .onAppear {
                appearAnimation()
            }
        }
    }
    
    private func finishRewardProcess(isShelf: Bool) {
        withAnimation(.easeInOut(duration: 0.5)) {
            scale = 0.7
            opacity = 0
            if let selectedCallenge {
                store.send(.reward(challenge: selectedCallenge, isUse: isShelf))
            }
            selectedCallenge = nil
            resetAnimationState()
        }
    }
    
    private func appearAnimation() {
        withAnimation(.spring(response: 1, dampingFraction: 0.65)) {
            scale = 1
            rotation = 360
            opacity = 1
        }
    }
    
    private func resetAnimationState() {
        rotation = -0
        scale = 0.2
        opacity = 0
    }
    
    private func startRewarding(_ challenge: Challenge) {
        selectedCallenge = challenge
    }
    
    @ViewBuilder
    private func challangeCell(for challenge: Challenge) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(Lo.RewardChallenge.challengeComplete)
                    .font(.myNumber(20))
                    .foregroundStyle(.black)
                Text(RemoteText.text(challenge.title))
                    .font(.myNumber(14))
                    .foregroundStyle(.black.opacity(0.8))
                button(label: Lo.Button.getReward, color: .yellow) {
                    startRewarding(challenge)
                }
                .padding(.top, 10)
            }
            .padding()
            Spacer()
            if let reward = challenge.rewardDecor {
                WebImage(url: reward.imageUrl)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(height: reward.height * 2)
            }
        }
        .background(.mainBackground)
        .cornerRadius(20, corners: .allCorners)
        .shadow(radius: 10)
        .offset(x: selectedCallenge == challenge ? 500 : 0)
        .animation(.easeInOut, value: selectedCallenge)
        .padding(8)
    }
    
    @ViewBuilder
    private func button(label: String, color: Color = .white, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            TextureView(
                insets: .init(top: 6, leading: 18, bottom: 6, trailing: 18),
                texture: Image(.smallTexture1),
                color: selectedCallenge == nil ? color : .black.opacity(0.1) ,
                cornerRadius: 50
            ) {
                Text(label)
                    .font(.myNumber(16))
                    .foregroundStyle(.black)
            }
        }
        .buttonStyle(PressableStyle())
        .disabled(selectedCallenge != nil)
    }
}

#Preview {
    screenBuilderMock.getComponent(type: .challengeCompleteView)
        .zIndex(1000)
    //    ZStack {
    //        screenBuilderMock.getScreen(type: .home)
    //            .navigationDestination(for: ScreenType.self) {
    //                screenBuilderMock.getScreen(type: $0)
    //            }
    
    
    //    }
}
