//
//  FakePromotionRemoteDataSource.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class FakePromotionRemoteDataSource: PromotionRemoteDataSourceLogic {
  
  public func fetchPromotionLists(
    headers: [String : String],
    parameters: [String : Any]
  ) async throws -> PromotionListModel {
    
    do {
      let data = try loadJSONFromFile(filename: "promotion_response_lists", inBundle: .module)!
      let model = try JSONDecoder().decode(PromotionListModel.self, from: data)
      
      return model
      
    } catch {
      throw NetworkErrorMessage(code: -2, description: "Error parsing")
    }
    
  }
  
}
