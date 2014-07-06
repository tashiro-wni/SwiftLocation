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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView :MKMapView
    
    var locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 500
        if( locationManager.respondsToSelector(Selector("requestWhenInUseAuthorization")) ){
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestAlwaysAuthorization()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
// CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var str: String
        switch(status){
            case .NotDetermined:       str = "NotDetermined"
            case .Restricted:          str = "Restricted"
            case .Denied:              str = "Denied"
            case .Authorized:          str = "Authorized"
            case .AuthorizedWhenInUse: str = "AuthorizedWhenInUse"
        }
        println("locationManager auth status changed, \(str)")
            
        if( status == .Authorized || status == .AuthorizedWhenInUse ) {
            locationManager.startUpdatingLocation()
            println("startUpdatingLocation")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: AnyObject[]!) {
        println("found \(locations.count) placemarks.")
        if( locations.count > 0 ){
            let location = locations[0] as CLLocation;
            let region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.01,0.01))
            self.mapView.setRegion(region, animated:true)  // Zoom to Current Location.
        
            locationManager.stopUpdatingLocation()
            println("location updated, lat:\(location.coordinate.latitude), lon:\(location.coordinate.longitude), stop updating.")
        
            // reverse geocoding
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
                println("found \(placemarks.count) placemarks.")
                if( placemarks.count > 0 ) {
                    let placemark = placemarks[0] as CLPlacemark
                    println("placemark:\(placemark.locality), \(placemark.subLocality)")  // ex. Shibuya, Dogenzaka
            
                    let point = MKPointAnnotation()
                    point.coordinate = location.coordinate
                    point.title = "I'm here"
                    point.subtitle = "\(placemark.locality), \(placemark.subLocality)"
                    self.mapView.addAnnotation(point)
                }
            })
        }
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("location didFailWithError, \(error)")
    }

}

