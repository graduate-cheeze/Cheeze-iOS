//
//  CheezeStep.swift
//  Cheeze
//
//  Created by Heesang on 2023/06/22.
//  Copyright © 2023 organizationName. All rights reserved.
//

import RxFlow

enum CZStep: Step {

    case introIsRequired

    // MARK: - Auth
    case signUpIsRequired
    case signInIsRequired
    
    case decoIsRequired
}
