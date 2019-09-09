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
    
    // MARK: - presenter
    lazy var presenter: ProfileInterface = {
        return ProfilePresenter.init()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension ProfileController {
    @IBAction func didTapSubmitButton(sender: UIButton) {
        var user: User = User()
        user.name = nameTextField.text
        user.email = emailTextField.text
        
        if presenter.validateEmail(user: user) &&
            presenter.validateUsername(user: user) {
        }
        else {
            CustomAlert.showAlert(title: "", message: presenter.getErrorMessage(), parent: self, confirmCallback: {})
        }
    }
}

