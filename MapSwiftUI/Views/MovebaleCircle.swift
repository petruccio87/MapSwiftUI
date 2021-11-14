//
//  MovebaleCircle.swift
//  MapSwiftUI
//
//  Created by admin on 13.11.2021.
//

import SwiftUI


struct MovebaleCircle: View {
@State private var drag: CGSize = .zero
@State private var color = Color.blue
var body: some View {
Circle()
     .frame(width: 120, height: 120, alignment: .center)
     .foregroundColor(color)
     .shadow(radius: 10)
     .animation(.default)
     .offset(drag)
.gesture(
DragGesture()
   .onChanged { value in
    self.drag = value.translation
    self.color = .red
       print(drag)
 }
   .onEnded({ _ in
     self.drag = .zero
     self.color = .orange
    }))
  }
}
