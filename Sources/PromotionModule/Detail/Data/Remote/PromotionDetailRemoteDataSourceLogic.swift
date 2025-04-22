//
//  PromotionDetailRemoteDataSourceLogic.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 17/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public protocol PromotionDetailRemoteDataSourceLogic {
  
  func fetchPromotionDetail(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> PromotionDetailModel
  
}

public class PromotionDetailRemoteDataSourceImpl: PromotionDetailRemoteDataSourceLogic {
  
  private let service: NetworkServiceLogic
  
  public init(service: NetworkServiceLogic) {
    self.service = service
  }
  
  public func fetchPromotionDetail(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> PromotionDetailModel {
    
    guard let slug = parameters["slug"] as? String
    else {
      throw NetworkErrorMessage(
        code: -100,
        description: "Slug tidak ditemukan"
      )
    }
    
    do {
      let data = try await service.request(
        with: Endpoint.PROMOTION_DETAIL.appending("\(slug)"),
        withMethod: .get,
        withHeaders: headers,
        withParameter: [:],
        withEncoding: .url
      )
      
      let model = try JSONDecoder().decode(PromotionDetailModel.self, from: data)
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
