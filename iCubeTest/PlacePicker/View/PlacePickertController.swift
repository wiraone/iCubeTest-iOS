//
//  PlacePickertController.swift
//  iCubeTest
//
//  Created by wirawan on 9/9/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import UIKit
import MapKit

protocol PlacePickertControllerDelegate: class {
    func dataChanged(places: [Place])
}

class PlacePickertController: UITableViewController {
    @IBOutlet weak var mapView: MKMapView!
    private var places: [Place] = []
    private var annotations: [MKPointAnnotation] = []
    weak var delegate: PlacePickertControllerDelegate?
    
    // MARK: - presenter
    lazy var presenter: PlacePickerInterface = {
        return PlacePickerPresenter.init(delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getPlaces()
        self.addDoneButtonToNavigationBar()
        self.tableView.tableFooterView = UIView()
        self.mapView.isHidden = true
    }
    
    private func addDoneButtonToNavigationBar() {
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItems = [done]
    }
    
    @objc private func didTapDoneButton() {
        self.delegate?.dataChanged(places: self.places)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func drawPointOfInterest() {
        for place in self.places {
            let latitude = Double(place.latitude ?? "0") ?? 0.0
            let longitude = Double(place.longitude ?? "0") ?? 0.0
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = String(format: "Address: %@\nPrice: SGD %d\n", place.address ?? "", place.price ?? 0)
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.annotations.append(annotation)
        }
        self.mapView.showAnnotations(self.annotations, animated: true)
    }
    
    private func removePointOfInterest() {
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    private func updateSelectedPlace(name: String, isSelected: Bool) {
        if let row = self.places.firstIndex(where: {$0.name == name}) {
            self.places[row].isSelected = isSelected
            self.removePointOfInterest()
            self.drawPointOfInterest()
            self.tableView.reloadData()
        }
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
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
        let place = self.places[indexPath.row]
        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = String(format: "SGD %d", place.price ?? 0)
        cell.accessoryType = (place.isSelected ?? false) ? .checkmark : .none
        return cell
    }
}

extension PlacePickertController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let latitude = Double(place.latitude ?? "0") ?? 0.0
        let longitude = Double(place.longitude ?? "0") ?? 0.0
        let location = CLLocation.init(latitude: latitude, longitude: longitude)
        self.centerMapOnLocation(location: location)
        self.mapView.selectAnnotation(annotations[indexPath.row], animated: true)
    }
}

extension PlacePickertController: PlacePickerDelegate {
    func didSuccessGetPlace(response: PlaceData) {
        self.places = response.places ?? []
        self.drawPointOfInterest()
        self.delegate?.dataChanged(places: self.places);
        self.tableView.reloadData()
        self.mapView.isHidden = false
    }
    
    func didFailedGetPlace(response: GoodBoyError) {
        CustomAlert.showAlert(title: "", message: response.error?.message ?? "", parent: self) {}
    }
}

extension PlacePickertController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        
        if let row = self.places.firstIndex(where: {$0.name == annotation.title}) {
            annotationView?.markerTintColor = self.places[row].isSelected ?? false ? .blue : .red
        }
        annotationView?.canShowCallout = true
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let name = view.annotation?.title,
            let subtitle = view.annotation?.subtitle,
            let row = self.places.firstIndex(where: {$0.name == name}) else {
            return
        }
        
        let selectedPlace = self.places[row]
        let deselectMessage = String(format: "Do you want to deselect %@?", name ?? "")
        let selectMessage = String(format: "Do you want to select %@?", name ?? "")
        let alertMessage = selectedPlace.isSelected == true ? deselectMessage : selectMessage
        
        CustomAlert.showAlert(title: alertMessage, message: subtitle ?? "", parent: self, confirmCallback: { [weak self] in
                if selectedPlace.isSelected == true {
                    self?.updateSelectedPlace(name: name ?? "", isSelected: false)
                }
                else {
                    self?.updateSelectedPlace(name: name ?? "", isSelected: true)
                }
            }, cancelCallback: {})
    }
}
