//
//  PromotionListsStore.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import GnDKit
import AprodhitKit
import Combine

public class PromotionListsStore: ObservableObject {
  
  //Dependency
  private let promotionRepository: PromotionRepositoryLogic
  private let promotionNavigator: PromotionNavigator
  
  @Published public var entities: [PromotionEntity] = []
  @Published public var showError: Bool = false
  
  var didBack = PassthroughSubject<Bool, Never>()
  
  public init(
    promotionRepository: PromotionRepositoryLogic,
    promotionNavigator: PromotionNavigator
  ) {
    self.promotionRepository = promotionRepository
    self.promotionNavigator = promotionNavigator
  }
  
  //MARK: - API
  
  @MainActor
  public func fetchPromotionLists() async {
    do {
      entities = try await promotionRepository.fetchPromotionLists(
        headers: HeaderRequest(token: ""),
        parameters: PromotionListRequestParams()
      )
      
      if entities.isEmpty {
        showError = true
      }
    } catch {
      showError = true
    }
  }
  
  //MARK: - Local
  
  
  //MARK: - Other function
  
  
  //MARK: - Navigation
  
  public func navigateToDetail(_ slug: String) {
    promotionNavigator.navigateToPromoDetail(slug)
  }
  
  public func navigateBack() {
    didBack.send(true)
  }
  
  
  //MARK: - Indicate
  
  
  //MARK: - Observer
  
  
  
}

public protocol PromotionListsStoreFactory {
  func makePromotionListsStore() -> PromotionListsStore
}
