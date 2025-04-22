//
//  PromotionDetailRemoteTests.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 17/04/25.
//

import XCTest
@testable import PromotionModule
import AprodhitKit
import GnDKit

final class PromotionDetailRemoteTests: XCTestCase {
  
  func test_fetchPromotionLists_fromLocalJson_shouldReturnSuccess() async throws {
    //given
    var model: PromotionListModel? = nil
    let service = MockNetworkService()
    
    //when
    do {
      service.mockData = try loadJSONFromFile(filename: "promotion_response_lists", inBundle: .module)
      guard let data = service.mockData else { return }
      model = try JSONDecoder().decode(PromotionListModel.self, from: data)
      
    } catch {}
    
    //then
    XCTAssertEqual(model?.data?[0].code, "PERQARACODE")
  }
  
}
