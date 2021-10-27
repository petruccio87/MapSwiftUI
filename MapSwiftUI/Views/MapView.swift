//
//  MapView.swift
//  MapSwiftUI
//
//  Created by admin on 19.10.2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    let landmarks : [Landmark]
    @State private var userTrackingMode: MKUserTrackingMode = .none
    
    var isUserTracking: Bool {
        get {
            if userTrackingMode == .follow || userTrackingMode == .followWithHeading {
                return true
            } else {
                return false
            }
        }
    }
    
    func toggleTrack() {
//        userTrackingMode = .follow
        if userTrackingMode == .follow {
            userTrackingMode = .none
        } else {
            userTrackingMode = .follow
        }
    }
    
    var body: some View {
        MyMKMapView(landmarks: landmarks, myuserTrackingMode: $userTrackingMode)
            .gesture(DragGesture().onChanged(){ _ in
                userTrackingMode = .none
            })
            .edgesIgnoringSafeArea(.all)
        VStack{
            Spacer()
            HStack{
                Spacer()
                VStack{
//                    CircleButton(iconName: "minus.circle") { map.zoomOut() }
//                    CircleButton(iconName: "plus.circle") { map.zoomIn() }
                    CircleButton(iconName: "location.circle") { toggleTrack() }
                        .opacity(isUserTracking ? 0.3 : 1)
                }.padding(.trailing, 20)
            }.padding(.bottom, 150)
        }
    }
}


struct MyMKMapView: UIViewRepresentable {
    
    struct Holder {
        var trackingUserLocation = true
    }
    let landmarks: [Landmark]
    @Binding var myuserTrackingMode: MKUserTrackingMode

    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        map.showsScale = true
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








struct CircleButton: View {
    var action: () -> Void
    var iconName: String
    
    init(iconName: String, _ action: @escaping () -> Void) {
        self.action = action
        self.iconName = iconName
    }
    
    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }) {
            Image(systemName: iconName)
        }
        .padding(10)
        .background(Color.black.opacity(0.75))
        .foregroundColor(.white)
        .font(.title)
        .clipShape(Circle())
    }
}
