//
//  SecondOnboardingScreen.swift
//  Tracker
//
//  Created by Даниил Крашенинников on 11.06.2023.
//

import UIKit

final class SecondOnboardingScreen: UIViewController {
    
    lazy var screen: UIImageView = {
        let screen = UIImageView()
        screen.image = UIImage(named: "secondScreen")
        screen.translatesAutoresizingMaskIntoConstraints = false
        
        return screen
    }()
    
    lazy var textLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = 2
        text.textAlignment = .center
        text.text = "Даже если это \n не литры воды и йога"
        text.font = UIFont.boldSystemFont(ofSize: 32)
        text.translatesAutoresizingMaskIntoConstraints = false
        
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        view.addSubview(screen)
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            screen.topAnchor.constraint(equalTo: view.topAnchor),
            screen.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screen.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            screen.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 432),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
