//
//  PeopleVC.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 29.06.21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleVC: UIViewController {
    
    
    //MARK: - Interface
    
    var collectionView: UICollectionView!
    
    enum Section: Int, CaseIterable {
        case users
        
        func description(usersCount: Int) -> String {
            switch self {
            case .users:
                return "\(usersCount) people nearby"
            }
        }
    }
    
    
    //MARK: - Properties
    
    var users = [MUser]()
    var dataSource: UICollectionViewDiffableDataSource<Section, MUser>!
    private let user: MUser
    
    private var usersListener: ListenerRegistration?
    
    
    //MARK: - LifeCycle Methods
    
    init(user: MUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        title = user.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        
        setupLogoutButton()
        setupListener()
    }
    
    deinit {
        usersListener?.remove()
    }
    
    //MARK: - Methods
    
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mainWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView?.backgroundColor = .mainWhite
        
        view.addSubview(collectionView!)
        
        collectionView?.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseID)
        
        collectionView?.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reudeID)
        
        collectionView.delegate = self
    }
    
    
    private func setupLogoutButton() {
        let button = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(signout))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc private func signout() {
        let ac = UIAlertController(title: "Are U sure?", message: "Do you really want to log out?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let yes = UIAlertAction(title: "Yes", style: .destructive) { _ in
            do {
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthVC()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        ac.addAction(yes)
        ac.addAction(cancel)
        self.present(ac, animated: true)
    }
    
    private func setupListener() {
        self.usersListener = ListenerService.shared.usersObserve(users: self.users, completion: { result in
            switch result {
            
            case .success(let users):
                self.users = users
                self.reloadData()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
}




//MARK: - Extensions

extension PeopleVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
}



//MARK: - Compositional Layout
extension PeopleVC {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { fatalError() }
            // section -> groups -> items -> sizes
            
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unknown Section") }
            
            switch section {
            case .users:
                return self.createUsersSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    
    private func createUsersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 15)
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
    
    
    private func reloadData(with searchText: String? = nil) {
        let filtered = users.filter { user in
            user.contains(filter: searchText)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, MUser>()
        snapShot.appendSections([.users])
        snapShot.appendItems(filtered, toSection: .users)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    
    
    
    //MARK: - DataSource
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView!, cellProvider: { collectionView, indexPath, user in

            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown Section") }
            
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: UserCell.self, with: user, for: indexPath)
            }
            
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reudeID, for: indexPath) as? SectionHeader,
                  let section = Section(rawValue: indexPath.section)
            else { fatalError("sectionHeader incorrect") }
            
            let items = self.dataSource.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.setupWith(text: section.description(usersCount: items.count), font: .systemFont(ofSize: 36, weight: .light), color: .label)
            
            return sectionHeader
        }
    }
    
}


    //MARK: - UICollectionViewDelegate
extension PeopleVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // let user = users[indexPath.row]
        guard let user = self.dataSource.itemIdentifier(for: indexPath) else { return }
        
        let profileVC = ProfileVC(user: user)
        present(profileVC, animated: true)
    }
}





//MARK: - PreviewProvider
import SwiftUI

struct PeopleVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return MainTabBarController(user: MUser(username: "Stepan", avatarStringURL: "", id: "1", description: "HoHoHo", gender: "male"))
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
