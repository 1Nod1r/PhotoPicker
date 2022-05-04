//
//  LikesViewController.swift
//  PhotoPicker
//
//  Created by Nodirbek on 04/05/22.
//

import UIKit

class LikesViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LikesTableViewCell.self, forCellReuseIdentifier: LikesTableViewCell.identifier)
        return tableView
    }()
    
    var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        print("imageURL: \(imageURL)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    


}

extension LikesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LikesTableViewCell.identifier, for: indexPath) as? LikesTableViewCell else { return UITableViewCell() }
        cell.set(with: imageURL)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
