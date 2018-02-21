//
//  Aliases.swift
//  hh_test
//
//  Created by Igor Vedeneev on 13.02.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import Foundation

typealias NetworkResponseCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
typealias VacanciesCompletion = (_ vacancies: [Vacancy], _ error: Error?, _ isLastPage: Bool) -> Void

let VacanciesListPageSize = 20
