//
//  TodayWeatherView.swift
//  WeatherAtBose
//
//  Created by Satish Garlapati on 1/22/20.
//  Copyright © 2020 Blackmoon. All rights reserved.
//

import UIKit

final class TodayWeatherView: UIView {
    
    private let tempLabel = constructLabel(with: 28, alignment: .center)
    private let descriptionLabel = constructLabel(with: 13, alignment: .center)
    private let feelsLikeLabel = constructLabel(with: 13, alignment: .right)
    private let maxMinTempLabel = constructLabel(with: 13, alignment: .right)
    private let leftVerticalStackView = constructStackView(for: .vertical, distribution: .fillEqually, alignment: .fill, spacing: 10)
    private let rightVerticalStackView = constructStackView(for: .vertical, distribution: .fillEqually, alignment: .fill, spacing: 10)
    private let horizontalStackView = constructStackView(for: .horizontal, distribution: .equalSpacing, alignment: .fill, spacing: 10)
    
    private let viewModel: HomeViewModel
    
    init(frame: CGRect,
         _ viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        setUpContentView()
        addConstraints()
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpContentView() {
        tempLabel.text = "..."
        descriptionLabel.text = "..."
        feelsLikeLabel.text = "..."
        maxMinTempLabel.text = "..."
        leftVerticalStackView.addArrangedSubview(tempLabel)
        leftVerticalStackView.addArrangedSubview(descriptionLabel)
        rightVerticalStackView.addArrangedSubview(feelsLikeLabel)
        rightVerticalStackView.addArrangedSubview(maxMinTempLabel)
        horizontalStackView.addArrangedSubview(leftVerticalStackView)
        horizontalStackView.addArrangedSubview(rightVerticalStackView)
        addSubview(horizontalStackView)
    }
    
    private func addConstraints() {
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        let constraints: [NSLayoutConstraint] = [
            horizontalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            horizontalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func updateUI() {
        viewModel.getTodayWeather { [weak self] (todayWeather, error) in
            guard let self = self,
                let weather = todayWeather else { return }
            self.tempLabel.text = weather.data.temp.description
            self.feelsLikeLabel.text = weather.data.feels_like.description
            self.descriptionLabel.text = weather.type
            self.maxMinTempLabel.text = weather.maxMinTemp
        }
    }
}

struct TodayWeather {
    let data: Main
    let type: String?
    
    var maxMinTemp: String {
        return data.temp_max.description + "/" + data.temp_min.description
    }
}
