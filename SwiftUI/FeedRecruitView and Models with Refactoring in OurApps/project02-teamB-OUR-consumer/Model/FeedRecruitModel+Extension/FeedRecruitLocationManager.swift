//
//  FeedRecruitViewModel.swift
//  project02-teamB-OUR-consumer
//
//  Created by kaikim on 2023/08/23.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

final class FeedRecruitLocationManager: NSObject, ObservableObject {
    
    @Published var userLocation: CLLocation?
    private let manager = CLLocationManager()
    static let shared = FeedRecruitLocationManager()
    
    override private init() {//다른 곳에서 활용 못하게 private 설정하기
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
}

extension FeedRecruitLocationManager: CLLocationManagerDelegate {
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("DEBUG: Not Determined")
        case .restricted:
            print("DEBUG: Restricted")
        case .denied:
            print("DEBUG: Denied")
        case .authorizedAlways:
            print("DEBUG: Auth always")
        case .authorizedWhenInUse:
            print("DEBUG: AUTH when in use")
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return}
        self.userLocation = location
    }
    
    func convertLocationToAddress(location: CLLocation) async throws -> String {
        
        var convertedLocationString:String = ""
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ko_KR")
        let data = try await geocoder.reverseGeocodeLocation(location, preferredLocale: locale)
        convertedLocationString = "\(data.first?.country ?? ""), \(data.first?.locality ?? ""), \(data.first?.name ?? "")"
        return convertedLocationString
        
    }
}


