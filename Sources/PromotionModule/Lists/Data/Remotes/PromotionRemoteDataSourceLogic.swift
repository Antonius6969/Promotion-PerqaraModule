//
//  PromotionRemoteDataSourceLogic.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol PromotionRemoteDataSourceLogic {
  
  func fetchPromotionLists(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> PromotionListModel
  
}

public class PromotionRemoteDataSourceImpl: PromotionRemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func fetchPromotionLists(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> PromotionListModel {
    
    do {
      let data = try await service.request(
        with: Endpoint.PROMOTION_LIST,
        withMethod: .get,
        withHeaders: headers,
        withParameter: parameters,
        withEncoding: .url
      )
      
      let model = try JSONDecoder().decode(PromotionListModel.self, from: data)
      return model
      
    } catch {
      guard let error = error as? NetworkErrorMessage
      else { throw error }
      
      throw NetworkErrorMessage(
        code: error.code,
        description: error.description
      )
    }
    
  }
  
}
