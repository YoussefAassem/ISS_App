//
//  StationLocationViewController.swift
//  ISS_App
//
//  Created by Youssef AASSEM on 1/31/20.
//  Copyright © 2020 Youssef AASSEM. All rights reserved.
//

import MapKit

protocol LocationViewProtocol {
    func setDelegate(_ newDelegate: LocationViewDelegate)
    func updateUI(with point: CLLocation)
    func showError(message: String)
    func addSubView(_ subView: UIView)
}

protocol LocationViewDelegate: AnyObject {
    func viewIsReady()
}

protocol LocationViewFactory {
    static func makeView() -> LocationViewProtocol
}

class StationLocationViewController: UIViewController {
    private lazy var mapView: MKMapView! = MKMapView()
    private weak var delegate: LocationViewDelegate?
    private lazy var alertVC: UIAlertController = {
       let popup = UIAlertController()
       popup.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
       return popup
    }()
    private lazy var issPosition: MKPointAnnotation = MKPointAnnotation()
    private let regionRadius: CLLocationDistance = 10000000
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        delegate?.viewIsReady()
    }
}

//MARK: Private functions
private extension StationLocationViewController {
     func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.isZoomEnabled = true
        addSubView(mapView)
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
    }
     func setupView() {
        issPosition.title = "International Space Station"
        setupMapView()
    }
}

//MARK: LocationViewFactory Implementation
extension StationLocationViewController: LocationViewFactory {
    static func makeView() -> LocationViewProtocol {
        let viewController = StationLocationViewController()
        return viewController
    }
}


//MARK: LocationViewProtocol Implementation
extension StationLocationViewController: LocationViewProtocol {
    func setDelegate(_ newDelegate: LocationViewDelegate) {
        delegate = newDelegate
    }
    
    func updateUI(with point: CLLocation) {
        print("point details latitude = \(point.coordinate.latitude.description) longitude = \(point.coordinate.longitude.description)")
        issPosition.coordinate = point.coordinate
        let coordinateRegion = MKCoordinateRegion(center: point.coordinate,latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        if let anotation = self.mapView?.annotations.first { self.mapView?.removeAnnotation(anotation) }
        self.mapView?.setRegion(coordinateRegion, animated: true)
        self.mapView?.addAnnotation(self.issPosition)

    }
    
    func showError(message: String) {
        alertVC.message = message
        present(alertVC, animated: true, completion: nil)
    }
    
    func addSubView(_ subView: UIView) {
        view.addSubview(subView)
        subView.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -15).isActive = true
        subView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -20).isActive = true
        subView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10).isActive = true 
    }
}
