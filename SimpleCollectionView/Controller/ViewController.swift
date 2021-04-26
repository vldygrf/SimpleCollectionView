//
//  ViewController.swift
//  SimpleCollectionView
//
//  Created by Vladislav Garifulin on 25.04.2021.
//

import UIKit

final class ViewController: UIViewController {
    override func loadView() {
        view = View()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func view() -> View {
        return view as! View
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        view().collectionView.reloadData()
    }
    
    private func setup() {
        view().collectionView.dataSource = self
        view().collectionView.delegate = self
        view().collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        view().refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        let itemsBefore = Image.items
        Image.setAllItems()
        
        var itemsToInsert: [IndexPath] = []
        var j = 0
        for (i, item) in Image.items.enumerated() {
            if ((itemsBefore.count <= j) || (item.path != itemsBefore[j].path)) {
                itemsToInsert.append(IndexPath(row: i, section: 0))
            } else {
                j += 1
            }
        }
        
        view().collectionView.insertItems(at: itemsToInsert)
        view().refreshControl.endRefreshing()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Image.items.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        cell.value = Image.items[indexPath.row]
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? ImageCell,
            cell.didLoaded()
        else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            cell.transform = CGAffineTransform(translationX: collectionView.frame.size.width, y: 0)
        } completion: { _ in
            Image.items.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }
    }
}

