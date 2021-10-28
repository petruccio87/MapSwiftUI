//
//  PlaceListView.swift
//  MapSwiftUI
//
//  Created by admin on 27.10.2021.
//

import SwiftUI
import MapKit

struct PlaceList: View {
    let landmarks: [Landmark]
    @State private var tapped = false


    private func calculateOffset() -> CGFloat {
        if self.landmarks.count > 0 && !self.tapped {
            return UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.height / 4
        } else if self.tapped {
            return 100
        } else {
            return UIScreen.main.bounds.size.height
        }
    }
    
    var body: some View {
        PlaceListView(landmarks: self.landmarks, onTap: {
            //onTap
            self.tapped.toggle()
        }) { value in
            //onDrag
            if value.location.y < -100 {
//                    print("drag to open")
                self.tapped = true
            }
            if value.location.y > 100 {
//                    print("drag to close")
                self.tapped = false
            }
        }
        .animation(.spring())
        .offset(y: calculateOffset())    }
}

struct PlaceListView: View {
    @Environment(\.colorScheme) var colorScheme
    var backgroundColor: Color { colorScheme == .dark ? Color.black : Color.gray }
    let cornerRadius: CGFloat = 10
    
    let landmarks: [Landmark]
    var onTap: () -> ()
    var onDrag: (DragGesture.Value) -> ()
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                EmptyView()
            }.frame(width: UIScreen.main.bounds.size.width, height: 60)
            .background(Color.gray)
            .gesture(TapGesture()
                        .onEnded(onTap))
            .gesture(DragGesture().onChanged(onDrag))
            List{
                //ForEach( landmarks, id: \.id) { landmark in -> makes list always scroll to top themself
                ForEach( landmarks, id: \.self) { landmark in
                    VStack(alignment: .leading) {
                        Text(landmark.name)
                            .fontWeight(.bold)
                        Text(landmark.title)
                    }
                    .onTapGesture {
                        print(landmark.name, landmark.id)
                    }
                }
            }.animation(nil)
        }.cornerRadius(cornerRadius)
        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(backgroundColor))
    }
}

//struct PlaceListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceListView(landmarks: [Landmark(placemark: MKPlacemark())], onTap: {}, onDrag: {})
//    }
//}
