//
//  Company.swift
//  TestProject
//
//  Created by 김동우 on 2023/06/01.
//

import Foundation

struct CompanySection {
    let direction: Int
    let companies: [Company]
}

struct Company {
    let companyName: String
    let companyPosition: String
}

extension CompanySection {
    static func getCompanyDummyData() -> [CompanySection] {
        let company1 = Company(companyName: "카카오", companyPosition: "강남역 인근")
        let company2 = Company(companyName: "네이버", companyPosition: "정자역 인근")
        let company3 = Company(companyName: "패스오더", companyPosition: "강남역 근처일듯???")
        
        let companySection1 = CompanySection(direction: 0,
                                             companies: [company1, company2, company3])
        let companySection2 = CompanySection(direction: 1,
                                             companies: [company1, company2, company3])
        let companySection3 = CompanySection(direction: 0,
                                             companies: [company1, company2, company3])
        
        return [ companySection1, companySection2, companySection3 ]
    }
}
