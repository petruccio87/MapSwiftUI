//
//  PlaceListView.swift
//  MapSwiftUI
//
//  Created by admin on 27.10.2021.
//

import SwiftUI
import MapKit

struct PlaceListView: View {
    
    let landmarks: [Landmark]
    var onTap: () -> ()
    var onDrag: () -> ()
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                EmptyView()
            }.frame(width: UIScreen.main.bounds.size.width, height: 60)
            .background(Color.gray)
            .gesture(TapGesture()
                        .onEnded(onTap))
            List{
                //ForEach( landmarks, id: \.id) { landmark in -> makes list always scroll to top themself
                ForEach( landmarks, id: \.self) { landmark in
                    VStack(alignment: .leading) {
                        Text(landmark.name)
                            .fontWeight(.bold)
                        Text(landmark.title)
                    }.onTapGesture {
                        print(landmark.name, landmark.id)
                    }
                }
            }.animation(nil)
        }.cornerRadius(10)
    }
}

struct PlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceListView(landmarks: [Landmark(placemark: MKPlacemark())], onTap: {}, onDrag: {})
    }
}
