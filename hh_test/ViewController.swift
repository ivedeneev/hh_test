//    
//  ViewController.swift
//  hh_test
//
//  Created by Igor Vedeneev on 13.02.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import UIKit


protocol VacanciesViewOutput : class {
    func didRefreshList()
    func loadPageOfData()
    var vacancies: [Vacancy] { get }
}

protocol VacanciesViewInput : class {
    func didLoad(vacancies: [Vacancy])
    func didFail(with error: Error)
}

final class ViewController: UIViewController, VacanciesViewInput {
    private let tableView = UITableView(frame: .zero, style: .plain)
    var output: VacanciesViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupTableView()
        self.loadFirstPage()
        self.showLoadingView()
    }

    //MARK:- Setup
    func setupTableView() {
        self.view.addSubview(self.tableView)
        let margins = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.topAnchor.constraint(equalTo: margins.topAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            ])

        self.tableView.register(VacancyTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.dataSource = self
        self.tableView.rowHeight = 76
        self.tableView.tableFooterView = UIView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    //MARK:- Requests
    func loadFirstPage() {
        self.output.loadPageOfData()
    }
    
    func loadNextPage() {
        self.showLoadingView()
        self.output.loadPageOfData()
    }
    
    //MARK:- Private
    func showLoadingView() {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        view.activityIndicatorViewStyle = .gray
        self.tableView.tableFooterView = view
        view.startAnimating()
    }
    
    func hideLoadingView() {
        self.tableView.tableFooterView = UIView()
    }
    
    @objc func refreshControlValueChanged() {
        self.output.didRefreshList()
    }
}


//MARK:- VacanciesViewInput
extension ViewController {
    func didLoad(vacancies: [Vacancy]) {
        self.tableView.reloadData()
        if self.tableView.refreshControl!.isRefreshing {
            self.tableView.refreshControl!.endRefreshing()
        }
        
        self.hideLoadingView()
    }
    
    func didFail(with error: Error) {
        self.hideLoadingView()
        //TODO: error handling
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.output.vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VacancyTableViewCell
        cell.configure(vacancy: self.output.vacancies[indexPath.row])
        if indexPath.row == self.output.vacancies.count - 3 {
            self.loadNextPage()
        }
        return cell
    }
}

