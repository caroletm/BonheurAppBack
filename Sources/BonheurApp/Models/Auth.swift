//
//  Auth.swift
//  BonheurApp
//
//  Created by cyrilH on 23/10/2025.
//

import Vapor
struct loginRequest: Content{
    let email: String
    let motDePasse: String
}

