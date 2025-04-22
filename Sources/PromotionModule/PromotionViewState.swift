//
//  PromotionViewState.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation

public enum PromotionViewState {
  case main
  case detail(slug: String)
  case openLink(_ url: URL?)
}

extension PromotionViewState: Equatable {
  public static func == (lhs: PromotionViewState, rhs: PromotionViewState) -> Bool {
    switch (lhs, rhs) {
    case (.main, .main),
      (.detail(_), .detail(_)),
      (.openLink(_), .openLink(_)):
      return true
    default:
      return false
    }
  }
}
