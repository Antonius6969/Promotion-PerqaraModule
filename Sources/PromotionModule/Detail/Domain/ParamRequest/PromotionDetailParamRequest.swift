//
//  PromotionDetailParamRequest.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 17/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public struct PromotionDetailParamRequest: Paramable {
  
  private let slug: String
  
  public init(slug: String) {
    self.slug = slug
  }
  
  public func toParam() -> [String : Any] {
    return ["slug" : slug]
  }
}
