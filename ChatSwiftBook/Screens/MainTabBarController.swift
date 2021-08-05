//
//  MainTabBarController.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 29.06.21.
//

import UIKit

class MainTabBarController: UITabBarController {

    //MARK: - Properties
    
    let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
    var user: MUser
    
    
    //MARK: - LifeCycle Methods
    init(user: MUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    

    
    
    
    //MARK: - Methods

    private func configure() {
        viewControllers = [
            generateNVC(rootVC: PeopleVC(user: user), title: "People", image: UIImage(systemName: "person.2", withConfiguration: boldConfig)),
            generateNVC(rootVC: ListVC(user: user), title: "Conversation", image: UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig))
  
        ]
        
        tabBar.tintColor = #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.968627451, alpha: 1)
    }
    
    
    private func generateNVC(rootVC: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        
        let nvc = UINavigationController(rootViewController: rootVC)
        nvc.tabBarItem.title = title
        nvc.tabBarItem.image = image
        
        return nvc
    }
}
