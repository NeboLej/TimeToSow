//
//  RewardChallengeView.swift
//  TimeToSow
//
//  Created by Nebo on 02.02.2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChallengeCompleteView: View {
    @State private var store: RewardChallengeStore
    
    init(store: RewardChallengeStore) {
        self.store = store
    }
    
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
            collection()
                .offset(y: collectionOffetY)
        }.onChange(of: store.state.isShow) { _, isShow in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.55)) {
                collectionOffetY = isShow ? 0 : 300
            }
        }
    }
    
    @ViewBuilder
    private func collection() -> some View {
        ForEach(store.state.challanges) {
            challangeCell(for: $0)
        }
    }
    
    @ViewBuilder
    private func rewardView() -> some View {
        if let challenge = selectedCallenge,
           let rewardUrl = store.state.images[challenge.id],
           let reward = challenge.rewardDecor {
            
            VStack {
                Text("Получен\n\(reward.name)")
                    .multilineTextAlignment(.center)
                    .font(.myNumber(30))
                    .foregroundStyle(.black)
                
                WebImage(url: rewardUrl)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(height: reward.height * 5)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
            }
            .padding(40)
            .background(.mainBackground)
            .cornerRadius(.infinity, corners: .allCorners)
            .opacity(opacity)
                .onAppear {
                    appearAnimation()
                }
        }
    }
    
    private func appearAnimation() {
        withAnimation(.spring(response: 1, dampingFraction: 0.65)) {
            scale = 1
            rotation = 360
            opacity = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut(duration: 0.5)) {
                collectionOffetY = 300
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                scale = 0.7
                opacity = 0
                if let selectedCallenge {
                    store.send(.reward(challenge: selectedCallenge))
                }
                selectedCallenge = nil
                resetAnimationState()
            }
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
                Text("Испытание выполнено!")
                    .font(.myNumber(20))
                    .foregroundStyle(.black)
                Text(challenge.title)
                    .font(.myNumber(14))
                    .foregroundStyle(.black.opacity(0.8))
                
                button(label: "Получить награду", color: .yellow) {
                    startRewarding(challenge)
                }
                .padding(.top, 10)
            }
            .padding()
            Spacer()
            if let rewardUrl = store.state.images[challenge.id], let reward = challenge.rewardDecor {
                WebImage(url: rewardUrl)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(height: reward.height * 2)
            }
        }
        .background(.mainBackground)
        .shadow(radius: 10)
        .padding(8)
    }
    
    @ViewBuilder
    private func button(label: LocalizedStringKey, color: Color = .white, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            TextureView(
                insets: .init(top: 6, leading: 18, bottom: 6, trailing: 18),
                texture: Image(.smallTexture1),
                color: color,
                cornerRadius: 50
            ) {
                Text(label)
                    .font(.myNumber(16))
                    .foregroundStyle(.black)
            }
        }
        .buttonStyle(PressableStyle())
    }
}

#Preview {
    ZStack {
        screenBuilderMock.getScreen(type: .home)
            .navigationDestination(for: ScreenType.self) {
                screenBuilderMock.getScreen(type: $0)
            }
        
        screenBuilderMock.getComponent(type: .challengeCompleteView)
            .zIndex(1000)
    }
}
