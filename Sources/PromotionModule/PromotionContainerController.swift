//
//  PromotionContainerController.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import UIKit
import AprodhitKit
import GnDKit
import Combine

public class PromotionContainerController: NiblessViewController {
  
  private let viewModel: PromotionViewModel
  
  let makePromotionListsViewController: () -> PromotionListsViewController
  let makePromotionDetailViewController: (String) -> PromotionDetailViewController
  
  var promotionListViewController: PromotionListsViewController?
  var promotionDetailViewController: PromotionDetailViewController?
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init(
    viewModel: PromotionViewModel,
    promotionListsViewControllerFactory: @escaping () -> PromotionListsViewController,
    promotionDetailViewControllerFactory: @escaping(String) -> PromotionDetailViewController
  ) {
    
    self.viewModel = viewModel
    self.makePromotionListsViewController = promotionListsViewControllerFactory
    self.makePromotionDetailViewController = promotionDetailViewControllerFactory
    
    super.init()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    observeViewModel()
  }
  
  private func subscribe(to publisher: AnyPublisher<PromotionViewState, Never>) {
    publisher
      .sink { [weak self] view in
        self?.present(view)
      }.store(in: &subscriptions)
  }
  
  private func present(_ view: PromotionViewState) {
    switch view {
    case .main:
      presentMain()
    case .detail(let slug):
      presentDetail(slug)
    case .openLink(let url):
      openLink(url)
    }
  }
  
  private func presentMain() {
    let listVC = makePromotionListsViewController()
    addFullScreen(childViewController: listVC)
  }
  
  private func presentDetail(_ slug: String) {
    let detailVC = makePromotionDetailViewController(slug)
    navigationController?.pushViewController(detailVC, animated: true)
  }
  
  private func openLink(_ url: URL?) {
    guard let url = url else { return }
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.openURL(url)
    }
  }
  
  private func observeViewModel() {
    let publisher = viewModel.$view.eraseToAnyPublisher()
    subscribe(to: publisher)
  }
  
  public func handleDeepLink(arguments: [String : Any]) {
    if let slug = arguments["slug"] as? String {
      viewModel.view = .detail(slug: slug)
    }
  }
  
}
