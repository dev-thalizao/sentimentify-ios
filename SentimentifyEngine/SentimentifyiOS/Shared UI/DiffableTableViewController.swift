//
//  DiffableTableViewController.swift
//  SentimentifyiOS
//
//  Created by Thales Frigo on 25/04/21.
//

import UIKit

final class DiffableTableViewController: UITableViewController {
    typealias DiffableDataSource = UITableViewDiffableDataSource<Int, SectionController>

    private lazy var dataSource: DiffableDataSource = {
        let ds = DiffableDataSource(tableView: tableView) { (tableView, index, controller) in
            controller.dataSource.tableView(tableView, cellForRowAt: index)
        }
        ds.defaultRowAnimation = .fade
        return ds
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.register(SearchResultCell.self)
        tableView.register(NextResultsCell.self)
    }

    public func display(_ sections: [SectionController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SectionController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }
        dataSource.apply(snapshot)
    }

    private func sectionController(at indexPath: IndexPath) -> SectionController? {
        return dataSource.itemIdentifier(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let delegate = sectionController(at: indexPath)?.delegate
        delegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let delegate = sectionController(at: indexPath)?.delegate
        delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let delegate = sectionController(at: indexPath)?.delegate
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
}
