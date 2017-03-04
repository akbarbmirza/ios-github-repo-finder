//
//  SearchSettingsViewController.swift
//  GithubDemo
//
//  Created by Akbar Mirza on 3/1/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class SearchSettingsViewController: UITableViewController {
    
    // Outlets
    //--------------------------------------------------------------------------
    @IBOutlet weak var starsSlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    //--------------------------------------------------------------------------
    
    // Properties
    //--------------------------------------------------------------------------
    weak var delegate: SettingsPresentingViewControllerDelegate?
    
    var settings: GithubRepoSearchSettings!
    //--------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sliderLabel.text = "\(Int(starsSlider.value))"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        self.delegate?.didSaveSettings(settings: settings)
        self.dismiss(animated: true) { 
            print("View Dismissed! Event: Save")
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.delegate?.didCancelSettings()
        self.dismiss(animated: true) {
            print("View Dismissed! Event: Cancelled")
        }
    }

    @IBAction func onSliderChange(_ sender: Any) {
        if let slider = starsSlider {
            let val = Int(slider.value)
            sliderLabel.text = "\(val)"
            self.settings.minStars = val
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
