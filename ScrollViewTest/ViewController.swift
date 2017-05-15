//
//  ViewController.swift
//  ScrollViewTest
//
//  Created by Saurabh Jain on 13/05/17.
//  Copyright © 2017 Lalit Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let categories = ["apple","carrot","cherries","cupcake","glass","sandwich","cherries","store","tea","apple"]
    var showAllCategories = false
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for products or stores"
        self.navigationItem.titleView = searchController.searchBar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.scrollBanner), userInfo: nil, repeats: true)
    }
    
    func scrollBanner() {
        let indexPath = IndexPath(row: 0, section: 1)
        if let cell = tableView.cellForRow(at: indexPath) as? BannerTableViewCell {
            let indexPath = cell.bannerCollectionView.indexPathsForVisibleItems[0]
            if indexPath.item == 6 {
                var nextIndex = IndexPath(item: 1, section: 0)
                cell.bannerCollectionView.scrollToItem(at: nextIndex, at: .right, animated: false)
                nextIndex = IndexPath(item: 2, section: 0)
                cell.bannerCollectionView.scrollToItem(at: nextIndex, at: .left, animated: true)
            }
            else {
                let nextIndex = IndexPath(item: indexPath.item + 1, section: 0)
                cell.bannerCollectionView.scrollToItem(at: nextIndex, at: .right, animated: true)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 2 {
            let indexPath = IndexPath(row: 0, section: 1)
            if let cell = tableView.cellForRow(at: indexPath) as? BannerTableViewCell {
                let indexPath = cell.bannerCollectionView.indexPathsForVisibleItems[0]
                if indexPath.item == 0 {
                    let nextIndex = IndexPath(item: 5, section: 0)
                    cell.bannerCollectionView.scrollToItem(at: nextIndex, at: .right, animated: false)
                }
                else if indexPath.item == 6 {
                    let nextIndex = IndexPath(item: 1, section: 0)
                    cell.bannerCollectionView.scrollToItem(at: nextIndex, at: .left, animated: false)
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let categoryCell = cell as? CategoryTableViewCell else { return }
            categoryCell.setCollectionView(dataSourceDelegate: self, forRow: indexPath.row)
        }
        if indexPath.section == 1 {
            guard let bannerCell = cell as? BannerTableViewCell else { return }
            bannerCell.setCollectionView(dataSourceDelegate: self, forRow: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath) as! CategoryTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bannerTableViewCell", for: indexPath) as! BannerTableViewCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageTableViewCell", for: indexPath) as! ImageTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if showAllCategories {
                return CGFloat(Double(categories.count / 4 + 1) * 100.0)
            }
            else {
                return 100.0
            }
        }
        return UITableViewAutomaticDimension
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            if !showAllCategories {
                return 4
            }
            return categories.count + 1
        }
        else {
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            if indexPath.item == 3 {
                if showAllCategories {
                    cell.categoryImageView.image = UIImage(named: "up")
                    cell.categoryNameLabel.text = "Less"
                }
                else {
                    cell.categoryImageView.image = UIImage(named: "down")
                    cell.categoryNameLabel.text = "More"
                }
            }
            else {
                if indexPath.item < 3 {
                    cell.categoryImageView.image = UIImage(named: categories[indexPath.item])
                    cell.categoryNameLabel.text = categories[indexPath.item]
                }
                else {
                    cell.categoryImageView.image = UIImage(named: categories[indexPath.item - 1])
                    cell.categoryNameLabel.text = categories[indexPath.item - 1]
                }
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            if indexPath.item == 0 {
                cell.bannerImageView.image = UIImage(named: "banner5")
            }
            else if indexPath.item == 6 {
                cell.bannerImageView.image = UIImage(named: "banner1")
            }
            else {
                cell.bannerImageView.image = UIImage(named: "banner\(indexPath.row)")
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 && indexPath.item == 3 {
            showAllCategories = !showAllCategories
            tableView.reloadSections([0], with: .automatic)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: (view.frame.width - 10)/4, height: 94.0)
        }
        return CGSize(width: view.frame.width, height: 200)
    }
}

