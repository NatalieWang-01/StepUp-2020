//
//  CollectionTableViewCell.swift
//  SummerHack2020
//
//  Created by Kelly Chiu on 7/1/20.
//  Copyright © 2020 momma wang and children. All rights reserved.
//

import UIKit

class KelCollectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    static let identifier = "KelCollectionTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "KelCollectionTableViewCell", bundle: nil)
    }

    func configure(with models: [ShopViewController.Model]) {
        self.models = models
        collectionView.reloadData()
    }

    @IBOutlet var collectionView: UICollectionView!

    var models = [ShopViewController.Model]()

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.register(KelCollectionViewCell.nib(), forCellWithReuseIdentifier: KelCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Collectionview

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KelCollectionViewCell.identifier, for: indexPath) as! KelCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 250)
    }

}
