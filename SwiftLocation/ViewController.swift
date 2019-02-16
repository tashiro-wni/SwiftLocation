//
//  ViewController.swift
//  SwiftLocation
//
//  Created by Tomohiro Tashiro on 2014/7/1.
//  Copyright (c) 2014 test. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 500
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        locationManager.stopUpdatingLocation()
        mapView.setCenter(location.coordinate, animated: true)

        // reverse geocoding
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            
            let text = placemark.locality ?? ""
            
            let point = MKPointAnnotation()
            point.coordinate = location.coordinate
            point.title = "I'm here"
            point.subtitle = text
            self?.mapView.addAnnotation(point)
        })
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
}

