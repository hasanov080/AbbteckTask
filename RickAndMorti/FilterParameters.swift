//
//  FilterParameters.swift
//  RickAndMorti
//
//  Created by Hasan Hasanov on 27.10.22.
//

import Foundation

enum FilterType{
    case texfield
    case options
}

struct FilterData{
    static var filterOptions = [
        FilterData(title: "Name", type: .texfield, selectedTextField: true),
        FilterData(title: "Species", type: .texfield, selectedTextField: false),
        FilterData(title: "Gender", options: ["Gender", "female", "male", "genderless", "unkown"], type: .options, selectedOptionIndex: 0),
        FilterData(title: "Status", options: ["Status" ,"alive", "dead", "unknown"], type: .options, selectedOptionIndex: 0),
    ]
    var title: String
    var options: [String]? = nil
    var type: FilterType
    var selectedOptionIndex = 0
    var selectedTextField = false
}
