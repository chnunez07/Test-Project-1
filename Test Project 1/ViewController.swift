//
//  ViewController.swift
//  Test Project 1
//
//  Created by Chris on 11/21/16.
//  Copyright © 2016 CHN. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var coreLocationManager = CLLocationManager()
    var locationManager: LocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentInformation: UILabel!
    @IBAction func updateLocation(_ sender: UIButton) {
    }
 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        coreLocationManager.delegate = self
        locationManager = LocationManager.sharedInstance
        
        let authorizationCode = CLLocationManager.authorizationStatus()
        
        if authorizationCode == CLAuthorizationStatus.notDetermined && coreLocationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) || coreLocationManager.responds(to: Selector(("requestWhenInUseAuthroization")))
        {
            if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil {
                coreLocationManager.requestAlwaysAuthorization()
            }
            else {
                print("No description provided")
            }
        }
        else {
            getLocation()
        }
        
        }
    

func getLocation()
    {
    locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in self.displayLocation(location: CLLocation(latitude: latitude, longitude: longitude))
        }
    }

    func displayLocation(location: CLLocation)
    {
    
       mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        let locationPinCoord = CLLocationCoordinate2DMake(location.coordinate.longitude, location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoord
        
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        locationManager.reverseGeocodeLocationWithCoordinates(location, onReverseGeocodingCompletionHandler: { (reverseGeocodeInfo, placemark, error) -> Void in
            
            let address = reverseGeocodeInfo?.object(forKey: "formattedAddress") as! String
            self.currentLocation.text = address
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status != CLAuthorizationStatus.notDetermined || status != CLAuthorizationStatus.denied || status != CLAuthorizationStatus.restricted
    {
        getLocation()
        }
    
    }
}

