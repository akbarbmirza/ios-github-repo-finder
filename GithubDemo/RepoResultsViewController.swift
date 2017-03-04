//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol SettingsPresentingViewControllerDelegate: class {
    func didSaveSettings(settings: GithubRepoSearchSettings)
    func didCancelSettings()
}

// Main ViewController
class RepoResultsViewController: UIViewController {

    // Outlets
    //--------------------------------------------------------------------------
    @IBOutlet weak var tableView: UITableView!
    //--------------------------------------------------------------------------
    
    // Properties
    //--------------------------------------------------------------------------
    var searchBar: UISearchBar!
    var defaultSearchSettings = GithubRepoSearchSettings()
    var searchSettings = GithubRepoSearchSettings()
    
    var repos: [GithubRepo]!
    //--------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tableView delegates and source
        tableView.dataSource = self
        tableView.delegate = self
        
        // give the tableView an estimate before it figures out the actual height
        tableView.estimatedRowHeight = 120
        // tell rowHeight to use AutoLayout Parameters
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        // Perform the first search when the view controller first loads
        doSearch()
    }

    // Perform the search.
    fileprivate func doSearch() {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in

            // Print the returned repositories to the output window
            for repo in newRepos {
                print(repo)
            }
            
            // store the newRepos in repos property
            self.repos = newRepos
            
            // reload tableView
            self.tableView.reloadData()

            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let navController = segue.destination as! UINavigationController
        let viewController = navController.topViewController as! SearchSettingsViewController
        // Search Settings
        viewController.settings = self.searchSettings
        viewController.delegate = self
    }
}

// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}

extension RepoResultsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if repos != nil {
            return repos.count
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoCell
        
        let repo = repos[indexPath.row]
        
        cell.titleLabel.text = repo.name!
        cell.ownerLabel.text = repo.ownerHandle!
        cell.starLabel.text = "\(repo.stars!)"
        cell.forkLabel.text = "\(repo.forks!)"
        cell.descriptionLabel.text = repo.repoDescription!
        cell.avatarImageView.setImageWith(URL(string: repo.ownerAvatarURL!)!)
        
        return cell
        
    }
    
}

extension RepoResultsViewController: SettingsPresentingViewControllerDelegate {

    func didSaveSettings(settings: GithubRepoSearchSettings) {
        self.searchSettings = settings
        doSearch()
    }
    
    func didCancelSettings() {
        // do nothing
        if self.searchSettings.minStars != defaultSearchSettings.minStars {
            self.searchSettings = defaultSearchSettings
            doSearch()
        }
    }

    
}
