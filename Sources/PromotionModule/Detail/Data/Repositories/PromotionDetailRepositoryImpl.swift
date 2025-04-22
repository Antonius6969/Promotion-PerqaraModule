//
//  PromotionDetailRepositoryImpl.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 17/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class PromotionDetailRepositoryImpl: PromotionDetailRepositoryLogic {
  
  private let remote: PromotionDetailRemoteDataSourceLogic
  
  public init(remote: PromotionDetailRemoteDataSourceLogic) {
    self.remote = remote
  }
  
  public func fetchPromotionDetail(
    headers: HeaderRequest,
    parameters: PromotionDetailParamRequest
  ) async throws -> PromotionEntity {
    
    do {
      let response = try await remote.fetchPromotionDetail(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      GLogger(.info, layer: "Presentation", message: response)
      let entity = response.data.map(PromotionEntity.map(from:)) ?? .init()
      return entity
      
    } catch {
      guard let error = error as? NetworkErrorMessage
      else {
        throw ErrorMessage(
          id: -5,
          title: "Unkown Error",
          message: error.localizedDescription
        )
      }
      
      throw ErrorMessage(
        id: error.code,
        title: "Failed",
        message: error.description
      )
    }
    
  }
  
}
