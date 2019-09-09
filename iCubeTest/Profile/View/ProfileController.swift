//
//  ViewController.swift
//  iCubeTest
//
//  Created by wirawan on 9/9/19.
//  Copyright © 2019 wirawan. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var selectedPlaceView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedPlaceLabel: UILabel!
    
    private var selectedPlaces: [Place] = []
    
    // MARK: - presenter
    lazy var presenter: ProfileInterface = {
        return ProfilePresenter.init()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? PlacePickertController {
            destinationController.delegate = self
        }
    }
}

extension ProfileController {
    @IBAction func didTapSubmitButton(sender: UIButton) {
        var user: User = User()
        user.name = nameTextField.text
        user.email = emailTextField.text
        
        if presenter.validateUsername(user: user) &&
            presenter.validateEmail(user: user) {
            CustomAlert.showAlert(title: user.name ?? "", message: user.email ?? "" , parent: self, confirmCallback: {})
        }
        else {
            CustomAlert.showAlert(title: "", message: presenter.getErrorMessage(), parent: self, confirmCallback: {})
        }
    }
}

extension ProfileController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "placeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let place = self.selectedPlaces[indexPath.row]
        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = String(format: "SGD %d", place.price ?? 0)
        cell.accessoryType = (place.isSelected ?? false) ? .checkmark : .none
        return cell
    }
}

extension ProfileController: PlacePickertControllerDelegate {
    func dataChanged(places: [Place]) {
        self.selectedPlaces = places.filter{ $0.isSelected == true }
        self.selectedPlaceView.isHidden = self.selectedPlaces.count > 0 ? false : true
        self.tableView.reloadData()
        self.selectedPlaceLabel.text = String.init(format:"You have selected %d places", self.selectedPlaces.count)
    }
}

