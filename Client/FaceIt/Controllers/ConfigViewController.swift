//
//  ConfigViewController.swift
//  FaceIt
//
//  Created by Nadav Bar Lev on 18/06/2019.
//  Copyright © 2019 Nadav Bar Lev. All rights reserved.
//

import UIKit
import DLRadioButton

enum ModelTypes: String {
    case server
    case local
}

class ConfigViewController: UIViewController {
    
    // MARK: Constants
    let DEFAULT_MODEL: ModelTypes = .server
    let DEFAULT_FREQUENCY: TimeInterval = 3
    
    // MARK: Properties
    var model: ModelTypes?
    var frequency: TimeInterval?
    var callback: ((ModelTypes, TimeInterval)->(Void))?
    
    // MARK: Outlets
    @IBOutlet weak var radioServer: DLRadioButton!
    @IBOutlet weak var radioLocal: DLRadioButton!
    @IBOutlet weak var radio1Second: DLRadioButton!
    @IBOutlet weak var radio2Seconds: DLRadioButton!
    @IBOutlet weak var radio3Seconds: DLRadioButton!
    @IBOutlet weak var radio10Seconds: DLRadioButton!
    @IBOutlet weak var buttonApply: UIButton!
    
    // MARK: Actions
    @IBAction func modelSelected(_ sender: UIButton) {
        
        let selected = sender.titleLabel?.text?.lowercased()
            ?? DEFAULT_MODEL.rawValue
        
        if (selected == ModelTypes.server.rawValue) {
            model = ModelTypes.server
        } else if (selected == ModelTypes.local.rawValue) {
             model = ModelTypes.local
        }
    }
    
    @IBAction func frequencySelected(_ sender: UIButton) {
        
        var title = sender.titleLabel?.text
        title?.removeLast()
        let selected = Int(title?.lowercased() ?? String(DEFAULT_FREQUENCY))!
        
        frequency = TimeInterval(selected)
    }
    
    @IBAction func apply(_ sender: UIButton) {
        
        let modelApply = model ?? DEFAULT_MODEL
        let frequencyApply = frequency ?? DEFAULT_FREQUENCY
        
        // Send new configuration
        callback?(modelApply, frequencyApply)
        
        // Back to view controller
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConfigVC()
        setupModel()
        setupFrequency()
        setupButtonApply()
    }
    
    // MARK: Private Methods
    private func setupConfigVC() {
         self.title = "Config"
    }
    
    private func setupModel() {
        if (model == ModelTypes.server) {
            radioServer.isSelected = true
        } else if (model == ModelTypes.local) {
            radioLocal.isSelected = true
        }
    }
   
    private func setupFrequency() {
        if (frequency == 1) {
            radio1Second.isSelected = true
        } else if (frequency == 2) {
            radio2Seconds.isSelected = true
        } else if (frequency == 3) {
            radio3Seconds.isSelected = true
        } else if (frequency == 10) {
            radio10Seconds.isSelected = true
        }
    }
    
    private func setupButtonApply() {
        
        /* Button Style */
        buttonApply.backgroundColor = .clear
        buttonApply.layer.cornerRadius = 5
        buttonApply.layer.borderWidth = 1
        buttonApply.layer.borderColor = UIColor.black.cgColor
       
    }
}
