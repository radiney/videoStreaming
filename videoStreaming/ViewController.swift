//
//  ViewController.swift
//  videoStreaming
//
//  Created by user217360 on 6/6/22.
//

import UIKit
import FirebaseDatabase
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var dataSource : [Video] = []
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchVideos()
    }

    func fetchVideos(){
        database.child("Videos").observeSingleEvent(of: .value) { [weak self] snapShot in
            guard let allObject = snapShot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for object in allObject {
                if let video = object.value as? [String: String],
                   let title = video["title"],
                   let url = video["url"] {
                    self?.dataSource.append(Video(title: title, url: url))
                    self?.tableView.reloadData()
                }
            }
        }
    }

}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viedoURL = URL(string: dataSource[indexPath.row].url) else {
           return
        }
        
        let player = AVPlayer(url: viedoURL)
        let avPlayerVC = AVPlayerViewController()
        avPlayerVC.player = player
        
        present(avPlayerVC, animated: true) {
            player.play()
        }
        
    }
}

