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

public class PromotionDetailStore: ObservableObject {
  
  public typealias DateTimeRemainings = (Int, Int, Int)
  
  private let slug: String
  private let userSessionDataSource: UserSessionDataSourceLogic
  private let repository: PromotionDetailRepositoryLogic
  private let dashboardResponder: DashboardResponder
  
  public var didBack = PassthroughSubject<Bool, Never>()
  
  @Published public var entity: PromotionEntity = .init()
  @Published public var isExpired: Bool = false
  private var userSessionData: UserSessionData? = nil
  
  public init(
    slug: String,
    userSessionDataSource: UserSessionDataSourceLogic,
    repository: PromotionDetailRepositoryLogic,
    dashboardResponder: DashboardResponder
  ) {
    self.slug = slug
    self.userSessionDataSource = userSessionDataSource
    self.repository = repository
    self.dashboardResponder = dashboardResponder
  }
  
  //MARK: - API
  
  @MainActor
  public func fetchPromotionDetail() async {
    do {
      entity = try await repository.fetchPromotionDetail(
        headers: HeaderRequest(token: userSessionData?.remoteSession.remoteToken),
        parameters: PromotionDetailParamRequest(slug: slug)
      )
      
      isExpired = entity.status == .EXPIRED
      
    } catch {
      guard let error = error as? ErrorMessage
      else { return }
      
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
  
  public func getHTMlText() -> String {
    return """
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Lexend:wght@300;400;500;700;800&display=swap" rel="stylesheet">
          <style>
              body {
                  font-family: 'Lexend', sans-serif;
                  font-size: 14px;
                  font-weight: 300;
                  line-height: 1.6;
                  marging: 0;
                  padding: 0;
              }
              ol {
                display: block;
                list-style-type: decimal;
                margin-top: 1em;
                margin-bottom: 1em;
                margin-left: 0;
                margin-right: 0;
                padding-left: 20px;
              }
          </style>
      </head>
      <body>
        <p>ini syarat dan ketentuan</p>
      </body>
      </html>
    """
  }
  
  public func getUsageInfo() -> String {
    var result: String = ""
    let info = entity.quota.time
    if info.contains("DAILY") {
      result = "\(entity.quota.quota) Pengguna Per-hari"
    } else if info.contains("MONTHLY") {
      result = "\(entity.quota.quota) Pengguna Per-bulan"
    }
    
    return result
  }
  
  public func getExpiredInfo() -> String {
    guard let date = entity.endDate.toDate() else { return "" }
    let dateStr = date.toString()
    return "Berlaku hingga: \(dateStr)"
  }
  
  public func isWithinTwoHours() -> Bool {
    guard let endDate = entity.endDate.toDateNew(),
          let startDate = entity.startDate.toDateNew() else {
      return false
    }
    
    let (days, _, _) = convertToDayHourMinute(from: startDate, to: endDate)
    
    return days > 0 && days <= 2
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
}

public protocol PromotionDetailStoreFactory {
  
  func makePromotionDetailStore(slug: String) -> PromotionDetailStore
  
}
