//
//  HTMLNewWebView.swift
//  LearningCenter
//
//  Created by Ilham Prabawa on 23/04/25.
//

import SwiftUI
import WebKit

public struct HTMLNewWebView: UIViewRepresentable {
  let htmlContent: String
  @Binding var contentHeight: CGFloat
  
  public init(htmlContent: String, contentHeight: Binding<CGFloat>) {
    self.htmlContent = htmlContent
    self._contentHeight = contentHeight
  }
  
  public func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    webView.scrollView.isScrollEnabled = false
    webView.backgroundColor = .clear
    webView.isOpaque = false
    return webView
  }
  
  public func updateUIView(_ uiView: WKWebView, context: Context) {
    uiView.loadHTMLString(htmlContent, baseURL: nil)
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, WKNavigationDelegate {
    var parent: HTMLNewWebView
    
    public init(_ parent: HTMLNewWebView) {
      self.parent = parent
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      // Delay ensures fonts/images are fully loaded
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        webView.evaluateJavaScript("document.body.scrollHeight") { result, error in
          if let height = result as? NSNumber {
            self.parent.contentHeight = height.cgFloatValue
          }
        }
      }
    }
  }
  
}

// Helper to cast NSNumber to CGFloat
fileprivate extension NSNumber {
  var cgFloatValue: CGFloat {
    return CGFloat(truncating: self)
  }
}
