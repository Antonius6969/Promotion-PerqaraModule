//
//  PromotionDayRemainingView.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 18/04/25.
//

import SwiftUI

typealias DateTimeRemainings = (days: Int, hours: Int, minutes: Int)

struct PromotionDayRemainingView: View {
  
  @State private var timeRemaining: TimeInterval = 0
  @State private var timer: Timer?
  
  var endDate: String
  
  var body: some View {
    VStack {
      Text("Akan berakhir")
        .foregroundStyle(Color.white)
        .titleLexend(size: 12)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack {
        // Hari
        HStack {
          Text("\(dates.days) Hari")
            .titleLexend(size: 12)
        }
        .padding(.all, 8)
        .padding(.horizontal, 4)
        .background(Color.danger100)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
        Spacer()
        
        Text(":")
          .foregroundStyle(Color.danger100)
          .titleLexend(size: 14)
        
        Spacer()
        
        // Jam
        HStack {
          Text("\(dates.hours) Jam")
            .titleLexend(size: 12)
        }
        .padding(.all, 8)
        .padding(.horizontal, 4)
        .background(Color.danger100)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
        Spacer()
        
        Text(":")
          .foregroundStyle(Color.danger100)
          .titleLexend(size: 14)
        
        Spacer()
        
        // Menit
        HStack {
          Text("\(dates.minutes) Menit")
            .titleLexend(size: 12)
        }
        .padding(.all, 8)
        .padding(.horizontal, 4)
        .background(Color.danger100)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      .padding(.bottom, 8)
      
    }
    .padding(.top, 4)
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity, minHeight: 66, alignment: .center)
    .background(
      LinearGradient(
        colors: [Color(hex: 0xFA4D56), Color(hex: 0xFFC3C7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    )
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color.gray100, lineWidth: 1)
    )
    .onAppear {
      initializeTimer()
    }
    .onDisappear {
      timer?.invalidate()
    }
  }
  
  @State private var dates: DateTimeRemainings = (0, 0, 0)
  
  private func initializeTimer() {
    guard let end = endDate.toDate() else {
      print("Invalid date format.")
      return
    }
    
    let interval = end.timeIntervalSinceNow
    if interval > 0 {
      timeRemaining = interval
      updateDates(from: timeRemaining)
      
      timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
        DispatchQueue.main.async {
          if timeRemaining > 0 {
            timeRemaining -= 1
            updateDates(from: timeRemaining)
          } else {
            timeRemaining = 0
            timer?.invalidate()
          }
        }
      }
    }
  }
  
  private func updateDates(from time: TimeInterval) {
    let calendar = Calendar.current
    let now = Date()
    let futureDate = now.addingTimeInterval(time)
    let components = calendar.dateComponents([.day, .hour, .minute], from: now, to: futureDate)
    
    dates = (
      components.day ?? 0,
      components.hour ?? 0,
      components.minute ?? 0
    )
  }
}


#Preview {
  PromotionDayRemainingView(endDate: "2025-04-23T00:00:00.000Z")
}
