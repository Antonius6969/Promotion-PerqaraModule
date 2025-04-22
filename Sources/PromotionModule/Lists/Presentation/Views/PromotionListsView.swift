//
//  PromotionListsView.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import SwiftUI
import Kingfisher
import GnDKit
import AprodhitKit

public struct PromotionListsView: View {
  
  @ObservedObject var store: PromotionListsStore
  
  public var body: some View {
    VStack {
      StandardHeaderView(title: "Promo Perqara") {
        store.navigateBack()
      }
      
      ScrollView {
        VStack {
          LazyVStack {
            ForEach(store.entities, id: \.id) { entity in
              promotionCard(entity)
            }
          }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
      }
      .background(Color.gray050)
    }
    .task {
      await store.fetchPromotionLists()
    }
  }
  
  @ViewBuilder
  func promotionCard(_ entity: PromotionEntity) -> some View {
    VStack {
      KFImage
        .url(entity.imageURL)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(maxWidth: .infinity, maxHeight: 180)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(
              Color.gray100,
              lineWidth: 1
            )
        )
      
      HStack {
        VStack(alignment: .leading, spacing: 8) {
          Text("Periode Promo")
            .titleLexend(size: 12)
          
          Text(entity.getDateString())
            .captionLexend(size: 12)
        }
        .frame(
          maxWidth: .infinity,
          maxHeight: 100,
          alignment: .leading
        )
        
        Spacer()
        
        ButtonSecondary(
          title: "Lihat Detail",
          backgroundColor: .clear,
          tintColor: .buttonActiveColor,
          width: 115,
          height: 40
        ) {
          store.navigateToDetail(entity.slug)
        }
      }
      .padding(.all, 12)
    }
    .frame(maxWidth: .infinity)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
  
}

#Preview {
  PromotionListsView(
    store: PromotionListsStore(
      promotionRepository: MockPromotionRepository(),
      promotionNavigator: MockNavigator()
    )
  )
}
