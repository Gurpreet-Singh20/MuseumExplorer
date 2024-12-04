//
//  MuseumArtifactsTableViewController.swift
//  MuseumExplorer
//
//  Created by Gurpreet Singh on 2024-11-27.
//

import Foundation
import UIKit

class MuseumArtifactsTableViewController: UITableViewController, NetworkingDelegate {
    
    var artifacts: [MuseumArtifact] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set up the table view
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ArtifactCell")
            
            // Set the NetworkingManager delegate
            NetworkingManager.shared.delegate = self
            
            // Fetch Museum Artifacts from API
            fetchMuseumArtifacts()
        }
        
        // MARK: - Fetching Data
        func fetchMuseumArtifacts() {
            NetworkingManager.shared.getArtifactIDsFromAPI { result in
                   switch result {
                   case .success(let artifactIDs):
                       print("Fetched \(artifactIDs.count) artifact IDs")
                       
                       // Shuffle the artifact IDs to pick random ones
                       let shuffledArtifactIDs = artifactIDs.shuffled()
                       
                       var fetchedArtifacts: [MuseumArtifact] = []
                       let dispatchGroup = DispatchGroup()
                       
                       // Now fetch the details for each random artifact ID (limit to 10 artifacts)
                       for id in shuffledArtifactIDs.prefix(10) {  // Pick the first 10 random IDs
                           dispatchGroup.enter()
                           NetworkingManager.shared.getMuseumArtifactDetailsFromAPI(artifactID: id) { result in
                               switch result {
                               case .success(let artifact):
                                   fetchedArtifacts.append(artifact)
                               case .failure(let error):
                                   print("Failed to fetch artifact details for ID \(id): \(error)")
                               }
                               dispatchGroup.leave()
                           }
                       }
                       
                       // Once all artifact details are fetched, update the table view
                       dispatchGroup.notify(queue: .main) {
                           self.artifacts = fetchedArtifacts
                           self.tableView.reloadData()
                       }
                       
                   case .failure(let error):
                       print("Failed to fetch artifact IDs: \(error)")
                   }
               }
        }

        // MARK: - Table View Data Source Methods
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return artifacts.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArtifactCell", for: indexPath)
            
            // Configure the cell with MuseumArtifact data
            let artifact = artifacts[indexPath.row]
            cell.textLabel?.text = artifact.title
            cell.detailTextLabel?.text = artifact.artistDisplayName
            
            // Removed image display logic
            
            return cell
        }

        // MARK: - NetworkingDelegate Methods
        func networkingDidFinishWithArtifacts(artifacts: [MuseumArtifact]) {
            self.artifacts = artifacts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        func networkingDidFail() {
            // Handle failure (e.g., show an error message)
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "Failed to fetch artifacts", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
