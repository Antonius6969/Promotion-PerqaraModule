//
//  PromotionDetailRepositoryLogic.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 17/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol PromotionDetailRepositoryLogic {
  
  func fetchPromotionDetail(
    headers: HeaderRequest,
    parameters: PromotionDetailParamRequest
  ) async throws -> PromotionEntity
  
}
