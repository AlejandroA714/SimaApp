import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        guard hexSanitized.count == 6 || hexSanitized.count == 8 else { return nil }
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        if hexSanitized.count == 6 {
            let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(rgb & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        } else { // ✅ caso con alfa (RRGGBBAA)
            let r = CGFloat((rgb & 0xFF00_0000) >> 24) / 255.0
            let g = CGFloat((rgb & 0x00FF_0000) >> 16) / 255.0
            let b = CGFloat((rgb & 0x0000_FF00) >> 8) / 255.0
            let a = CGFloat(rgb & 0x0000_00FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: a)
        }
    }
}
