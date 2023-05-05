//
//  App.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 01/05/23.
//

import UIKit

enum Storage: Int {
    case localFile
    case cloudDB
}

struct App {
    static var color: UIColor {
        #if THEME_RED
        return UIColor.systemRed
        #endif

        #if THEME_GREEN
        return UIColor.systemGreen
        #endif
    }

    static var input: UIImagePickerController.SourceType {
        #if MEDIA_CAMERA
        return .camera
        #endif

        #if MEDIA_GALLERY
        return .photoLibrary
        #endif
    }
}


