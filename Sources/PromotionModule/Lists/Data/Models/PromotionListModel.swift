//
//  PromotionListModel.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation

public struct PromotionListModel: Codable {
  let success: Bool?
  let data: [PromotionData]?
  let message: String?
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
    self.data = try container.decodeIfPresent([PromotionData].self, forKey: .data)
    self.message = try container.decodeIfPresent(String.self, forKey: .message)
  }
}

public struct PromotionData: Codable {
  let code, name, slug, description: String?
  let startDate, endDate, status, tnc: String?
  let imageBanner: String?
  let quota: Quota?
  let platform: [String]?
  
  enum CodingKeys: String, CodingKey {
    case code, name, slug, description
    case startDate = "start_date"
    case endDate = "end_date"
    case status, tnc
    case imageBanner = "image_banner"
    case quota, platform
  }
  
  public init() {
    self.code = ""
    self.name = ""
    self.slug = ""
    self.description = ""
    self.startDate = ""
    self.endDate = ""
    self.status = ""
    self.tnc = ""
    self.imageBanner = ""
    self.quota = nil
    self.platform = nil
  }
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.code = try container.decodeIfPresent(String.self, forKey: .code)
    self.name = try container.decodeIfPresent(String.self, forKey: .name)
    self.slug = try container.decodeIfPresent(String.self, forKey: .slug)
    self.description = try container.decodeIfPresent(String.self, forKey: .description)
    self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
    self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
    self.status = try container.decodeIfPresent(String.self, forKey: .status)
    self.tnc = try container.decodeIfPresent(String.self, forKey: .tnc)
    self.imageBanner = try container.decodeIfPresent(String.self, forKey: .imageBanner)
    self.quota = try container.decodeIfPresent(Quota.self, forKey: .quota)
    self.platform = try container.decodeIfPresent([String].self, forKey: .platform)
  }
  
  public struct Quota: Codable {
    let total: Int?
    let rule: Rule?
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.total = try container.decodeIfPresent(Int.self, forKey: .total)
      self.rule = try container.decodeIfPresent(Rule.self, forKey: .rule)
    }
  }
  
  public struct Rule: Codable {
    let key: String?
    let quota: Int?
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.key = try container.decodeIfPresent(String.self, forKey: .key)
      self.quota = try container.decodeIfPresent(Int.self, forKey: .quota)
    }
  }
  
}


