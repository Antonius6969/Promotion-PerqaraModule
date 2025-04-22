//
//  PromotionRemoteDataSourceTests.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import XCTest
@testable import PromotionModule
import AprodhitKit
import GnDKit

final class PromotionRemoteDataSourceTests: XCTestCase {
  
  var sut: PromotionRemoteDataSourceLogic!
  
  func test_fetchPromotionLists_fromLocalJson_shouldReturnSuccess() async throws {
    //given
    var model: PromotionListModel? = nil
    let service = MockNetworkService()

    //when
    do {
      service.mockData = try loadJSONFromFile(filename: "promotion_response_lists", inBundle: .module)
      guard let data = service.mockData else { return }
      model = try JSONDecoder().decode(PromotionListModel.self, from: data)
      
    } catch {
      
    }

    //then
    XCTAssertEqual(model?.success, true)
  }
  
  func test_fetchPromotionLists_fromLocalJson_shouldReturnFailure() async throws {
    //given
    var nError: NetworkErrorMessage? = nil
    let service = MockNetworkService()

    //when
    do {
      service.mockData = try loadJSONFromFile(filename: "promotion_response", inBundle: .module)
    } catch {
      guard let error = error as? NetworkErrorMessage else { return }
      service.mockError = error
      nError = error
    }

    //then
    XCTAssertEqual(nError?.code, -3)
  }
  
}
