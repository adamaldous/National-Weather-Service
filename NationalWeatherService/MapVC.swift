//
//  MapVC.swift
//  NationalWeatherService
//
//  Created by Adam Aldous on 4/1/16.
//  Copyright © 2016 Adam Aldous. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationSearchTextField: UITextField!
    
    
    
//    var annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        self.locationSearchTextField.delegate = self
        
        var uilgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilgr.minimumPressDuration = 2.0
        mapView.addGestureRecognizer(uilgr)
        
        //IOS 9
        
//        let createAnnotation = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer))
//        self.view.addGestureRecognizer(createAnnotation)
//        
//        UITapGestureRecognizer.add
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func addPinGesture(sender: AnyObject) {
//        
//        // Delete previous annotations so only one pin exists on the map at one time
//        mapView.removeAnnotations(mapView.annotations)
//        mapView.removeOverlays(mapView.overlays)
//        
//        let touchPoint = tapGestureRecognizer.locationInView(self.mapView)
//        let newCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
//        
//        // Callout Annotation
//        annotation.coordinate = newCoordinate
//        annotation.title = "New Pin"
//        annotation.subtitle = "Sweet Annotation Bruh!"
//        mapView.addAnnotation(annotation)
//        
//        // Create circle with the Pin
//        let fenceDistance: CLLocationDistance = 3000
//        let circle = MKCircle(centerCoordinate: newCoordinate, radius: fenceDistance)
//        let circleRenderer = MKCircleRenderer(overlay: circle)
//        circleRenderer.lineWidth = 3.0
//        circleRenderer.strokeColor = UIColor.purpleColor()
//        circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
//        
//        // Creates the span and animated zoomed into an area
//        let span = MKCoordinateSpanMake(0.1, 0.1)
//        let region = MKCoordinateRegion(center: newCoordinate, span: span)
//        mapView.setRegion(region, animated: true)
//        mapView.addOverlay(circle)
//        
//        // Add an alarm pin
//        let alarm = AlarmPin(coordinate: newCoordinate, radius: fenceDistance, identifier: "")
//        addAlarmPin(alarm)
//        startMonitoringAlarmPin(alarm)
//    }

    
    
    func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            var touchPoint = gestureRecognizer.locationInView(mapView)
            var newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
            })
        }
    }
    
    func action(gestureRecognizer:UIGestureRecognizer){
        var touchPoint = gestureRecognizer.locationInView(mapView)
        var newCoordinates = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        mapView.addAnnotation(annotation)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
