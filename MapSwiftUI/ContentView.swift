//
//  ContentView.swift
//  MapSwiftUI
//
//  Created by admin on 19.10.2021.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject private var locationManager = LocationManager()
    @State private var search: String  = ""
    @State private var landmarks = [Landmark]()
    @State private var tapped = false
    
    private func getNearByLandmarks() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        
        let search = MKLocalSearch(request: request)
        search.start { (responce, error) in
            if let responce = responce {
                let mapItems = responce.mapItems
                self.landmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
            }
        }
    }
    
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
        
        let coordinate = self.locationManager.location != nil ?
            self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        ZStack(alignment: .top) {
            MapView(landmarks: landmarks)
            
            TextField("Search", text: $search, onEditingChanged: { _ in })
            {
                self.getNearByLandmarks()
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .offset(y: 44)
            
            PlaceListView(landmarks: self.landmarks, onTap: {
                //onTap
                self.tapped.toggle()
            }) {
                //onDrag
            }.gesture(DragGesture().onEnded() { value in
                if value.location.y < -100 {
//                    print("drag to open")
                    self.tapped = true
                }
                if value.location.y > 100 {
//                    print("drag to close")
                    self.tapped = false
                }
            })
            .animation(.spring())
            .offset(y: calculateOffset())
//            Text("\(coordinate.latitude), \(coordinate.longitude)")
//                .foregroundColor(.white)
//                .padding()
//                .background(Color.green)
//                .cornerRadius(10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
