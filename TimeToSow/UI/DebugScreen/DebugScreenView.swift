//
//  DebugScreenView.swift
//  TimeToSow
//
//  Created by Nebo on 02.01.2026.
//

import SwiftUI

struct DebugScreenView: View {
    private let mockdata = MockDatabaseRepository()
    
    var potRepository : PotRepository {
        PotRepository(database: mockdata)
    }
    var seedRepository: SeedRepository {
        SeedRepository(database: mockdata)
    }

    var plantRepository: PlantRepository {
        PlantRepository(seedRepository: seedRepository,
                        potRepository: potRepository,
                        database: mockdata)
    }
    
    
    @State var selectedPot: Pot?
    @State var selectedSeed: Seed?
    
    @State var allPots: [Pot] = []
    @State var allSeeds: [Seed] = []
    @State var selectedPlant: Plant?
    @State var text = ""
    
    func getAllVariantsBy(fullTime: Int) -> [(seed: Rarity, pot: Rarity)] {
        self.plantRepository.allVariantsRatityCombo(fullTime: fullTime)
    }
    
    var filtredPods: [Pot] {
        if selectedSeed != nil {
            allPots.filter { !$0.potFeatures.contains(where: selectedSeed!.unavailavlePotTypes.contains) }
        } else {
            allPots
        }
    }
    
    var filtredSeeds: [Seed] {
        if selectedPot != nil {
            allSeeds.filter { !$0.unavailavlePotTypes.contains(where: selectedPot!.potFeatures.contains) }
        } else {
            allSeeds
        }
    }
    
    var allVariantsCount: Int {
        var count = 0
        allSeeds.forEach { seed in
            count += allPots.filter { !$0.potFeatures.contains(where: seed.unavailavlePotTypes.contains) }.count
        }
        return count
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HStack {
                    Spacer()
                    if selectedPlant != nil {
                        PlantPreview(zoomCoef: 2,
                                     plant: selectedPlant!,
                                     isShowPlantRating: false,
                                     isShowPotRating: false)
                        .id(selectedPlant)
                        .padding(.top, 30)
                    }
                    Spacer()
                }
                
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack(alignment: .bottom) {
                        ForEach(filtredSeeds, id: \.self) {
                            seedCell(seed: $0)
                        }
                    }
                }
                Text("Seed count: \(filtredSeeds.count)")
                    .foregroundStyle(.black)
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 30)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .bottom) {
                        ForEach(filtredPods, id: \.self) {
                            potCell(pot: $0)
                        }
                    }
                }
                Text("Pot count: \(filtredPods.count)")
                    .foregroundStyle(.black)
                    .padding(.top, 8)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 30)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Pots")
                            .foregroundStyle(.black)
                        potRarityView(rarity: .common)
                        potRarityView(rarity: .uncommon)
                        potRarityView(rarity: .rare)
                        potRarityView(rarity: .epic)
                        potRarityView(rarity: .legendary)
                    }
                    Spacer(minLength: 50)
                    
                    VStack(alignment: .leading) {
                        Text("Seeds")
                            .foregroundStyle(.black)
                        seedRarityView(rarity: .common)
                        seedRarityView(rarity: .uncommon)
                        seedRarityView(rarity: .rare)
                        seedRarityView(rarity: .epic)
                        seedRarityView(rarity: .legendary)
                    }
                    Spacer()
                }.padding()
                
                
                
                Group {
                    Text("all variants combo: \(allVariantsCount)")
                        .foregroundStyle(.black)
                    Text("count with time")
                        .foregroundStyle(.black)
                    countWithTimeView(time: 1)
                    countWithTimeView(time: Rarity.SCALE_DIVISION_VALUE * 1 + 1)
                    countWithTimeView(time: Rarity.SCALE_DIVISION_VALUE * 2 + 1)
                    countWithTimeView(time: Rarity.SCALE_DIVISION_VALUE * 3 + 1)
                    countWithTimeView(time: Rarity.SCALE_DIVISION_VALUE * 4 + 1)
                    countWithTimeView(time: Rarity.SCALE_DIVISION_VALUE * 5 + 1)
                    countWithTimeView(time: Rarity.SCALE_DIVISION_VALUE * 6 + 1)
                    countWithTimeView(time: Rarity.SCALE_DIVISION_VALUE * 7 + 1)
                    countWithTimeView(time: Rarity.SCALE_DIVISION_VALUE * 8 + 1)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                
                
            }
            .background(.mainBackground)
            .onAppear {
                allPots = potRepository.pots.reversed()
                allSeeds = seedRepository.seeds.reversed()
            }
        }
    }
    
    @ViewBuilder
    func countWithTimeView(time: Int) -> some View {
        let variants = getAllVariantsBy(fullTime: time)
        var count = 0
        variants.forEach { (seedRarity, potRarity) in
            let filtredPots = allPots.filter { $0.rarity == potRarity }
            let filtredSeed = allSeeds.filter { $0.rarity == seedRarity }
            filtredSeed.forEach { seed in
                count += filtredPots.filter { !$0.potFeatures.contains(where: seed.unavailavlePotTypes.contains) }.count
            }
        }
        
        return VStack(alignment: .leading) {
            HStack {
                Text("\(time) min -")
                Text("\(count) variants")
            }.foregroundStyle(.black)
//            Text("\(variants.map { "\($0.seed.starCount) : \($0.pot.starCount)" })")
                .foregroundStyle(.black)
            Rectangle()
                .foregroundStyle(.black)
                .frame(height: 1)
                .opacity(0.5)
        }
    }
    
    @ViewBuilder
    func potRarityView(rarity: Rarity) -> some View {
        HStack {
            RarityView(count: rarity.starCount).frame(height: 12)
            Text("\(allPots.filter{ $0.rarity == rarity}.count)")
                .foregroundStyle(.black)
        }
    }
    
    @ViewBuilder
    func seedRarityView(rarity: Rarity) -> some View {
        HStack {
            RarityView(count: rarity.starCount).frame(height: 12)
            Text("\(allSeeds.filter{ $0.rarity == rarity}.count)")
                .foregroundStyle(.black)
        }
    }
    
    @ViewBuilder
    func potCell(pot: Pot) -> some View {
        VStack {
            Image(pot.image)
                .resizable()
                .frame(width: pot.width * 2, height: CGFloat(pot.height) * 2)
                .background( pot == selectedPot ? .blue : .clear)
                .onTapGesture {
                    if selectedPot != pot {
                        selectedPot = pot
                    } else {
                        selectedPot = nil
                    }
                    selectPlant()
                }
        }
    }
    
    
    @ViewBuilder
    func seedCell(seed: Seed) -> some View {
        VStack {
            Image(seed.image)
                .resizable()
                .frame(width: seed.width * 1.5, height: CGFloat(seed.height) * 1.5)
                .background( seed == selectedSeed ? .blue : .clear)
                .onTapGesture {
                    if selectedSeed != seed {
                        selectedSeed = seed
                    } else {
                        selectedSeed = nil
                    }
                    selectPlant()
                }
        }
    }
    
    func selectPlant() {
        guard let selectedSeed, let selectedPot else { return }
        selectedPlant = Plant(seed: selectedSeed, pot: selectedPot, name: "", description: "", offsetY: 0, offsetX: 0, notes: [])
    }
}

#Preview {
    DebugScreenView()
}
