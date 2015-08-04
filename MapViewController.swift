//
//  MapViewController.swift
//  SwifferApp
//
//  Created by Kuan-Wei Lin on 8/4/15.
//  Copyright (c) 2015 Kareem Khattab. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var open: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!

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
    
        
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = CLLocationCoordinate2DMake(25.0142685, 121.5437686)
        dropPin.title = "test"
        mapView.addAnnotation(dropPin)
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
