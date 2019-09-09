//
//  PlacePickertController.swift
//  iCubeTest
//
//  Created by wirawan on 9/9/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import UIKit
import MapKit

class PlacePickertController: UITableViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var places: [Place] = []
    
    // MARK: - presenter
    lazy var presenter: PlacePickerInterface = {
        return PlacePickerPresenter.init(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getPlaces()
    }
}

extension PlacePickertController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "placeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let place = places[indexPath.row]
        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = String(format: "SGD %d", place.price ?? 0)
        cell.accessoryType = (place.isSelected ?? false) ? .checkmark : .none
        return cell
    }
}

extension PlacePickertController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension PlacePickertController: PlacePickerDelegate {
    func didSuccessGetPlace(response: PlaceData) {
        var annotations: [MKAnnotation] = []
        places = response.places ?? []
        
        for place in places {
            let latitude = Double(place.latitude ?? "0") ?? 0.0
            let longitude = Double(place.longitude ?? "0") ?? 0.0
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = String(format: "Address: %@\nPrice: SGD %d\n", place.address ?? "", place.price ?? 0)
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotations.append(annotation)
        }
        mapView.showAnnotations(annotations, animated: true)
        tableView.reloadData()
    }
    
    func didFailedGetPlace(response: GoodBoyError) {
        
    }
}

extension PlacePickertController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let name = view.annotation?.title,
            let subtitle = view.annotation?.subtitle else {
            return
        }
        
        var place = places.filter{ (place) -> Bool in place.name == (name ?? "") }
        
        if place.count > 0 {
            CustomAlert.showAlert(title: String(format: "Do you want to select %@?", name ?? ""), message: subtitle ?? "", parent: self, confirmCallback: { [weak self] in
                place[0].isSelected = true
                self?.tableView.reloadData()
            }, cancelCallback: { [weak self] in
                place[0].isSelected = false
                self?.tableView.reloadData();
            })
        }
    }
}
