//
//  LocationSearchResultController.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import MapKit

class LocationSearchResultController: UITableViewController {
    
    var results: [MKLocalSearchCompletion] = []
    weak var delegate: LocationSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        let item = results[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        return cell
    }
    
    // MARK: Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = MKLocalSearch.Request(completion: results[indexPath.row])
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { [weak self] (response, error) -> Void in
            guard let self = self, error == nil,
                let placemark = response?.mapItems.first?.placemark else { return }
            self.delegate?.didSelectLocation(with: placemark)
        }
    }
}

// MARK: Search Results Updating

extension LocationSearchResultController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
}

// MARK: Protocol

protocol LocationSearchDelegate: AnyObject {
    func didSelectLocation(with placeMark: MKPlacemark)
}
