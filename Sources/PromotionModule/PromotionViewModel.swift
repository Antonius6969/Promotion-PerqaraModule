//
//  PromotionViewModel.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class PromotionViewModel: PromotionNavigator {
  
  @Published var view: PromotionViewState = .main
  
  public init() {}
  
  public func navigateToPromo() {
    view = .main
  }
  
  public func navigateToPromoDetail(_ slug: String) {
    view = .detail(slug: slug)
  }
  
  public func back() {
    view = .main
  }
  
  public func openLink(_ url: URL?) {
    view = .openLink(url)
  }
  
}
