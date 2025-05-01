//
//  PromotionDetailStore.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 17/04/25.
//

import Foundation
import AprodhitKit
import GnDKit
import Combine
import Environment
import UIKit

public class PromotionDetailStore: ObservableObject {
  
  public typealias DateTimeRemainings = (Int, Int, Int)
  
  private let slug: String
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let repository: PromotionRepositoryLogic
  private let detailRepository: PromotionDetailRepositoryLogic
  private let dashboardResponder: DashboardResponder
  private let navigator: PromotionNavigator
  private let advocateNavigator: OnlineAdvocateNavigator
  
  public var didBack = PassthroughSubject<Bool, Never>()
  
  @Published public var showButtonPromotionLists: Bool = false
  @Published public var showFailedView: Bool = false
  @Published public var failureTitle: String = ""
  @Published public var failureDescription: String = ""
  @Published public var entities: [PromotionEntity] = .init()
  @Published public var entity: PromotionEntity = .init()
  @Published public var isExpired: Bool = false
  private var userSessionData: UserSessionData? = nil
  private var environment = Environment.shared
  public var imageErrorName = "img_coupon_not_available"
  
  public init(
    slug: String,
    userSessionDataSource: UserSessionDataSourceLogic,
    repository: PromotionRepositoryLogic,
    detailRepository: PromotionDetailRepositoryLogic,
    dashboardResponder: DashboardResponder,
    navigator: PromotionNavigator,
    advocateNavigator: OnlineAdvocateNavigator
  ) {
    self.slug = slug
    self.userSessionDataSource = userSessionDataSource
    self.repository = repository
    self.detailRepository = detailRepository
    self.dashboardResponder = dashboardResponder
    self.navigator = navigator
    self.advocateNavigator = advocateNavigator
  }
  
  //MARK: - API
  
  @MainActor
  public func fetchPromotionLists() async {
    do {
      entities = try await repository.fetchPromotionLists(
        headers: HeaderRequest(token: ""),
        parameters: PromotionListRequestParams()
      )
      
      showButtonPromotionLists = !entities.isEmpty
    } catch {
      
    }
  }
  
  @MainActor
  public func fetchPromotionDetail() async {
    do {
      entity = try await detailRepository.fetchPromotionDetail(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: PromotionDetailParamRequest(slug: slug)
      )
      
      if entity.status == .EXPIRED {
        imageErrorName = "img_coupon_not_available"
        showFailedView = true
        failureTitle = "Promo Ini Sudah Berakhir"
        failureDescription = "Penawaran yang Anda cari telah berakhir dan tidak dapat digunakan lagi."
      }
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return }
      
      imageErrorName = "img_coupon_not_available2"
      showFailedView = true
      failureTitle = "Tidak Ada Promo Tersedia"
      failureDescription = "Anda dapat gunakan layanan terbaik Perqara tanpa promo. Nantikan penawaran menarik selanjutnya!"
      
      GLogger(
        .info,
        layer: "Presentation",
        message: "error \(error)"
      )
    }
  }
  
  //MARK: - Local
  
  public func fetchUserSessionData() async {
    do {
      userSessionData = try await userSessionDataSource.fetchData()
    } catch {
      
    }
  }
  
  //MARK: - Other Function
  
  public func getPlatform() -> String {
    return entity.platform.joined(separator: ", ")
  }
  
  public func getUsageInfo() -> String {
    let info = entity.quota.time
    if info.contains("DAILY") {
      return "\(entity.quota.quota) Pengguna Per-hari"
    }
    
    if info.contains("WEEKLY") {
      return "\("\(entity.quota.quota) Pengguna Per-minggu")"
    }
    
    if info.contains("MONTHLY") {
      return "\(entity.quota.quota) Pengguna Per-bulan"
    }
    
    return "Kuota tidak tersedia"
  }
  
  public func getExpiredInfo() -> String {
    guard let date = entity.endDate.toDate() else { return "" }
    let dateStr = date.toString()
    return "Berlaku hingga: \(dateStr)"
  }
  
  public func isWithinTwoHours() -> Bool {
    guard let endDate = entity.endDate.toDateNew() else {
      return false
    }
    
    let (days, _, _) = convertToDayHourMinute(from: Date(), to: endDate)
    
    return days >= 0 && days <= 2
  }
  
  private func convertToDayHourMinute(
    from currentDate: Date,
    to futureDate: Date
  ) -> (days: Int, hours: Int, minutes: Int) {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day, .hour, .minute], from: currentDate, to: futureDate)
    return (
      days: components.day ?? 0,
      hours: components.hour ?? 0,
      minutes: components.minute ?? 0
    )
  }
  
  //MARK: - Navigator
  
  public func navigateToDashboard() {
    dashboardResponder.gotoDashboard()
  }
  
  public func navigateBack() {
    didBack.send(true)
  }
  
  public func navigateToListAdvocate() {
    advocateNavigator.navigateToListAdvocate(
      categoryAdvocate: "",
      listCategoryID: [],
      listSkillAdvocate: [],
      listingType: "",
      sktmModel: nil
    )
  }
  
  public func shareFacebook() {
    let urlString = "https://www.facebook.com/sharer/sharer.php?u=\(environment.shareURL)/promo/\(slug)&quote=\(entity.name)"
    let escapedShareString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    navigator.openLink(URL(string: escapedShareString))
  }
  
  public func shareTwitter() {
    let urlString = "https://twitter.com/intent/tweet?url=\(environment.shareURL)/promo/\(slug)&text=\(entity.name)"
    let escapedShareString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    navigator.openLink(URL(string: escapedShareString))
  }
  
  public func shareWhatsapp() {
    var urlString = "https://api.whatsapp.com/send?text=\(environment.shareURL)/promo/\(slug)"
    urlString = urlString.replacingOccurrences(of: " ", with: "%20")
    guard let url = URL(string: urlString) else { return }
    navigator.openLink(url)
  }
  
  public func copyLink() {
    let link = "\(environment.shareURL)/promo/\(slug)"
    UIPasteboard.general.string = link
  }
  
}

public protocol PromotionDetailStoreFactory {
  
  func makePromotionDetailStore(slug: String) -> PromotionDetailStore
  
}
