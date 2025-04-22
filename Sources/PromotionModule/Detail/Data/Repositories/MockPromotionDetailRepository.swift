//
//  MockPromotionDetailRepository.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 17/04/25.
//

import Foundation
import AprodhitKit
import GnDKit

public class MockPromotionDetailRepository: PromotionDetailRepositoryLogic {
  
  public func fetchPromotionDetail(
    headers: AprodhitKit.HeaderRequest,
    parameters: PromotionDetailParamRequest
  ) async throws -> PromotionEntity {
    
    return PromotionEntity(
      name: "Diskon hingga Rp40.000 untuk konsultasi hukum Pidana",
      slug: "kode-voucher-1-11042025",
      imageURL: nil,
      startDate: "2025-10-23T00:00:00.000Z",
      endDate: "2025-10-25T00:00:00.000Z",
      description: "Menyediakan layanan konsultasi hukum online yang mudah, praktis, dan terpercaya. Didukung oleh tim pengacara berpengalaman, layanan ini memungkinkan Anda berkonsultasi kapan saja dan di mana saja tanpa harus datang langsung ke kantor. Semua percakapan dijamin aman dan rahasia, dengan harga terjangkau. Layanan meliputi berbagai kebutuhan hukum, seperti kasus perdata, pidana, hukum keluarga, hingga hukum bisnis. Dapatkan solusi hukum cepat dan tepat sesuai kebutuhan Anda.",
      tnc: "<p>ini syarat dan ketentuan</p>",
      platform: ["WEB", "IOS", "ANDROID"],
      quota: .init(total: 10, time: "MAX_QUOTA_DAILY", quota: 2),
      status: .EXPIRED
    )
    
  }
  
}
