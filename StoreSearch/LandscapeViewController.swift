//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Irakli Nozadze on 21.06.23.
//

import UIKit

class LandscapeViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var pageControl: UIPageControl!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Remove constraints from main view
    view.removeConstraints(view.constraints)
    view.translatesAutoresizingMaskIntoConstraints = true
    // Remove constraints for page control
    pageControl.removeConstraints(pageControl.constraints)
    pageControl.translatesAutoresizingMaskIntoConstraints = true
    // Remove constraints for scroll view
    scrollView.removeConstraints(scrollView.constraints)
    scrollView.translatesAutoresizingMaskIntoConstraints = true

    view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
    scrollView.contentSize = CGSize(width: 1000, height: 1000)
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let safeFrame = view.safeAreaLayoutGuide.layoutFrame
    scrollView.frame = safeFrame
    pageControl.frame = CGRect(
      x: safeFrame.origin.x,
      y: safeFrame.size.height - pageControl.frame.size.height,
      width: safeFrame.size.width,
      height: pageControl.frame.size.height)
  }

  // MARK: - Navigation
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//   
//   }
}
