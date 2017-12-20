//
//  MapViewController.swift
//  Tracker
//
//  Created by Toby Satterthwaite on 11/23/17.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var backButton: UIButton!
    
    // Initialize workout with dummy variable
    var workout = Workout(time: 0, distance: 0, points: [], date: Date())

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        // Stylize button
        backButton.layer.cornerRadius = 10
        
        // Get locations of points to plot
        var points: [CLLocationCoordinate2D] = []
        for point in workout.points {
            points.append(point.location)
        }
        
        // Draw path and add points, but only if there are points
        // Learned about drawing paths here: https://developer.apple.com/documentation/mapkit/mkpolyline
        if (!points.isEmpty) {
            let pathLine = MKPolyline(coordinates: points, count: points.count)
            mapView.add(pathLine)
            
            // Add points to map, and center it at the first point
            mapView.centerCoordinate = points[0]
            mapView.region = MKCoordinateRegion(center: points[0], span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Render the path line on the map
        // Learned about this function here: https://stackoverflow.com/questions/45066009/mkpolyline-swift-4
        if let polyline = overlay as? MKPolyline {
            let testLineRenderer = MKPolylineRenderer(polyline: polyline)
            testLineRenderer.strokeColor = UIColor(red: 1.00, green: 0.09, blue: 0.33, alpha: 1.0)
            testLineRenderer.lineWidth = 2.0
            return testLineRenderer
        }
        fatalError("Something went wrong")
        //return MKOverlayRenderer()
    }
    
    @IBAction func back() {
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
