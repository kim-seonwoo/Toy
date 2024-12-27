//
//  UserPoliticalOrientationCalculator.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/27/24.
//

import Foundation
import SwiftUICore

enum PoliticalOrientation: String {
    case farRight = "극우"
    case conservative = "보수"
    case centerRight = "중도 보수"
    case center = "중도"
    case centerLeft = "중도 진보"
    case liberal = "진보"
    case farLeft = "극좌"
    
    var color: Color {
        switch self {
        case .farRight: return .farRight
        case .conservative: return .conservative
        case .centerRight: return .centerRight
        case .center: return .center
        case .centerLeft: return .centerLeft
        case .liberal: return .liberal
        case .farLeft: return .farLeft
        }
    }
}


struct UserPoliticalOrientationCalculator {
    static func calculatePercentage(liberal: Int, conservative: Int) -> (liberalPercentage: Int, conservativePercentage: Int) {
        let total = liberal + conservative
        guard total > 0 else { return (0, 0) }
        
        let liberalPercentage = Int(round(Double(liberal) / Double(total) * 100))
        let conservativePercentage = 100 - liberalPercentage
        
        return (liberalPercentage, conservativePercentage)
    }
    
    static func determinePoliticalOrientation(liberalPercentage: Int) -> PoliticalOrientation {
        switch liberalPercentage {
        case 0..<10:
            return .farRight
        case 10..<30:
            return .conservative
        case 30..<45:
            return .centerRight
        case 45..<55:
            return .center
        case 55..<70:
            return .centerLeft
        case 70..<90:
            return .liberal
        case 90...100:
            return .farLeft
        default:
            return .center // Default fallback
        }
    }
}
