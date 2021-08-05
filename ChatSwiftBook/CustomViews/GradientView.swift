//
//  GradientView.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 03.07.21.
//

import UIKit

class GradientView: UIView {
    
    //MARK: - Interface
    
    private var gradientLayer = CAGradientLayer()
    
    //MARK: - Properties
    
    @IBInspectable private var startColor: UIColor? {
        didSet {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    }
    
    @IBInspectable private var endColor: UIColor? {
        didSet {
            setupGradientColors(startColor: startColor, endColor: endColor)
        }
    }
    
    
    //MARK: - LifeCycle Methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient(from: .leading, to: .trailing, start: .white, end: .black)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient(from: .leading, to: .trailing, start: .white, end: .black)
    }
    
    convenience init(from: Point, to: Point, start: UIColor?, end: UIColor?) {
        self.init()
        setupGradient(from: from, to: to, start: start, end: end)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    
    
    //MARK: - Methods
    
    private func setupGradient(from: Point, to: Point, start: UIColor?, end: UIColor?) {
        self.layer.addSublayer(gradientLayer)
        setupGradientColors(startColor: start, endColor: end)
        
        gradientLayer.startPoint = from.point
        gradientLayer.endPoint = to.point
        
    }
    
    
    private func setupGradientColors(startColor: UIColor?, endColor: UIColor?) {
        guard let startColor = startColor, let endColor = endColor else { return }
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    //MARK: - Extensions
    
    
    //MARK: - PreviewProvider
}


