//
//  BundleExtension.swift
//  SiriusRating
//
//  Created by Thomas Neuteboom on 08/09/2022.
//  Copyright © 2022 The App Capital. All rights reserved.
//

import UIKit

extension Bundle {

    // Name of the app; the title under the app icon.
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
            object(forInfoDictionaryKey: "CFBundleName") as? String
    }

    var appIcon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last
        {
            return UIImage(named: lastIcon)
        }
        return nil
    }

    var bundleVersion: String {
        guard let bundleVersion = object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("Could not find `CFBundleVersion` in the info dictionary of the bundle.")
        }

        return bundleVersion
    }

}
