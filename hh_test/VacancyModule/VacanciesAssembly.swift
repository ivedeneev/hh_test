//
//  VacanciesAssembly.swift
//  hh_test
//
//  Created by Igor Vedeneev on 19.02.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import Foundation
import UIKit.UIViewController

final class VacanciesAssembly {
    var view: UIViewController?
    
    init() {
        let networkClient = NetworkClientImpl(session: URLSession.shared)
        let mapper = Mapper<Vacancy>()
        let vacancyService = VacancyServiceImpl(networkClient: networkClient, mapper: mapper)
        
        let interactor = VacanciesInteractor(service: vacancyService)
        let presenter = VacanciesPresenter()
        let view = ViewController()
        
        view.output = presenter
        interactor.output = presenter
        presenter.interactor = interactor
        presenter.view = view
        
        self.view = view
    }
}
