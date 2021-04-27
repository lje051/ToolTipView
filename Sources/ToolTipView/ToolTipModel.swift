//
//  ToolTipModel.swift
//  
//
//  Created by Jeeeun Lim on 2021/04/26.
//

import Foundation

public struct ToolTipInfoModel {
    let title: [String]
    public init(title: [String]) {
        self.title = title
    }
}

public enum ToolTipPosition: Int {
    case left
    case right
    case middle
}
