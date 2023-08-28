//
//  CheezeStep.swift
//  Cheeze
//
//  Created by Heesang on 2023/06/22.
//  Copyright © 2023 organizationName. All rights reserved.
//

import RxFlow
import Photos

enum CZStep: Step {

    case introIsRequired

    case signUpIsRequired
    case signInIsRequired

    case tabBarIsRequired

    case decoIsRequired([PHAsset])
    case galleryIsRequired
    case captureIsRequired
    case homeIsRequired
    case recommendIsRequired
}
