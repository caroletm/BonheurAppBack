//
//  SouvenirTheme.swift
//  BonheurApp
//
//  Created by caroletm on 14/10/2025.
//

enum SouvenirTheme: String, Codable, CaseIterable {
    case inspiration
    case social
    case apprentissage
    case energie
    
    var title: String {
        switch self {
        case .inspiration:
            return "Inspiration"
        case .social:
            return "Social"
        case .apprentissage:
            return "Apprentissage"
        case .energie:
            return "Energie"
        }
    }
    
    var iconName: String {
        switch self {
        case .inspiration:
            return "logoRose"
        case .social:
            return "logoBleu"
        case .apprentissage:
            return "logoJaune"
        case .energie:
            return "logoVert"
        }
    }
}
