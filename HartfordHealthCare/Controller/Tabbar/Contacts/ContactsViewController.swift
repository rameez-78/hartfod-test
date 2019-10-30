//
//  Tab2ViewController.swift
//  Hartford Healthcare
//
//  Created by Bradley Pickard on 3/4/19.
//  Copyright © 2019 Bradley Pickard. All rights reserved.
//

import UIKit
//import CoreLocation
import MapKit

class ContactsViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Properties
    private var doctors: [Doctor] = Doctor.getDoctors()
    private var blueBackSquarePainCenter: String = "The Pain Center at Blue Back Square"
    private var midStatePainCenter: String = "Spine & Pain Institute at MidState Medical"
    private var isCentersCellRowAnimated: Bool = false
    
    
    // MARK: UIViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: Action
    @objc private func doctorPhoneNumberButtonTapped(sender: UIButton) {
        
        let doctor = doctors[sender.tag]
        if doctor.phoneNumber != "" {
            saveClickSession(clickName: doctor.name, clickType: "Phone Link")
            openPhoneDialer(phoneNumber: doctor.phoneNumber)
        }
        
    }
    
    @objc private func blueBackCenterPhoneNumberButtonTapped(sender: UIButton) {
        saveClickSession(clickName: blueBackSquarePainCenter, clickType: "Phone Link")
        openPhoneDialer(phoneNumber: "860.696.2843")
    }
    
    @objc private func midstatePhoneNumberButtonTapped(sender: UIButton) {
        saveClickSession(clickName: midStatePainCenter, clickType: "Phone Link")
        openPhoneDialer(phoneNumber: "860.696.2843")
    }
    
    @objc private func blueBackCenterDirectionsButtonTapped(sender: UIButton) {
        saveClickSession(clickName: blueBackSquarePainCenter, clickType: "Maps Link")
        openMap(coordinates: CLLocationCoordinate2D(latitude: 41.760096, longitude: -72.740470), locationName: blueBackSquarePainCenter)
    }
    
    @objc private func midstateDirectionsButtonTapped(sender: UIButton) {
        saveClickSession(clickName: midStatePainCenter, clickType: "Maps Link")
        openMap(coordinates: CLLocationCoordinate2D(latitude: 41.549216, longitude: -72.800996), locationName: midStatePainCenter)
    }

    @objc private func blueBackCenterWebsiteButtonTapped(sender: UIButton) {
        saveClickSession(clickName: blueBackSquarePainCenter, clickType: "Website Link")
        openSafari(with: "https://hartfordhospital.org/locations/family-wellness-centers/west-hartford-wellness-center-at-blue-back-square/pain-treatment-center")
    }

    @objc private func midstateWebsiteButtonTapped(sender: UIButton) {
        saveClickSession(clickName: midStatePainCenter, clickType: "Website Link")
        openSafari(with: "https://midstatemedical.org/services/pain-treatment")
    }
    
    
    // MARK: Custom Methods
    private func setupViews() {
        
        view.addAppThemeGradient()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
    }

    private func saveClickSession(clickName: String, clickType: String) {
        
        if DBManager.shared().linkSessionsAreSubscribed {
            let linkSession = LinkSession()
            linkSession.id = linkSession.incrementID()
            linkSession.clickTime = Date().getDateStringForSession()
            linkSession.clickName = "\(clickName) - \(clickType)"
            if let participantID = UserDefaults.standard.value(forKey: UserDefaultKeys.participantID) as? String {
                linkSession.userParticipantID = participantID
            }
            DBManager.shared().add(object: linkSession, overwrite: false)
        }

    }

    private func openPhoneDialer(phoneNumber: String) {
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    private func openMap(coordinates: CLLocationCoordinate2D, locationName: String) {
        
        let regionDistance: CLLocationDistance = 50
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        mapItem.openInMaps(launchOptions: options)
    
    }
    
    private func openSafari(with url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
    
}


// MARK: UITableView Delegates & DataSource
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else {
            return doctors.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MeditationCentersTableViewCell.identifier) as! MeditationCentersTableViewCell
            cell.blueBackCenterWebsiteButton.addTarget(self, action: #selector(blueBackCenterWebsiteButtonTapped(sender:)), for: .touchUpInside)
            cell.blueBackCenterDirectionsButton.addTarget(self, action: #selector(blueBackCenterDirectionsButtonTapped(sender:)), for: .touchUpInside)
            cell.blueBackCenterPhoneNumberButton.addTarget(self, action: #selector(blueBackCenterPhoneNumberButtonTapped(sender:)), for: .touchUpInside)
            cell.midstateWebsiteButton.addTarget(self, action: #selector(midstateWebsiteButtonTapped(sender:)), for: .touchUpInside)
            cell.midstateDirectionsButton.addTarget(self, action: #selector(midstateDirectionsButtonTapped(sender:)), for: .touchUpInside)
            cell.midstatePhoneNumberButton.addTarget(self, action: #selector(midstatePhoneNumberButtonTapped(sender:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DoctorTableViewCell.identifier) as! DoctorTableViewCell
            cell.phoneNumberButton.tag = indexPath.row
            cell.phoneNumberButton.addTarget(self, action: #selector(doctorPhoneNumberButtonTapped(sender:)), for: .touchUpInside)
            cell.populate(doctor: doctors[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if isCentersCellRowAnimated {
                return
            } else {
                isCentersCellRowAnimated = true
            }
        } else {
            let doctor = doctors[indexPath.row]
            if doctor.isCellRowAnimated {
                return
            } else {
                doctor.isCellRowAnimated = true
            }
        }
        
        cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height / 2)
        cell.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
        })
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 105.0
        }
        
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 650.0
        } else {
            return 105.0
        }

    }
    
}
