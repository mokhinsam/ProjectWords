//
//  Extension + UIButton.swift
//  ProjectWords
//
//  Created by Дарина Самохина on 14.08.2024.
//

import UIKit

extension UIButton {
    func tapping() {
        let tap = CASpringAnimation(keyPath: "transform.scale")
        tap.duration = 0.2
        tap.fromValue = 0.9
        tap.toValue = 1
        tap.damping = 0.2
        layer.add(tap, forKey: nil)
    }
}
