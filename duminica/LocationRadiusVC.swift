//
//  LocationRadiusVC.swift
//  duminica
//
//  Created by Rostyk on 16.12.17.
//  Copyright © 2017 paul catana. All rights reserved.
//

import UIKit

class LocationRadiusVC: UIViewController {

    @IBOutlet weak var locationSlider: UISlider!
    @IBOutlet weak var radiusValue: UILabel!
    
    private let radiusValues = [10, 25, 50, 100]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSlider()
        navigationItem.setLeftBarButton(UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancellPressed)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(savePressed)), animated: true)
    }
    
    @objc private func cancellPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func savePressed() {
        AppDelegate.session.locationRadius = radiusValues[Int(locationSlider.value)]
        dismiss(animated: true, completion: nil)
    }
    
    private func setUpSlider() {
        let radius = AppDelegate.session.locationRadius ?? 10
        guard let index = radiusValues.index(of: radius) else {
            return
        }
        locationSlider.value = Float(index.toIntMax())
        radiusValue.text = "\(radius)"
    }
    
    @IBAction func radiusChanged(_ sender: UISlider) {
        let radius = radiusValues[Int(sender.value + 0.5)]
        radiusValue.text = "\(radius)"
        guard let index = radiusValues.index(of: radius) else {
            return
        }
        locationSlider.setValue(Float(index.toIntMax()), animated: true)
    }
    
}
