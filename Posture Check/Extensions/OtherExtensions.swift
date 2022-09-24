//
//  OtherExtensions.swift
//  Posture Check
//
//  Created by Hector Rodriguez on 9/24/22.
//

import SwiftUI

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}

extension DateComponents {
    static func triggerFor(hour: Int, minute: Int, sec: Int) -> DateComponents {
        var component = DateComponents()
        component.calendar = Calendar.current
        component.hour = hour
        component.minute = minute
        component.second = sec
        return component
    }
}


extension Color {
    
    init(hex:String) {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        if ((cString.count) != 6) { self = Color.gray }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        let uiColor = UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
        self = Color(uiColor: uiColor)
    }

}


extension UIApplication {
    
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
            UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBeforeFlag")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    
    var keyWindowCustom: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil}
        guard let window = windowScene.windows.first else { return nil}
        return window
    }
    
}
