//
//  UAFTrafficCountViewController.swift
//  uaftraffic
//
//  Created by Christopher Bailey on 2/24/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit
import CoreLocation

extension Notification.Name {
    static let addCrossing = Notification.Name("addCrossing")
}

class TrafficCountViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var undoButton: UIBarButtonItem!
    @IBOutlet weak var countLabel: UILabel!
	@IBOutlet weak var compassArrow: UIImageView!
	@IBOutlet weak var compassLetters: UIImageView!
	
	let locationManager = CLLocationManager()
	var session = Session()
    let sessionManager = SessionManager()
    var isResumedSession = false
	

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.addCrossing(notification:)), name: .addCrossing, object: nil)
		locationManager.delegate = self
		locationManager.startUpdatingHeading()
        crossingCountChanged()
    }
    
    @IBAction func endSessionButtonTapped(_ sender: Any) {
        if isResumedSession {
            sessionManager.writeSession(session: session)
            dismiss(animated: true, completion: nil)
        } else if session.crossings.count == 0 {
            dismiss(animated: true, completion: nil)
        } else {
            let confirmation = UIAlertController(title: "End Session", message: "Are you sure you want to end this session?", preferredStyle: .alert)
            confirmation.addAction(UIAlertAction(title: "Yes, end session", style: .destructive, handler: getSessionName))
            confirmation.addAction(UIAlertAction(title: "No, continue", style: .cancel, handler: nil))
            present(confirmation, animated: true, completion: nil)
        }
    }
    
    @IBAction func optionsButtonTapped(_ sender: Any){
        let settings = UIAlertController(title: "Options", message: "", preferredStyle: .alert)
        settings.addAction(UIAlertAction(title: "Rotate compass", style: .default, handler: rotationOptions))
        settings.addAction(UIAlertAction(title: "Vehicle selection", style: .default, handler: vehicleOptions))
        settings.addAction(UIAlertAction(title: "Road selection", style: .default, handler: roadOptions))
        settings.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(settings, animated: true, completion: nil)
    }
    func rotationOptions(sender: UIAlertAction){
        let rotational = UIAlertController(title: "Rotation Options", message: "which direction are you facing?", preferredStyle: .alert)
        rotational.addAction(UIAlertAction(title: "North", style: .default, handler: rotateNorth))
        rotational.addAction(UIAlertAction(title: "East", style: .default, handler: rotateEast))
        rotational.addAction(UIAlertAction(title: "South", style: .default, handler: rotateSouth))
        rotational.addAction(UIAlertAction(title: "West", style: .default, handler: rotateWest))
        rotational.addAction(UIAlertAction(title: "Back", style: .cancel, handler: optionsButtonTapped))
        //all rotation calls will need to change the appearance of the compass, the from direction of all vehicles, and the to direction of all vehicles, most likely with the assistance of if statements in VehicleView.
        present(rotational, animated: true, completion: nil)
    }
    func rotateNorth(_ sender: UIAlertAction){
        print("Rotating to North")
    }
    func rotateEast(_ sender: UIAlertAction){
        print("Rotating to East")
    }
    func rotateSouth(_ sender: UIAlertAction){
        print("Rotating to South")
    }
    func rotateWest(_ sender: UIAlertAction){
        print("Rotating to West")
    }
    
    func vehicleOptions(sender: UIAlertAction){
        let vehicular = UIAlertController(title: "Vehicle Options", message: "select the vehicles you are recording right now", preferredStyle: .alert)
        vehicular.addAction(UIAlertAction(title: "ATV", style: .default, handler: nil))
        vehicular.addAction(UIAlertAction(title: "Bicicle", style: .default, handler: nil))
        vehicular.addAction(UIAlertAction(title: "Car", style: .default, handler: nil))
        vehicular.addAction(UIAlertAction(title: "Pedestrian", style: .default, handler: nil))
        vehicular.addAction(UIAlertAction(title: "Snowmachine", style: .default, handler: nil))
        vehicular.addAction(UIAlertAction(title: "Back", style: .cancel, handler: optionsButtonTapped))
        present(vehicular, animated: true, completion: nil)
    }
    
    func roadOptions(sender: UIAlertAction){
        let road = UIAlertController(title: "Road Options", message: "select the applicable streets", preferredStyle: .alert)
        road.addAction(UIAlertAction(title: "North", style: .default, handler: nil))
        road.addAction(UIAlertAction(title: "East", style: .default, handler: nil))
        road.addAction(UIAlertAction(title: "South", style: .default, handler: nil))
        road.addAction(UIAlertAction(title: "West", style: .default, handler: nil))
        road.addAction(UIAlertAction(title: "Back", style: .cancel, handler: optionsButtonTapped))
        present(road, animated: true, completion: nil)
    }
    
    @IBAction func undoButtonTapped(_ sender: Any) {
        session.undo()
        crossingCountChanged()
    }
    
    func getSessionName(sender: UIAlertAction) {
        let namePrompt = UIAlertController(title: "Session Name", message: "What should this session be called?", preferredStyle: .alert)
        namePrompt.addTextField { textField in
            textField.placeholder = "Intersection of main and 3rd"
        }
        namePrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak namePrompt] _ in
            guard let name = namePrompt!.textFields!.first!.text else { return }
            self.endSession(name: name)
        }))
        namePrompt.addAction(UIAlertAction(title: "Quit without saving", style: .destructive, handler: { _ in
            let confirmation = UIAlertController(title: "Quit without saving", message: "Are you sure you want to quit without saving?", preferredStyle: .alert)
            confirmation.addAction(UIAlertAction(title: "Yes, discard data", style: .destructive, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            }))
            confirmation.addAction(UIAlertAction(title: "No, continue", style: .cancel, handler: nil))
            self.present(confirmation, animated: true, completion: nil)
        }))
        namePrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(namePrompt, animated: true, completion: nil)
    }
    
    func endSession(name: String) {
        print("Ending session")
        session.name = name
        sessionManager.writeSession(session: session)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addCrossing(notification: Notification) {
        let userInfo = notification.userInfo! as! Dictionary<String, String>
        print("got crossing:", userInfo)
        session.addCrossing(type: userInfo["type"]!, from: userInfo["from"]!, to: userInfo["to"]!)
        crossingCountChanged()
    }
    
    func crossingCountChanged() {
        undoButton.isEnabled = session.crossings.count != 0
        countLabel.text = "Total Counted: " + String(session.crossings.count)
    }
    
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let angle = abs((newHeading.trueHeading * .pi/180) - (2.0 * .pi))
        compassLetters.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
	}
}
