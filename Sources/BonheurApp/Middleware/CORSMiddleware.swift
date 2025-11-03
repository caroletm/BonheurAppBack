//
//  CORSMiddleware.swift
//  BonheurApp
//
//  Created by cyrilH on 03/11/2025.
//

import Gatekeeper
import Vapor
let corsConfiguration = CORSMiddleware.Configuration(
    allowedOrigin: .all,
    allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
    allowedHeaders: [.accept, .authorization, .contentType, .origin],
    cacheExpiration: 800
)
