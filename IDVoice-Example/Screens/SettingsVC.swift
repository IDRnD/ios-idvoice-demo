//
//  SettingsViewController.swift
//  IDVoice-Example
//
//  Created by renks on 28.07.2020.
//  Copyright © 2020 ID R&D. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var verificationThresholdSlider: UISlider!
    @IBOutlet weak var verificationThresholdLabel: UILabel!
    @IBOutlet weak var livenessCheckSwitch: UISwitch!
    @IBOutlet weak var livenessThresholdSlider: UISlider!
    @IBOutlet weak var livenessThresholdStack: UIStackView!
    @IBOutlet weak var livenessThresholdLabel: UILabel!
    @IBOutlet weak var resetEnrollmentsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureResetButton()
        initThresholds()
        initSettingsSwitches()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        configureResetButton()
    }
    
    
    fileprivate func configureUI() {
        view.setBackgroundColor()
        resetEnrollmentsButton.layer.cornerRadius = 10
        resetEnrollmentsButton.clipsToBounds = true
        
        // Checking if Liveness Check is disabled to hide / show liveness threshold setting
        if !UserDefaults.standard.bool(forKey: Globals.isLivenessCheckEnabled) {
            livenessThresholdStack.isHidden = true
        }
    }
    
    
    fileprivate func configureResetButton() {
        if UserDefaults.standard.data(forKey: Globals.textDependentVoiceTemplateKey) != nil || UserDefaults.standard.data(forKey: Globals.textIndependentVoiceTemplateKey) != nil {
            resetEnrollmentsButton.isEnabled = true
            resetEnrollmentsButton.backgroundColor = .redColor
        } else {
            resetEnrollmentsButton.isEnabled = false
            resetEnrollmentsButton.backgroundColor = .systemGray
        }
    }
    
    
    fileprivate func initThresholds() {
        let verificationThreshold = UserDefaults.standard.value(forKey: Globals.verificationThresholdKey) as? Float
        let antispoofingThreshold = UserDefaults.standard.value(forKey: Globals.livenessThresholdkey) as? Float
        
        self.verificationThresholdLabel.text = thresholdToString(verificationThreshold ?? 0.5)
        self.verificationThresholdSlider.value = verificationThreshold ?? 0.5
        
        self.livenessThresholdLabel.text = thresholdToString(antispoofingThreshold ?? 0.5)
        self.livenessThresholdSlider.value = antispoofingThreshold ?? 0.5
    }
    
    
    fileprivate func initSettingsSwitches() {
        if let isLivenessCheckEnabled = UserDefaults.standard.value(forKey: Globals.isLivenessCheckEnabled) as? Bool {
            self.livenessCheckSwitch.isOn = isLivenessCheckEnabled
        } else {
            UserDefaults.standard.set(true, forKey: Globals.isLivenessCheckEnabled)
        }
    }
    
    
    fileprivate func thresholdToString(_ threshold: Float) -> String {
        return String(Int(threshold * 100)) + "%"
    }
    
    
    @IBAction func verificationSliderValueChanged(_ sender: UISlider) {
        self.verificationThresholdLabel.text = thresholdToString(sender.value)
        let threshold = round(100 * self.verificationThresholdSlider.value) / 100
        UserDefaults.standard.set(threshold, forKey: Globals.verificationThresholdKey)
    }
    
    
    @IBAction func livenessCheckSwitchChanged(_ sender: UISwitch) {
        let currentSetting = sender.isOn
        UserDefaults.standard.set(currentSetting, forKey: Globals.isLivenessCheckEnabled)
        
        if sender.isOn {
            UIView.animate(withDuration: 0.5) {
                self.livenessThresholdStack.alpha = 1
                self.livenessThresholdStack.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.livenessThresholdStack.alpha = 0
                self.livenessThresholdStack.isHidden = true
            }
        }
    }
    
    
    @IBAction func livenessSliderValueChanged(_ sender: UISlider) {
        self.livenessThresholdLabel.text = thresholdToString(sender.value)
        let threshold = round(100 * self.livenessThresholdSlider.value) / 100
        UserDefaults.standard.set(threshold, forKey: Globals.livenessThresholdkey)
    }
    
    
    @IBAction func onResetEnrollmentsTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
            UserDefaults.standard.set(nil, forKey: Globals.textDependentVoiceTemplateKey)
            UserDefaults.standard.set(nil, forKey: Globals.textIndependentVoiceTemplateKey)
            self?.configureResetButton()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
