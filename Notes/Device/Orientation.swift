//
//  Orientation.swift
//  Notes
//
//  Created by smartway on 20.06.2022.
//

import UIKit

struct Orientation {
    static var isPortrait: Bool {
        get {
            return UIDevice.current.orientation.isValidInterfaceOrientation
                ? UIDevice.current.orientation.isPortrait
                : UIApplication.shared.statusBarOrientation.isPortrait
        }
    }
}
