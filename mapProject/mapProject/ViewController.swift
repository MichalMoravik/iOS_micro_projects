//
//  ViewController.swift
//  mapProject
//
//  Created by Michal Moravík on 05/03/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    // for a pin
    @IBOutlet weak var customTextTextField: UITextField!
    @IBOutlet weak var xCoordinateTextField: UITextField!
    @IBOutlet weak var yCoordinateTextField: UITextField!
    var xCoordinateDouble: Double = 0.0
    var yCoordinateDouble: Double = 0.0
    
    // for a map
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    @IBOutlet weak var mapKit: MKMapView!
    
    
    override func viewDidLoad() {
        configureLocationServices()
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        // x and y textfields should be disabled from the beginning
        xCoordinateTextField.isUserInteractionEnabled = false
        yCoordinateTextField.isUserInteractionEnabled = false
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if  status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if (status == .authorizedAlways || status == .authorizedWhenInUse){
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager)  {
        mapKit.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapKit.setRegion(zoomRegion, animated: true)
    }
    
    /* methods for a pin */
    // get coordinates after click on the map
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self.mapKit)
            let location = self.mapKit.convert(touchPoint, toCoordinateFrom: self.mapKit)
            xCoordinateTextField.text = String(location.latitude)
            yCoordinateTextField.text = String(location.longitude)
            xCoordinateDouble = location.latitude
            yCoordinateDouble = location.longitude
        }
    }
    
    @IBAction func addPinPressed(_ sender: Any) {
        let annotation = MKPointAnnotation()
        annotation.title = customTextTextField.text
        annotation.coordinate = CLLocationCoordinate2D(latitude: xCoordinateDouble, longitude: yCoordinateDouble)
        mapKit.addAnnotation(annotation)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did get latest location")
        
        guard let latestLocation = locations.first else {return}
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
        }
        
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed")
        if (status == .authorizedAlways || status == .authorizedWhenInUse){
            beginLocationUpdates(locationManager: manager)
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

