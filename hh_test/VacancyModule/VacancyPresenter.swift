//
//  VacancyPresenter.swift
//  hh_test
//
//  Created by Igor Vedeneev on 19.02.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import Foundation

final class VacanciesPresenter : VacanciesViewOutput, VacanciesInteractorOutput {
    weak var view: VacanciesViewInput?
    var interactor: VacanciesInteractorInput!
    private var hasNextPage: Bool = true
    private var isLoading: Bool = false
    var vacancies: [Vacancy] = []
}


//MARK:- VacanciesViewOutput
extension VacanciesPresenter {
    func loadPageOfData() {
        guard self.hasNextPage && !self.isLoading else { return }
        self.isLoading = true
        self.interactor.loadPage(pageNumber: self.vacancies.count / VacanciesListPageSize)
    }
    
    func didRefreshList() {
        self.isLoading = false
        self.hasNextPage = true
        self.vacancies.removeAll()
        self.loadPageOfData()
    }
}


//MARK:- VacanciesInteractorOutput
extension VacanciesPresenter {
    func didLoad(vacancies: [Vacancy], error: Error?, isLastPage: Bool) {
        self.isLoading = false
        
        if error != nil {
            self.hasNextPage = true
            self.view?.didFail(with: error!)
            return
        }
        
        self.hasNextPage = !isLastPage
        self.vacancies.append(contentsOf: vacancies)
        self.view?.didLoad(vacancies: vacancies)
    }
}

