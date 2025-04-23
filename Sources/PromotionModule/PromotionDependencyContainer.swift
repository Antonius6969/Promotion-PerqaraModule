//
//  PromotionDependencyContainer.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import UIKit
import AprodhitKit
import GnDKit

public class PromotionDependencyContainer {
  
  let viewModel: PromotionViewModel
  public let mainViewModel: MainTabbarViewModel
  public let networkService: NetworkServiceLogic
  public let userSessionDataSource: UserSessionDataSourceLogic
  private let deepLink: PromotionDeepLink
  
  public init(
    mainViewModel: MainTabbarViewModel,
    networkService: NetworkServiceLogic,
    userSessionDataSource: UserSessionDataSourceLogic,
    deepLink: PromotionDeepLink = .init()
  ) {
    self.viewModel = PromotionViewModel()
    self.mainViewModel = mainViewModel
    self.networkService = networkService
    self.userSessionDataSource = userSessionDataSource
    self.deepLink = deepLink
  }
  
  //MARK: - Make View Controller
  
  public func makeViewController() -> PromotionContainerController {
    let promotionListsFactory = {
      self.makePromotionListViewController()
    }
    
    let detailFactory = { slug in
      return self.makePromotionDetailViewController(slug: slug)
    }
    
    let viewController = PromotionContainerController(
      viewModel: viewModel,
      promotionListsViewControllerFactory: promotionListsFactory,
      promotionDetailViewControllerFactory: detailFactory
    )
    
    if deepLink.isFromDeepLink {
      viewController.handleDeepLink(arguments: ["slug" : deepLink.slug])
    }
    
    return viewController
  }
  
  private func makePromotionListViewController() -> PromotionListsViewController {
    return PromotionListsViewController(storeFactory: self)
  }
  
  private func makePromotionDetailViewController(slug: String) -> PromotionDetailViewController {
    return PromotionDetailViewController(storeFactory: self, slug: slug)
  }
  
  //MARK: - Make Store
  
  public func makePromotionListsStore() -> PromotionListsStore {
    func makeRemote() -> PromotionRemoteDataSourceLogic {
      return PromotionRemoteDataSourceImpl(service: networkService)
    }
    
    func makeRepository() -> PromotionRepositoryLogic {
      return PromotionRepositoryImpl(remote: makeRemote())
    }
    
    return PromotionListsStore(
      promotionRepository: makeRepository(),
      promotionNavigator: viewModel
    )
  }
  
  public func makePromotionDetailStore(slug: String) -> PromotionDetailStore {
    func makeRemoteDataSource() -> PromotionDetailRemoteDataSourceLogic {
      return PromotionDetailRemoteDataSourceImpl(service: networkService)
    }
    
    func makeRepository() -> PromotionDetailRepositoryLogic {
      return PromotionDetailRepositoryImpl(remote: makeRemoteDataSource())
    }
    
    func makePromotionListRemoteDataSource() -> PromotionRemoteDataSourceLogic {
      return PromotionRemoteDataSourceImpl(service: networkService)
    }
    
    func makePromotionListRepository() -> PromotionRepositoryLogic {
      return PromotionRepositoryImpl(remote: makePromotionListRemoteDataSource())
    }
    
    return PromotionDetailStore(
      slug: slug,
      userSessionDataSource: userSessionDataSource,
      repository: makePromotionListRepository(),
      detailRepository: makeRepository(),
      dashboardResponder: mainViewModel,
      navigator: viewModel,
      advocateNavigator: mainViewModel
    )
  }
  
}

extension PromotionDependencyContainer: PromotionListsStoreFactory,
                                        PromotionDetailStoreFactory {
  
}
