//
//  MockPromotionRepository.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class MockPromotionRepository: PromotionRepositoryLogic {
  
  public init() {}
  
  public func fetchPromotionLists(
    headers: HeaderRequest,
    parameters: PromotionListRequestParams
  ) async throws -> [PromotionEntity] {
    return [
      PromotionEntity(
        name: "Kode voucher 1",
        slug: "kode-voucher-1-11042025",
        imageURL: nil,
        startDate: "2024-10-23T00:00:00.000Z",
        endDate: "2025-10-23T00:00:00.000Z",
        description: "deskripsi kode voucher 1",
        tnc: "<p>ini syarat dan ketentuan</p>",
        platform: ["WEB", "IOS", "ANDROID"],
        quota: .init(total: 10, time: "MAX_QUOTA_DAILY", quota: 2),
        status: .ACTIVE
      ),
      PromotionEntity(
        name: "Kode voucher 2",
        slug: "kode-voucher-2-11042025",
        imageURL: nil,
        startDate: "2024-10-23T00:00:00.000Z",
        endDate: "2025-10-23T00:00:00.000Z",
        description: "deskripsi kode voucher 1",
        tnc: "<p>ini syarat dan ketentuan</p>",
        platform: ["WEB", "ANDROID"],
        quota: .init(total: 10, time: "MAX_QUOTA_DAILY", quota: 2),
        status: .ACTIVE
      )
    ]
  }
  
}
