//
//  GlobalFunctions.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import UIKit
import CoreLocation

func constructLabel(with fontSize: CGFloat = 14,
                             and fontName: Constants.Font = .openSansBold,
                             textColor: UIColor = .black,
                             alignment: NSTextAlignment = .center,
                             fitToWidth: Bool = false,
                             priority: UILayoutPriority? = nil) -> UILabel {
    let _label = UILabel()
    _label.font = UIFont(name: fontName.rawValue, size: fontSize)
    _label.textColor = textColor
    _label.textAlignment = alignment
    _label.adjustsFontSizeToFitWidth = fitToWidth
    if let _priority = priority {
        _label.setContentHuggingPriority(_priority, for: .horizontal)
    }
    return _label
}

func constructStackView(for axis: NSLayoutConstraint.Axis,
                        distribution: UIStackView.Distribution = .fill,
                        alignment: UIStackView.Alignment = .fill,
                        spacing: CGFloat = 0) -> UIStackView {
    let _stackView = UIStackView()
    _stackView.axis = axis
    _stackView.distribution = distribution
    _stackView.alignment = alignment
    _stackView.spacing = spacing
    return _stackView
}

func LocalizedString(_ key: Constants.LocalizedKey) -> String {
    return NSLocalizedString(key.rawValue, comment: "")
}

func storeLocation(_ location: CLLocation) {
    let archived = NSKeyedArchiver.archivedData(withRootObject: location)
    UserDefaults.standard.set(archived, forKey: "currentLocation")
}

func getCurrentLocation() -> CLLocation? {
    guard let archived = UserDefaults.standard.object(forKey: "currentLocation") as? Data,
        let location = NSKeyedUnarchiver.unarchiveObject(with: archived) as? CLLocation else {
            return nil
    }
    return location
}
