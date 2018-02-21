//
//  VacancyInteractor.swift
//  hh_test
//
//  Created by Igor Vedeneev on 19.02.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import Foundation

protocol VacanciesInteractorInput : class {
    func loadPage(pageNumber: Int)
}

protocol VacanciesInteractorOutput: class {
    func didLoad(vacancies: [Vacancy], error: Error?, isLastPage: Bool)
}


final class VacanciesInteractor : VacanciesInteractorInput {
    weak var output: VacanciesInteractorOutput?
    private let service: VacancyService
    
    init(service: VacancyService) {
        self.service = service
    }
    
    func loadPage(pageNumber: Int) {
        self.service.vacancies(page: pageNumber, size: VacanciesListPageSize) { [weak self] (vacancies, error, isLast) in
            self?.output?.didLoad(vacancies: vacancies, error: error, isLastPage: isLast)
        }
    }
}
