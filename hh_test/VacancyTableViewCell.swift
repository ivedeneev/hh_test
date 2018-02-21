//
//  VacancyTableViewCell.swift
//  hh_test
//
//  Created by Igor Vedeneev on 19.02.18.
//  Copyright © 2018 Igor Vedeneev. All rights reserved.
//

import UIKit

final class VacancyTableViewCell : UITableViewCell {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let salaryLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.salaryLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.salaryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        self.titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        self.salaryLabel.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 10).isActive = true
        self.salaryLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        self.salaryLabel.topAnchor.constraint(equalTo: self.titleLabel.topAnchor).isActive = true
        
        self.salaryLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.salaryLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        self.descriptionLabel.textColor = .lightGray
        self.descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        self.descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10).isActive = true
        self.descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(vacancy: Vacancy) {
        self.titleLabel.text = vacancy.title
        self.salaryLabel.text = vacancy.salaryString
        self.descriptionLabel.text = vacancy.companyName
    }
}
