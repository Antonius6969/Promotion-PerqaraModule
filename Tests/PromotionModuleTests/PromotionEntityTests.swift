//
//  PromotionEntityTests.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 17/04/25.
//

import XCTest
@testable import PromotionModule
import AprodhitKit
import GnDKit

final class PromotionEntityTests: XCTestCase {
  
  var sut: PromotionEntity!
  
  private func createSUT() {
    sut = PromotionEntity(
      name: "Voucher",
      slug: "kode-voucher-1-11042025",
      imageURL: nil,
      startDate: "2024-10-23T00:00:00.000Z",
      endDate: "2025-10-23T00:00:00.000Z",
      description: "deskripsi kode voucher",
      tnc: "<p>ini syarat dan ketentuan</p>",
      platform: ["WEB", "IOS", "ANDROID"],
      quota: .init(total: 10, time: "MAX_QUOTA_DAILY", quota: 2),
      status: .ACTIVE
    )
  }
  
  func test_getDateWithFormatted_shouldReturnFormattedString() {
    // Given
    let inputDateString = "2024-10-01T00:00:00.000Z"
    let expectedFormattedString = "1 Oktober 2024"
    
    // When
    let date = inputDateString.toDate()
    let formattedString = date?.toString()
    
    // Then
    XCTAssertEqual(formattedString, expectedFormattedString)
  }
  
  func test_getDescription_shouldSuccess() {
    //given
    var description: String? = nil
    
    //when
    createSUT()
    
    description = sut.description
    
    //then
    XCTAssertNotNil(description)
  }
  
  func test_getTnc_shouldSuccess() {
    //given
    var tnc: String? = nil
    
    //when
    createSUT()
    
    tnc = sut.tnc
    
    //then
    XCTAssertNotNil(tnc)
  }
  
  func test_getPlatform_shouldSuccess() {
    //given
    var platform: [String]? = nil
    
    //when
    createSUT()
    
    platform = sut.platform
    
    //then
    XCTAssertNotNil(platform)
    XCTAssertEqual(platform?.count, 3)
  }
  
  func test_getQuota_shouldSuccess() {
    //given
    var quota: PromotionQuotaEntity = .init(total: 0, time: "", quota: 0)
    
    //when
    createSUT()
    
    quota = sut.quota
    
    //then
    XCTAssertEqual(quota.total, 10)
    XCTAssertEqual(quota.quota, 2)
    XCTAssertEqual(quota.time, "MAX_QUOTA_DAILY")
  }
  
  func test_getPromotionStatus_shouldSuccess() {
    //given
    var status: PromotionStatus = .EXPIRED
    
    //when
    createSUT()
    status = sut.status
    
    //then
    XCTAssertEqual(status, .ACTIVE)
  }
  
  func test_convertToTimeInterval() {
    //given
    var timeInterval: TimeInterval = 0
    createSUT()
    
    //when
    let date = sut.endDate.toDate()
    timeInterval = Date().timeIntervalSince(date!)
    
    //then
    XCTAssertTrue(timeInterval != 0)
  }
  
  func test_convertToDayHourMinute_shouldReturnCorrectComponents() {
    // Given
    let nowDateString = "2025-10-21T00:00:00.000Z"
    let endDateString = "2025-10-23T00:00:00.000Z"
    
    let nowDate = nowDateString.toDateNew()!
    let endDate = endDateString.toDateNew()!
    
    // When
    let (days, hours, minutes) = convertToDayHourMinute(from: nowDate, to: endDate)
    
    // Then
    XCTAssertEqual(days, 2)
    XCTAssertEqual(hours, 0)
    XCTAssertEqual(minutes, 0)
  }
  
  func test_isLessThanTwoHoursAway_withStaticDateString_comparedToNow() {
    // Given
    let dateString = "2025-04-20T08:56:00.000Z"
    
    guard let endDate = dateString.toDateNew() else {
      XCTFail("Could not parse date string")
      return
    }
    
    //When
    let (days, _, _) = convertToDayHourMinute(from: Date(), to: endDate)
    
    // Then
    XCTAssertTrue(days <= 2)
  }
  
  func convertToDayHourMinute(
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
  
}
