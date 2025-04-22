//
//  PromotionListsViewController.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import GnDKit
import AprodhitKit
import SwiftUI
import Combine

public class PromotionListsViewController: NiblessViewController {
  
  private let store: PromotionListsStore
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init(storeFactory: PromotionListsStoreFactory) {
    self.store = storeFactory.makePromotionListsStore()
    
    super.init()
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  public override func loadView() {
    super.loadView()
    
    let rootViewController = UIHostingController(rootView: PromotionListsView(store: store))
    addFullScreen(childViewController: rootViewController)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    standardNavBar(title: "Promo Perqara")
    
    observeStore()
  }
  
  private func observeStore() {
    store.didBack
      .receive(on: DispatchQueue.main)
      .subscribe(on: DispatchQueue.main)
      .sink { _ in
        self.navigationController?.popViewController(animated: true)
      }.store(in: &subscriptions)
  }
  
}
