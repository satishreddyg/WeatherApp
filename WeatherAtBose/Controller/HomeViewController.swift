//
//  ViewController.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var scrollContentView: UIView!
    private var contentHeightConstraint: NSLayoutConstraint!
    private var viewModel = HomeViewModel(.openWeatherAPI)
    private var searchController: UISearchController!
    private var completer = MKLocalSearchCompleter.init()
    private var searchResults: [MKLocalSearchCompletion] = []
    private var todayView: TodayWeatherView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completer.delegate = self
        completer.filterType = .locationsOnly
        configureSubViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reFrameTheContentView()
    }
    
    private func reFrameTheContentView() {
        var yPosition: CGFloat = 15.0
        for view in scrollContentView.subviews {
            var _frame = view.frame
            _frame.origin.y = yPosition
            yPosition += _frame.height
            view.frame = _frame
        }
        guard yPosition > 0 else { return }
        if contentHeightConstraint == nil {
            contentHeightConstraint = scrollContentView.heightAnchor.constraint(equalToConstant: yPosition)
            contentHeightConstraint.isActive = true
        } else {
            contentHeightConstraint.constant = yPosition
        }
    }
    
    private func configureSubViews() {
        setupScrollView()
        setupTodayWeatherView()
        configureSearchController()
    }

    private func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        scrollContentView = UIView()
        scrollView.backgroundColor = .white
        scrollView.bounces = false
        scrollView.addSubview(scrollContentView)
        scrollView.contentSize = scrollContentView.bounds.size
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: view.widthAnchor)]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupTodayWeatherView() {
        todayView = TodayWeatherView(frame: CGRect(x: 15, y: (scrollContentView.subviews.last?.frame.maxY ?? 0) + 15, width: view.frame.width - 30, height: 150), viewModel)
        scrollContentView.addSubview(todayView)
    }

    func configureSearchController() {
        let resultsController = LocationSearchResultController()
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        resultsController.delegate = self
        
        let searchBarTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchBarTextField?.placeholder = "search another location"
        searchBarTextField?.backgroundColor = .white
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .search
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
        
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        navigationController?.navigationBar.backgroundColor = .systemPurple
        definesPresentationContext = true
    }
}


// MARK: Search Bar Delegate

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        navigationController?.navigationBar.barTintColor = .systemPurple
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else { return }
        completer.queryFragment = searchText
    }
}

extension HomeViewController: LocationSearchDelegate {
    func didSelectLocation(with placeMark: MKPlacemark) {
        dismiss(animated: true, completion: nil)
        guard let selectedLocation = placeMark.location else { return }
        storeLocation(selectedLocation)
        todayView.updateUI()
    }
}

// MARK: MKLocalSearchCompleter Delegate

extension HomeViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard let locationSearchResultsVC = searchController.searchResultsUpdater as? LocationSearchResultController else { return }
        locationSearchResultsVC.results = completer.results
        searchController.searchResultsUpdater?.updateSearchResults(for: searchController)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("failed with update the results: \(error)")
    }
}
