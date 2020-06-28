import CoreGraphics
import Foundation
import UIKit

let noop: () -> Void = { }

struct AnimationUtils {
    private init() {}
    
    enum Style {
        case FadeAndDescend
        case FadeAndSlideUp
    }

    static let defaultDuration = 0.3
    private static let defaultStyle = Style.FadeAndDescend
    private static let scaleTransform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    private static let translationProportion: CGFloat = 0.25
    
    private static func transform(forView view: UIView, style: Style) -> CGAffineTransform {
        switch style {
        case .FadeAndDescend:
            return scaleTransform

        case .FadeAndSlideUp:
            return CGAffineTransform(translationX: 0, y: view.bounds.height * translationProportion)
        }
    }

    static func animateIn(_ view: UIView) {
        animateIn(view: view, style: defaultStyle, completion: noop)
    }
    static func animateIn(view: UIView, style: Style) {
        animateIn(view: view, style: style, completion: noop)
    }
    static func animateIn(view: UIView, style: Style, completion: @escaping () -> Void) {
        view.alpha = 0.0
        view.transform = transform(forView: view, style: style)
        UIView.animate(withDuration: defaultDuration, animations: {
            view.alpha = 1.0
            view.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion()
        })
    }

    static func animateOut(_ view: UIView) {
        animateOut(view: view, style: defaultStyle, completion: noop)
    }
    static func animateOut(view: UIView, style: Style) {
        animateOut(view: view, style: style, completion: noop)
    }
    static func animateOut(view: UIView, style: Style, completion: @escaping () -> Void) {
        UIView.animate(withDuration: defaultDuration, animations: {
            view.alpha = 0.0
            view.transform = transform(forView: view, style: style)
        }, completion: { _ in
            view.transform = CGAffineTransform.identity
            completion()
        })
    }
    
    static func fadeIn(_ view: UIView) {
        fadeIn(view, completion: noop)
    }
    static func fadeIn(_ view: UIView, completion: @escaping () -> Void) {
        view.alpha = 0.0
        UIView.animate(withDuration: defaultDuration, animations: {
            view.alpha = 1.0
        }, completion: { _ in
            completion()
        })
    }
}

extension UIViewController {
    func showConfirmAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        })
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

func log(_ format: String, _ args: CVarArg...) {
    withVaList(args) { argPtr in
        NSLogv("[OrderInn] \(format)", argPtr)
    }
}
