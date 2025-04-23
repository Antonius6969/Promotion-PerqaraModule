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
      tnc: "<p><ol><li>Periode promo berlaku&nbsp;<strong>khusus April MOP pada April 2025.</strong></li><li>User yang berhak menerima&nbsp;<em>reward</em>, akan memperoleh&nbsp;<strong>Bundle Voucher 10 Ribu</strong>&nbsp;yang terdiri dari discount untuk transaksi Bank, E-wallet dan QRIS.</li><li>Pengiriman&nbsp;<strong><em>reward</em></strong>&nbsp;akan dilakukan&nbsp;<strong>paling lambat pada hari Selasa, 23 April 2025</strong></li><li><strong>Kuota&nbsp;<em>reward</em>&nbsp;terbatas</span></strong>. Apabila tidak mendapatkan reward, maka kuota sudah habis.</span></li><li>Jika terjadi kegagalan atau kendala transaksi, mohon dapat menghubungi Customer Care&nbsp;Perqara melalui:<ol><li>E-mail:&nbsp;cs@perqara.com</li><li>WhatsApp Resmi: 0815-1150-0793</li></ol></li><li>Perqara&nbsp;berhak membatalkan cashback atau diskon yang telah diberikan apabila ditemukan indikasi kecurangan/ fraud dalam pelaksanaan promo ini.</li><li>Keputusan&nbsp;Perqara tidak dapat diganggu gugat</li></ol></p>",
      platform: ["WEB", "IOS", "ANDROID"],
      quota: .init(total: 10, time: "MAX_QUOTA_DAILY", quota: 2),
      status: .ACTIVE
    )
    
  }
  
}
