//
//  PromotionRepositoryLogic.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol PromotionRepositoryLogic {
  
  func fetchPromotionLists(
    headers: HeaderRequest,
    parameters: PromotionListRequestParams
  ) async throws -> [PromotionEntity]
  
}
