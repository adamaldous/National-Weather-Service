//
//  MapVC.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 4/4/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var tappedPin: MKPointAnnotation? = nil
    var placemark: MKPlacemark? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewControllerWithIdentifier("LocationSearchTable") as! LocationSearchTableVC
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        // This configures the search bar, and embeds it within the navigation bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search or Long Press Map"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapVC.addAnnotation(_:)))
        longPress.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPress)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gestureRecognizer.locationInView(mapView)
            let newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            dropPinZoomInTap(annotation)
            
        }
    }
    
    
    func dropPinZoomInTap(placemark: MKPointAnnotation){
        
        // cache the pin
        tappedPin = placemark
        
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = String(placemark.coordinate.latitude)
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKPinAnnotationView
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView { // 2
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
            
        else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            //            return nil
        }
        return view
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let alert = UIAlertController(title: nil, message: "Save this location", preferredStyle: .Alert)
        //        alert.message = UIFont(name: "System - System", size: 19)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
            textField.autocapitalizationType = UITextAutocapitalizationType.Words
            textField.font = UIFont(name: "System", size: 10)
            
            
        }
        let action = UIAlertAction(title: "Save", style: .Default) { (_) in
            let textField = alert.textFields![0] as UITextField
            if let text = textField.text {
                
                if let tappedPin = self.tappedPin {
                    let location = Location(name: text, location: CLLocation(latitude: tappedPin.coordinate.latitude, longitude: tappedPin.coordinate.longitude))
                    LocationController.sharedController.addLocation(location)
                    (self.navigationController?.viewControllers.first as? LocationTableVC)?.tableView.reloadData()
                    
                } else {
                    if let placemark = self.placemark
                    {
                        let location = Location(name: text, location: CLLocation(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude))
                        LocationController.sharedController.addLocation(location)
                        (self.navigationController?.viewControllers.first as? LocationTableVC)?.tableView.reloadData()
                    }
                }
            }
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}



extension MapVC: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
//            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        if let location = locations.first {
        //            let span = MKCoordinateSpanMake(0.05, 0.05)
        //            let region = MKCoordinateRegion(center: location.coordinate, span: span)
        //            mapView.setRegion(region, animated: true)
        //        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

extension MapVC: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark){
        
        // cache the pin
        self.placemark = placemark
        
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }
}

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}






