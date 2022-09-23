//
//  UIApplication+Extensions.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/23.
//

import Foundation
import SwiftUI
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    static var appBuildVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}
