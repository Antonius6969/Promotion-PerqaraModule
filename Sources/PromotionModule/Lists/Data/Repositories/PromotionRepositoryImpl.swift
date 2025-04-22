//
//  PromotionRepositoryImpl.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class PromotionRepositoryImpl: PromotionRepositoryLogic {
  
  private let remote: PromotionRemoteDataSourceLogic
  
  public init(remote: PromotionRemoteDataSourceLogic) {
    self.remote = remote
  }
  
  public func fetchPromotionLists(
    headers: HeaderRequest,
    parameters: PromotionListRequestParams
  ) async throws -> [PromotionEntity] {
    do {
      let response = try await remote.fetchPromotionLists(
        headers: headers.toHeaders(),
        parameters: parameters.toParam()
      )
      
      let entities = response.data?.map(PromotionEntity.map(from:)) ?? []
      return entities
      
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
