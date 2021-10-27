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
    
    private func getNearByLandmarks() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        
        let search = MKLocalSearch(request: request)
        search.start { (responce, error) in
            if let responce = responce {
                let mapItems = responce.mapItems
                landmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
            }
        }
    }
    
    var body: some View {
        
        let coordinate = self.locationManager.location != nil ?
            self.locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        ZStack(alignment: .top) {
            MapView()
            TextField("Search", text: $search, onEditingChanged: { _ in })
            {
                //commit
            }.textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .offset(y: 44)
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
