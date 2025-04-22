//
//  PromotionDetailModel.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 21/04/25.
//

import Foundation

// MARK: - PromotionDetailModel
public struct PromotionDetailModel: Codable {
  let success: Bool?
  let data: PromotionData?
  let message: String?
  
  // MARK: - DataClass
  struct DataClass: Codable {
    let code, name, slug, description: String?
    let startDate, endDate, status, tnc: String?
    let imageBanner: String?
    let quota: Quota?
    let platform: [String]?
    
    enum CodingKeys: String, CodingKey {
      case code, name, slug, description
      case startDate
      case endDate
      case status, tnc
      case imageBanner
      case quota, platform
    }
  }

  // MARK: - Quota
  struct Quota: Codable {
    let total: Int?
    let rule: Rule?
  }

  // MARK: - Rule
  struct Rule: Codable {
    let key: String?
    let quota: Int?
  }
  
}
