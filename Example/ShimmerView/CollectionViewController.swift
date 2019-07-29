//
//  CollectionViewController.swift
//  ShimmerView
//
//  Created by Drouin on 23/07/2019.
//  Copyright © 2019 VersusMind. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.startShimmerAnimation(withIdentifier: "collectionShimmerCell", numberOfRows: 25, numberOfSections: 1)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.collectionView.stopShimmerAnimation(animated: true)
        })
    }
}

extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionShimmerCell", for: indexPath)
        return cell
    }
}
