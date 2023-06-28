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

  var searchResults = [SearchResult]()
  private var firstTime = true
  private var downloads = [URLSessionDownloadTask]()

  // MARK: Life Cycle
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
//    scrollView.contentSize = CGSize(width: 1000, height: 1000)
    
    pageControl.numberOfPages = 0
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

    if firstTime {
      firstTime = false
      tileButtons(searchResults)
    }
  }
  
  deinit {
    print("deinit \(self)")
    for task in downloads {
      task.cancel()
    }
  }

  // MARK: - Navigation
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//   
//   }

  // MARK: - Private Methods
  private func tileButtons(_ searchResults: [SearchResult]) {
    let itemWidth: CGFloat = 94
    let itemHeight: CGFloat = 88
    var columnsPerPage = 0
    var rowsPerPage = 0
    var marginX: CGFloat = 0
    var marginY: CGFloat = 0
    let viewWidth = scrollView.bounds.size.width
    let viewHeight = scrollView.bounds.size.height
    columnsPerPage = Int(viewWidth / itemWidth)
    rowsPerPage = Int(viewHeight / itemHeight)
    marginX = (viewWidth - (CGFloat(columnsPerPage) * itemWidth)) * 0.5
    marginY = (viewHeight - (CGFloat(rowsPerPage) * itemHeight)) * 0.5
 
    // Button size
    let buttonWidth: CGFloat = 82
    let buttonHeight: CGFloat = 82
    let paddingHorz = (itemWidth - buttonWidth) / 2
    let paddingVert = (itemHeight - buttonHeight) / 2
    
    // Add the buttons
    var row = 0
    var column = 0
    var x = marginX
    for (index, result) in searchResults.enumerated() {
      let button = UIButton(type: .custom)
      button.setBackgroundImage(UIImage(named: "LandscapeButton"), for: .normal)
      downloadImage(for: result, andPlaceOn: button)
//      button.backgroundColor = UIColor.white
//      button.setTitle("\(index)", for: .normal)
      button.frame = CGRect(
        x: x + paddingHorz,
        y: marginY + CGFloat(row) * itemHeight + paddingVert,
        width: buttonWidth,
        height: buttonHeight)
      scrollView.addSubview(button)
      row += 1
      if row == rowsPerPage {
        row = 0; x += itemWidth; column += 1
        if column == columnsPerPage {
          column = 0; x += marginX * 2
        }
      }
    }
    
    // Set scroll view content size
    let buttonsPerPage = columnsPerPage * rowsPerPage
    let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
    scrollView.contentSize = CGSize(
      width: CGFloat(numPages) * viewWidth,
      height: scrollView.bounds.size.height)
    print("Number of pages: \(numPages)")
    
    pageControl.numberOfPages = numPages
    pageControl.currentPage = 0
  }
  
  private func downloadImage(
    for searchResult: SearchResult,
    andPlaceOn button: UIButton
  ) {
    if let url = URL(string: searchResult.imageSmall) {
      let task = URLSession.shared.downloadTask(with: url) { [weak button] url, _, error in
        if error == nil, let url = url,
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
          DispatchQueue.main.async {
            if let button = button {
              button.setImage(image, for: .normal)
            }
          }
        }
      }
      task.resume()
      downloads.append(task)
    }
  }
  
  // MARK: - Actions
  @IBAction func pageChanged(_ sender: UIPageControl) {
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      options: [.curveEaseInOut],
      animations: {
        self.scrollView.contentOffset = CGPoint(
          x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage),
          y: 0)
      },
      completion: nil)
  }
}


extension LandscapeViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let width = scrollView.bounds.size.width
    let page = Int((scrollView.contentOffset.x + width / 2) / width)
    pageControl.currentPage = page
  }
}
