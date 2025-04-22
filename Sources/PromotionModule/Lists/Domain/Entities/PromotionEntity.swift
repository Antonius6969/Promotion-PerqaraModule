//
//  PromotionListEntity.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class PromotionEntity: Identifiable, TransformableWithoutViewModel {
  
  public typealias D = PromotionData
  public typealias E = PromotionEntity
  
  public var id: UUID = UUID()
  public var name: String
  public let slug: String
  public let imageURL: URL?
  public let startDate: String
  public let endDate: String
  public let description: String
  public let tnc: String
  public let platform: [String]
  public let quota: PromotionQuotaEntity
  public let status: PromotionStatus
  
  public init() {
    self.name = ""
    self.slug = ""
    self.imageURL = nil
    self.startDate = ""
    self.endDate = ""
    self.description = ""
    self.tnc = ""
    self.platform = [""]
    self.quota = .init(total: 0, time: "", quota: 0)
    self.status = .SCHEDULED
  }
  
  public init(
    name: String,
    slug: String,
    imageURL: URL?,
    startDate: String,
    endDate: String,
    description: String,
    tnc: String,
    platform: [String],
    quota: PromotionQuotaEntity,
    status: PromotionStatus
  ) {
    self.name = name
    self.slug = slug
    self.imageURL = imageURL
    self.startDate = startDate
    self.endDate = endDate
    self.description = description
    self.tnc = tnc
    self.platform = platform
    self.quota = quota
    self.status = status
  }
  
  public static func map(from data: PromotionData) -> PromotionEntity {
    return PromotionEntity(
      name: data.name ?? "",
      slug: data.slug ?? "",
      imageURL: URL(string: data.imageBanner ?? ""),
      startDate: data.startDate ?? "",
      endDate: data.endDate ?? "",
      description: data.description ?? "",
      tnc: data.tnc ?? "",
      platform: ["WEB", "IOS", "ANDROID"],
      quota: .init(total: 10, time: "MAX_QUOTA_DAILY", quota: 2),
      status: PromotionStatus.convert(data.status ?? "")
    )
  }
  
  public func getDateString() -> String {
    guard let startDate = startDate.toDate() else { return "" }
    guard let endDate = endDate.toDate() else { return "" }
    return "\(startDate.toString()) - \(endDate.toString())"
  }
  
}

public struct PromotionQuotaEntity {
  let total: Int
  let time: String
  let quota: Int
}

public enum PromotionStatus {
  case ACTIVE
  case INACTIVE
  case EXPIRED
  case SCHEDULED
  
  public static func convert(_ text: String) -> PromotionStatus {
    switch text {
    case "ACTIVE":
      return .ACTIVE
    case "INACTIVE":
      return .INACTIVE
    case "EXPIRED":
      return .EXPIRED
    case "SCHEDULED":
      return .SCHEDULED
    default:
      return .INACTIVE
    }
  }
}
