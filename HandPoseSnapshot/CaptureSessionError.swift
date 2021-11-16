//
//  CaptureSessionError.swift
//  HandPoseSnapshot
//
//  Created by Brayden Harris on 11/15/21.
//

import Foundation

enum CaptureSessionError: Error {
    case cantAddInput
    case cantAddPhotoOutput
    case cantAddVideoDataOutput
//    case lowVNPointConfidence
}
