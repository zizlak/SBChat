//
//  SectionHeader.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 13.07.21.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    //MARK: - Interface
    
    let titleLabel = UILabel()
    
    
    //MARK: - Properties
    
    static let reudeID = String(describing: SectionHeader.self)
    
    
    //MARK: - LifeCycle Methods
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods
    
    private func configure() {
        titleLabel.pin(to: self)
    }
    
    func setupWith(text: String, font: UIFont?, color: UIColor) {
        titleLabel.textColor = color
        titleLabel.font = font
        titleLabel.text = text
    }
    
    //MARK: - Extensions
    
    
    //MARK: - PreviewProvider

}
