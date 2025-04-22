//
//  PromotionDetailViewController.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 16/04/25.
//

import Foundation
import GnDKit
import AprodhitKit
import SwiftUI
import Combine

public class PromotionDetailViewController: NiblessViewController {
  
  private let store: PromotionDetailStore
  
  private var subscriptions = Set<AnyCancellable>()
  
  public init(storeFactory: PromotionDetailStoreFactory, slug: String) {
    self.store = storeFactory.makePromotionDetailStore(slug: slug)
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
  
  public override func loadView() {
    super.loadView()
    
    let rootView = UIHostingController(rootView: PromotionDetailView(store: store))
    addFullScreen(childViewController: rootView)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    standardNavBar(title: "Detail Promosi")
    
    observeStore()
  }
  
  private func observeStore() {
    store.didBack
      .receive(on: DispatchQueue.main)
      .subscribe(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      }.store(in: &subscriptions)
  }
  
  deinit {
    print("deinit \(String(describing: PromotionDetailViewController.self))")
  }
  
}
