//
//  MapViewController.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/4/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var open: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    //@IBOutlet weak var myNameLabel: UILabel!
    
    var searchController: UISearchController!;
    var annotation: MKAnnotation!;
    var localSearchRequest: MKLocalSearchRequest!;
    var localSearch: MKLocalSearch!;
    var localSearchResponse: MKLocalSearchResponse!;
    var error: NSError!;
    var pointAnnotation: MKPointAnnotation!;
    var pinAnnotationView: MKPinAnnotationView!;

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil{
            open.target = self.revealViewController();
            open.action = "revealToggle:";
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        }
        
        let initialLocation = CLLocation(latitude: 25.0142685, longitude: 121.5437686)
        let regionRadius: CLLocationDistance = 1000
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    
        /*
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(25.0142685, 121.5437686)
        dropPin.title = "test"
        mapView.addAnnotation(dropPin)
*/
        
    }
    
    @IBAction func addressSearchBtn(sender: UIBarButtonItem) {
        searchController = UISearchController(searchResultsController: nil);
        searchController.hidesNavigationBarDuringPresentation = false;
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder();
        dismissViewControllerAnimated(true, completion: nil);
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0] as! MKAnnotation;
            self.mapView.removeAnnotation(annotation);
        }
        
        localSearchRequest = MKLocalSearchRequest();
        localSearchRequest.naturalLanguageQuery = searchBar.text;
        localSearch = MKLocalSearch(request: localSearchRequest);
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                var alert = UIAlertView(title: "place not found", message: "place not fond", delegate: self, cancelButtonTitle: "Trt again");
                alert.show()
                return
            }
            
            self.pointAnnotation = MKPointAnnotation();
            self.pointAnnotation.title = searchBar.text;
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude: localSearchResponse.boundingRegion.center.longitude);
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil);
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation);
            
        }
    }

}
