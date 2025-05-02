//
//  PromotionDetailView.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 17/04/25.
//

import SwiftUI
import AprodhitKit
import GnDKit
import Kingfisher

public struct PromotionDetailView: View {
  
  @ObservedObject var store: PromotionDetailStore
  @State var webContentHeight: CGFloat = .zero
  
  public var body: some View {
    ZStack {
      GeometryReader { proxy in
        let frame = proxy.frame(in: .local)
        
        StandardHeaderView(title: store.getTitlePromo()) {
          store.navigateBack()
        }
        .background(Color.white)
        .position(x: frame.midX, y: frame.minY + 20)
      }
      
      VStack {
        if store.showFailedView {
          failedView()
        } else {
          contentView()
            .padding(.top, 56)
        }
        
      }
      .task {
        await store.fetchPromotionLists()
        await store.fetchPromotionDetail()
      }
    }
    
  }
  
  @ViewBuilder
  func contentView() -> some View {
    VStack {
      ScrollView(showsIndicators: false) {
        VStack(spacing: 16) {
          KFImage
            .url(store.entity.imageURL)
            .placeholder {
              PlaceholderImageView(name: "")
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: 180)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
              RoundedRectangle(cornerRadius: 8)
                .stroke(
                  Color.gray100,
                  lineWidth: 1
                )
            )
          
          if store.isWithinTwoHours() {
            PromotionDayRemainingView(endDate: store.entity.endDate)
          }
          
          Text(store.entity.name)
            .titleLexend(size: 20)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          HStack {
            Text("Bagikan:")
              .foregroundStyle(Color.gray500)
              .captionLexend(size: 14)
            
            Button {
              store.shareFacebook()
            } label: {
              Image("ic_facebook", bundle: .module)
            }
            
            Button {
              store.shareTwitter()
            } label: {
              Image("ic_twitter", bundle: .module)
            }
            
            Button {
              store.shareWhatsapp()
            } label: {
              Image("ic_whatsapp", bundle: .module)
            }
            
            Button {
              store.copyLink()
            } label: {
              Image("ic_copy_link", bundle: .module)
            }
            
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          
          Text(store.entity.description)
            .foregroundStyle(Color.gray500)
            .captionLexend(size: 14)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Divider()
            .frame(maxWidth: .infinity, maxHeight: 1)
          
          VStack(alignment: .leading, spacing: 8) {
            Text("Periode Promo")
              .titleLexend(size: 12)
            
            Text(store.entity.getDateString())
              .foregroundStyle(Color.gray500)
              .captionLexend(size: 14)
              .padding(.bottom, 8)
            
            Text("Platform")
              .titleLexend(size: 12)
            
            Text(store.getPlatform())
              .foregroundStyle(Color.gray500)
              .captionLexend(size: 14)
              .padding(.bottom, 8)
            
            Text("Kuota")
              .titleLexend(size: 12)
            
            Text(store.getUsageInfo())
              .foregroundStyle(Color.gray500)
              .captionLexend(size: 14)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          
          Divider()
            .frame(maxWidth: .infinity, maxHeight: 1)
          
          VStack(alignment: .leading) {
            Text("Syarat dan Ketentuan")
              .titleLexend(size: 12)
            
            HTMLNewWebView(
              htmlContent: store.entity.tnc.wrappedInHTML,
              contentHeight: $webContentHeight
            )
            .frame(height: webContentHeight)
          }
        }
        .padding(.horizontal, 16)
      }
      
      HStack {
        Text(store.getExpiredInfo())
          .foregroundStyle(Color.gray500)
          .captionLexend(size: 12)
        
        Spacer()
        
        ButtonPrimary(
          title: "Pakai",
          color: .buttonActiveColor,
          width: 58,
          height: 40
        ) {
          store.navigateToListAdvocate()
        }
      }
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity)
    }
  }
  
  @ViewBuilder
  func failedView() -> some View {
    VStack(spacing: 0) {
      Image(store.imageErrorName, bundle: .module)
      
      Text(store.failureTitle)
        .titleLexend(size: 20)
        .padding(.bottom, 16)
      
      Text(store.failureDescription)
        .foregroundStyle(Color.gray500)
        .captionLexend(size: 14)
        .multilineTextAlignment(.center)
        .padding(.bottom, 32)
      
      if store.showButtonPromotionLists {
        ButtonPrimary(
          title: "Lihat Promo yang Tersedia",
          color: .buttonActiveColor,
          width: .infinity,
          height: 48
        ) {
          store.navigateBack()
        }
        .padding(.bottom, 12)
      }
      
      ButtonSecondary(
        title: "Kembali Ke Beranda",
        backgroundColor: .clear,
        tintColor: .buttonActiveColor,
        width: .infinity,
        height: 48
      ) {
        store.navigateToDashboard()
      }
    }
    .padding(.horizontal, 32)
  }
  
}

#Preview {
  PromotionDetailView(
    store: PromotionDetailStore(
      slug: "",
      userSessionDataSource: MockUserSessionDataSource(),
      repository: MockPromotionRepository(),
      detailRepository: MockPromotionDetailRepository(),
      dashboardResponder: MockNavigator(),
      navigator: MockNavigator(),
      advocateNavigator: MockNavigator()
    )
  )
}
