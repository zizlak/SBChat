//
//  ListVC.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 29.06.21.
//

import UIKit
import FirebaseFirestore



class ListVC: UIViewController {
    //MARK: - Interface
    
    var collectionView: UICollectionView?
    
    enum Section: Int, CaseIterable {
        case waitingChats
        case activeChats
        
        func description() -> String {
            switch self {
            case .waitingChats:
               return "Waiting Chats"
            case .activeChats:
                return "Active Chats"
            }
        }
    }
    
    
    //MARK: - Properties
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    
  //  let activeChats = Bundle.main.decode([MChat].self, from: "activeChats.json")
    var activeChats = [MChat]()
  //  let waitingChats = Bundle.main.decode([MChat].self, from: "waitingChats.json")
    var waitingChats = [MChat]()
    
    private let user: MUser
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    
    
    //MARK: - LifeCycle Methods
    
    init(user: MUser) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        title = user.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchBar()
        createDataSource()
        reloadData()
        
        setupListeners()
    }
    
    
    //MARK: - Methods
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView?.backgroundColor = .mainWhite
        
        view.addSubview(collectionView!)
        collectionView?.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseID)
        collectionView?.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseID)
        
        collectionView?.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reudeID)
        
        collectionView?.delegate = self
    }
    
    
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
    
    
    private func setupListeners() {
        waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { result in
            switch result {
            
            case .success(let chats):
                if !self.waitingChats.isEmpty, self.waitingChats.count <= chats.count {
                    
                    let chatRequestVC = ChatRequestVC(chat: chats.last!)
                    chatRequestVC.delegate = self
                    self.present(chatRequestVC, animated: true)
                }
                
                self.waitingChats = chats
                self.reloadData()

            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
        
        
        activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { result in
            switch result {
            
            case .success(let chats):
                self.activeChats = chats
                self.reloadData()

            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
}



//MARK: - Extensions


//searchBar
extension ListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

// compositional Layout

extension ListVC {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { fatalError() }
            // section -> groups -> items -> sizes
            
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unknown Section") }
            
            switch section {
            
            case .activeChats:
                return self.createActiveChats()
            case .waitingChats:
                return self.createWaitingChats()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    
    private func createWaitingChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 20
        
        //Header
        section.boundarySupplementaryItems = [createSectionHeader()]
        return section
    }
    
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
    
    
    private func createActiveChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 8
        
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return section
    }
    
}


//MARK: - DataSource

extension ListVC {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView!, cellProvider: { [weak self] collectionView, indexPath, chat in
            
            guard let self = self else { return nil }
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown Section") }
            
            switch section {
            case .activeChats:
                return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
            case .waitingChats:
                return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reudeID, for: indexPath) as? SectionHeader,
                  let section = Section(rawValue: indexPath.section)
            else { fatalError("sectionHeader incorrect") }
            
            sectionHeader.setupWith(text: section.description(), font: .laoSangmamMN20, color: #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1))
            return sectionHeader
        }
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapShot.appendSections([.waitingChats, .activeChats])
        snapShot.appendItems(activeChats, toSection: .activeChats)
        snapShot.appendItems(waitingChats, toSection: .waitingChats)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
}

//MARK: - UICollectionViewDelegate

extension ListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     //   let chat = waitingChats[indexPath.row]
        guard let chat = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        
        case .waitingChats:
            let vc = ChatRequestVC(chat: chat)
            vc.delegate = self
            self.present(vc, animated: true)
            
        case .activeChats:
            let vc = ChatsVC(user: self.user, chat: chat)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//MARK: - WaitingChatsNav

extension ListVC: WaitingChatsNav {
    func removeWaiting(chat: MChat) {
        FireStoreService.shared.delete(chat: chat) { result in
            switch result {
            
            case .success():
                self.showAlert(title: "Sucess", message: "Chat with friend \(chat.friendUsername) was deleted")
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func chatToActive(chat: MChat) {
        FireStoreService.shared.changeToActive(chat: chat) { result in
            switch result {
            
            case .success():
                self.showAlert(title: "Sucess", message: "Now you can chat with \(chat.friendUsername)")
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}


//MARK: - PreviewProvider

import SwiftUI

struct ListVCProvider: PreviewProvider {
    
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
