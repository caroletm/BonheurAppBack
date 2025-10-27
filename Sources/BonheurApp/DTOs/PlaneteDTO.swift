//
//  PlaneteDTO.swift
//  BonheurApp
//
//  Created by caroletm on 26/10/2025.
//

import Fluent
import Vapor

struct PlaneteDTO: Content {
    var id: UUID?
    var nom : String
    var description : String
    var image : String
    var onboardingDescription : String
    var iconOnboarding : String
    var backgroundPlanete : String
}

struct UpdatePlaneteDTO : Content {
    var nom : String?
    var description : String?
    var image : String?
    var onboardingDescription : String?
    var iconOnboarding : String?
    var backgroundPlanete : String?
}
