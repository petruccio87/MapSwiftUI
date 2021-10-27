//
//  MapView.swift
//  MapSwiftUI
//
//  Created by admin on 19.10.2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    struct Holder {
        var trackingUserLocation = true
    }
    let landmarks: [Landmark]
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        return map
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        updateAnnotations(from: mapView)
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = landmarks.map(LandmarkAnnotation.init)
        mapView.addAnnotations(annotations)
    }
}


