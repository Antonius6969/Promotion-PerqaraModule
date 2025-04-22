//
//  PromotionDayRemainingView.swift
//  PromotionModule
//
//  Created by Ilham Prabawa on 18/04/25.
//

import SwiftUI

typealias DateTimeRemainings = (Int, Int, Int)

struct PromotionDayRemainingView: View {
  
  @State var timeRemaining: TimeInterval = 0
  var endDate: String
  
  let timer = Timer.publish(
    every: 1,
    on: .main,
    in: .common
  ).autoconnect()
  
  @State var dates: DateTimeRemainings = (0, 0, 0)
  
  var body: some View {
    VStack {
      Text("Akan berakhir")
        .foregroundStyle(Color.white)
        .titleLexend(size: 12)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      Text("\(timeRemaining)")
      
      HStack {
        HStack {
          Text(dayRemaining(from: timeRemaining))
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
        
        HStack {
          Text(hourRemaining(from: timeRemaining))
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
        
        HStack {
          Text(minutesRemaining(from: timeRemaining))
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
        .stroke(
          Color.gray100,
          lineWidth: 1
        )
    )
    .onAppear {
      dateToTimeInterval()
    }
    onReceive(timer) { _ in
      receiveTimer()
    }
  }
  
  public func showRemainingDateTime(_ timeInterval: TimeInterval) -> DateTimeRemainings {
    return convertToDayHourMinute(from: timeInterval)
  }
  
  private func convertToDayHourMinute(
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
  
  private func convertToDayHourMinute(
    from timeInterval: TimeInterval
  ) -> (days: Int, hours: Int, minutes: Int) {
      let calendar = Calendar.current
      let now = Date()
      let futureDate = now.addingTimeInterval(-timeInterval)

      let components = calendar.dateComponents([.day, .hour, .minute], from: now, to: futureDate)
      return (
          days: components.day ?? 0,
          hours: components.hour ?? 0,
          minutes: components.minute ?? 0
      )
  }
  
  private func dayRemaining(from timeInterval: TimeInterval) -> String {
    let calendar = Calendar.current
    let now = Date()
    let futureDate = now.addingTimeInterval(timeInterval)

    let components = calendar.dateComponents([.day], from: now, to: futureDate)
    return "\(components.day ?? 0) Hari"
  }
  
  private func hourRemaining(from timeInterval: TimeInterval) -> String {
    let calendar = Calendar.current
    let now = Date()
    let futureDate = now.addingTimeInterval(timeInterval)

    let components = calendar.dateComponents([.hour], from: now, to: futureDate)
    return "\(components.hour ?? 0) Jam"
  }
  
  private func minutesRemaining(from timeInterval: TimeInterval) -> String {
    let calendar = Calendar.current
    let now = Date()
    let futureDate = now.addingTimeInterval(timeInterval)

    let components = calendar.dateComponents(
      [.day, .hour, .minute],
      from: now,
      to: futureDate
    )
    return "\(components.minute ?? 0) Menit"
  }
  
  private func dateToTimeInterval() {
    let date = endDate.toDate()
    let timeInterval = Date().timeIntervalSince(date!)
    timeRemaining = -timeInterval
  }
  
  private func receiveTimer() {
    if timeRemaining > 0 {
      timeRemaining -= 1
    } else {
      timeRemaining = 0
      timer.upstream.connect().cancel()
    }
  }
  
}

#Preview {
  PromotionDayRemainingView(endDate: "2025-04-23T00:00:00.000Z")
}
