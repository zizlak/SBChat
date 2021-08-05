//
//  UIViewController+Ext.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 16.07.21.
//

import UIKit

extension UIViewController {
    
    func configure<T: SelfConfiguringCell, U: Hashable> (collectionView: UICollectionView, cellType: T.Type, with value: U, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else { fatalError("enable to deque \(cellType)") }
        
        cell.configureWith(value: value)
        return cell
    }
    
    func showAlert(title: String, message: String, completion: @escaping() -> () = {}) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) {_ in
            completion()
        }
        alertController.addAction(ok)
        self.present(alertController, animated: true)
    }
}
