//
//  CategoryTableViewCell.swift
//  ScrollViewTest
//
//  Created by Saurabh Jain on 13/05/17.
//  Copyright © 2017 Lalit Kumar. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCollectionView
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        categoryCollectionView.delegate = dataSourceDelegate
        categoryCollectionView.dataSource = dataSourceDelegate
        categoryCollectionView.reloadData()
    }
    
}
