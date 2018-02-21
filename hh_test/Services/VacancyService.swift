//
//  VacancyService.swift
//  hh_test
//
//  Created by Igor Vedeneev on 13.02.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import Foundation

protocol Deserializable {
    init(json: [String : Any])
}

struct Vacancy : Deserializable {
    let fromSalary: Int?
    let toSalary: Int?
    let title: String?
    let companyName: String?
    let currency: String?
    
    var salaryString: String {
        if self.fromSalary == nil, self.toSalary == nil {
            return "зп не указана"
        }
        
        let currency = self.currency ?? "Р"
        if self.fromSalary != nil && self.toSalary == nil {
            return "от \(self.fromSalary!) \(currency)"
        }
        
        if self.fromSalary == nil && self.toSalary != nil {
            return "до \(self.toSalary!)"
        }
        
        return "от \(self.fromSalary!) до \(self.toSalary!) \(currency)"
    }
    
    init(json: [String : Any]) {
        let salary = json["salary"] as? [String : Any]
        self.fromSalary = salary?["from"] as? Int
        self.toSalary = salary?["to"] as? Int
        self.currency = salary?[""] as? String
        self.title = json["name"] as? String
        let employerDict = json["employer"] as? [String : Any]
        self.companyName = employerDict?["name"] as? String
    }
}

protocol VacancyService {
    func vacancies(page: Int, size: Int, completion: @escaping VacanciesCompletion)
}

final class VacancyServiceImpl : VacancyService {
    private let networkClient: NetworkClient
    private let mapper: Mapper<Vacancy>
    
    init(networkClient: NetworkClient, mapper: Mapper<Vacancy>) {
        self.networkClient = networkClient
        self.mapper = mapper
    }
    
    func vacancies(page: Int, size: Int, completion: @escaping VacanciesCompletion) {
        let url = URL(string: "https://api.hh.ru/vacancies?per_page=\(size)&page=\(page)")!
        let request = NSMutableURLRequest(url: url)
        self.networkClient.send(request: request as URLRequest) { [weak self] (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion([], error, false)
                    
                }
                return
            }
            
            if let vacancies = self?.mapper.map(data: data!) {
                DispatchQueue.main.async {
                    completion(vacancies, nil, vacancies.count < size)
                }
            }
        }
    }
}

class Mapper<T: Deserializable> {
    func map(data: Data) -> [T] {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return [] }
        guard let json_ = json!["items"] as? [[String : Any]] else { return [] }
        return json_.map { ar in T(json: ar) }
    }
}
