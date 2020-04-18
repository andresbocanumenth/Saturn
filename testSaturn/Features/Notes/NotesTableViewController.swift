//
//  NotesTableViewController.swift
//  testSaturn
//
//  Created by Andres Bocanumenth on 3/26/20.
//  Copyright © 2020 Andres Bocanumenth. All rights reserved.
//

import UIKit
import RealmSwift

class NotesTableViewController: UITableViewController {

    private let notesListViewModel = NotesListViewModel()
    fileprivate let cellIdentifier = "NoteCell"
    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath : DataLoadOperation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        tableView.prefetchDataSource = self
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorColor = .white
        configureBindings()
        Current.syncService.firstLoad()
        Current.syncService.checkForOfflineSync(modelTypes: [OfflineNoteModel.self])
    }
    
    func configureBindings() {
        notesListViewModel.refreshData = {
            self.tableView.reloadData()
        }
    }

    @IBAction func addNoteAction(_ sender: Any) {
        let creationVC = CreationViewController()
        present(creationVC, animated: true, completion: nil)        
    }
    
    @IBAction func refreshIsPulled(_ sender: Any) {
        Current.syncService.firstLoad()
        refreshControl?.endRefreshing()
    }
}

// MARK: - Table view data source

extension NotesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesListViewModel.noteViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? NoteTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.updateUI(viewModel: notesListViewModel.noteViewModels[indexPath.row])
        cell.updateAppearanceFor(.none)
        return cell
    }
}

// MARK:- TableView Delegate

extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? NoteTableViewCell else { return }
        
        // How should the operation update the cell once the data has been loaded?
        let updateCellClosure: (UIImage?) -> () = { [unowned self] (image) in
            cell.updateAppearanceFor(image)
            self.loadingOperations.removeValue(forKey: indexPath)
        }
        
        // Try to find an existing data loader
        if let dataLoader = loadingOperations[indexPath] {
            // Has the data already been loaded?
            if let image = dataLoader.image {
                cell.updateAppearanceFor(image)
                loadingOperations.removeValue(forKey: indexPath)
            } else {
                // No data loaded yet, so add the completion closure to update the cell once the data arrives
                dataLoader.loadingCompleteHandler = updateCellClosure
            }
        } else {
            // Need to create a data loaded for this index path
            let viewModel = notesListViewModel.noteViewModels[indexPath.row]
            if let dataLoader = viewModel.loadImage() {
                // Provide the completion closure, and kick off the loading operation
                dataLoader.loadingCompleteHandler = updateCellClosure
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // If there's a data loader for this index path we don't need it any more. Cancel and dispose
        if let dataLoader = loadingOperations[indexPath] {
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }

}

// MARK:- TableView Prefetching DataSource

extension NotesTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let viewModel = notesListViewModel.noteViewModels[indexPath.row]
            if let _ = loadingOperations[indexPath] { return }
            if let dataLoader = viewModel.loadImage() {
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = loadingOperations[indexPath] {
                dataLoader.cancel()
                loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
}
