//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Irakli Nozadze on 19.06.23.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var popupView: UIView!
  @IBOutlet weak var artworkImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var kindLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var priceButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }

  // MARK: - Actions
  @IBAction func close() {
    dismiss(animated: true, completion: nil)
  }
}
