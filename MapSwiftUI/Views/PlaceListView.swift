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
    @State private var open = false
    @State private var isDragging = false
    @State private var transition: CGFloat = .zero


    private func calculateOffset() -> CGFloat {
        if isDragging {
            return transition
//            if self.open {
//                if transition > 0 {
//                    return 100 + transition
//                } else { return 100 }
//            } else {
//                if transition < 0 {
//                    return UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.height / 4 + transition
//                } else { return UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.height / 4 }
//            }
        } else {
            if self.landmarks.count > 0 && !self.open {
                return UIScreen.main.bounds.size.height - UIScreen.main.bounds.size.height / 4
            } else if self.open {
                return 100
            } else {
                return UIScreen.main.bounds.size.height
            }
        }
    }
    
    var body: some View {
        PlaceListView(landmarks: self.landmarks, onTap: {
            //onTap
            withAnimation {
                self.open.toggle()
            }
        }, onDrag: { value in
            isDragging = true
            self.transition = value.location.y
            var translation = value.translation.height
            print(transition)
            print("start drag")
            if translation < -100 {
                    print("drag to open")
                withAnimation {
                    self.open = true
                }
            }
            if translation > 100 {
                    print("drag to close")
                withAnimation {
                    self.open = false
                }
            }
        }, onDragEnd: { value in
            isDragging = false
            transition = .zero
            print("end drag")
        })
        .animation(.default)
        .offset(y: calculateOffset())
        
    }
}





struct PlaceListView: View {
    @Environment(\.colorScheme) var colorScheme
    var backgroundColor: Color { colorScheme == .dark ? Color.black : Color.gray }
    let cornerRadius: CGFloat = 10
    
    let landmarks: [Landmark]
    var onTap: () -> ()
    var onDrag: (DragGesture.Value) -> ()
    var onDragEnd: (DragGesture.Value) -> ()
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                EmptyView()
            }.frame(width: UIScreen.main.bounds.size.width, height: 60)
            .background(Color.gray)
            .gesture(TapGesture()
                        .onEnded(onTap))
            .gesture(DragGesture(coordinateSpace: .named("main")).onChanged(onDrag).onEnded(onDragEnd))
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
            }
        }.cornerRadius(cornerRadius)
        .background(RoundedRectangle(cornerRadius: cornerRadius).fill(backgroundColor))
    }
}

//struct PlaceListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceListView(landmarks: [Landmark(placemark: MKPlacemark())], onTap: {}, onDrag: {})
//    }
//}
