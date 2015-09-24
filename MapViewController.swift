//
//  MapViewController.swift
//  CrackTheTerm_review
//
//  Created by Kuan-Wei Lin on 8/22/15.
//  Copyright (c) 2015 Kuan-Wei Lin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {

    var region: MKCoordinateRegion!
    let locationManger = CLLocationManager()
    
    //Map search
    var searchController: UISearchController!
    var annotation: MKAnnotation!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var error: NSError!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    @IBOutlet weak var slideOutMenu: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapSegment: UISegmentedControl!
    
    
    override func viewDidAppear(animated: Bool) {
        if (CLLocationManager.locationServicesEnabled()){
            locationManger.requestWhenInUseAuthorization()
            locationManger.requestAlwaysAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil{
            slideOutMenu.target = revealViewController()
            slideOutMenu.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        mapView.delegate = self
        
        let initialLocation = CLLocation(latitude: 25.0142685, longitude: 121.5437686)
        let regionRadius: CLLocationDistance = 4000
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    @IBAction func searchPlaceAction(sender: UIBarButtonItem) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0] 
            self.mapView.removeAnnotation(annotation)
        }
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                let alert = UIAlertView(title: "查無此處", message: "找不到此地點，請重新搜尋", delegate: self, cancelButtonTitle: "重新搜尋")
                alert.show()
                return
            }else{
            
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            /*
            var latDelta: CLLocationDegrees = 0.1
            var longDelta: CLLocationDegrees = 0.1
            var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            var theRegion: MKCoordinateRegion = MKCoordinateRegionMake(self.pointAnnotation.coordinate, span)
            self.mapView.setRegion(theRegion, animated: true)
            */

            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            
            }
        }
    }
    
    @IBAction func changeMapStyle(sender: UISegmentedControl) {
        switch mapSegment.selectedSegmentIndex{
        case 0:
            mapView.mapType = MKMapType.Standard
        case 1:
            mapView.mapType = MKMapType.Satellite
        case 2:
            mapView.mapType = MKMapType.Hybrid
        default:
            mapView.mapType = MKMapType.Standard
            mapSegment.selectedSegmentIndex = 0
        }
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let region: MKCoordinateRegion = mapView.region
        
        print(region.center.latitude)
        print(region.center.longitude)
        print(region.span.latitudeDelta)
        print(region.span.longitudeDelta)
    }
    
    
    
    
    
    
}
