//
//  VehicleSelectViewController.swift
//  uaftraffic
//
//  Created by Joseph Wolf on 6/26/19.
//  Copyright © 2019 University of Alaska Fairbanks. All rights reserved.
//

import UIKit

class VehicleSelectViewController: UITableViewController {
    
    var session = Session()
    var vehicleArray: [String] = []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8;
    }
    
    @IBAction func saveSession(sender: Any) {
        //     session.name = name
        if vehicleArray.count < 5 {
            let blankArray = Array(repeating: "", count: 5 - vehicleArray.count)
            vehicleArray.append(contentsOf: blankArray)
        }
        session.vehicle1Type = vehicleArray[0]
        session.vehicle2Type = vehicleArray[1]
        session.vehicle3Type = vehicleArray[2]
        session.vehicle4Type = vehicleArray[3]
        session.vehicle5Type = vehicleArray[4]
        let sessionManager = SessionManager()
        sessionManager.writeSession(session: session)
        performSegue(withIdentifier: "sessionInfo", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == nil {
            print("segue identifier is ni!")
            return
        }
        if segue.identifier == "sessionInfo" {
            if let vc = segue.destination as? SessionInfoViewController {
                print("DEBUGGING: " + vc.session.name)
                print("DEBUGGING: " + session.name)
                vc.session = session
            }
        } else if let segueId = segue.identifier {
            print("unhandled segue identifier: " + segueId)
        } else {
            print("unhandled segue identifier: UNKNOWN!")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath) as! SessionDetailsCrossingCell
        if cell.accessoryType == UITableViewCell.AccessoryType.none{
            if vehicleArray.count != 5 {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                vehicleArray.append((cell.selectLabel))
            }
        }
        else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
            let i = vehicleArray.firstIndex(of: (cell.selectLabel))
            vehicleArray.remove(at: i!)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "crossingCell", for: indexPath) as! SessionDetailsCrossingCell
        let counter = indexPath.row
        switch counter {
        case 0:
            cell.selectLabel = "atv"
        case 1:
            cell.selectLabel = "bike"
        case 2:
            cell.selectLabel = "car"
        case 3:
            cell.selectLabel = "mush"
        case 4:
            cell.selectLabel = "pedestrian"
        case 5:
            cell.selectLabel = "snowmachine"
        case 6:
            cell.selectLabel = "truck"
        case 7:
            cell.selectLabel = "plane"
        case 8:
            cell.selectLabel = "unknown"
        // more vehicles can be added, just be sure to address the row count as well
        default:
            assert(false, "too many rows")
        }
        cell.direction.text = ""
        cell.time.text = ""
        cell.selectionStyle = UITableViewCell.SelectionStyle.gray
        cell.vehicle.image = UIImage(named: cell.selectLabel + "-black")
        cell.accessoryType = UITableViewCell.AccessoryType.none
        return cell
    }
}
