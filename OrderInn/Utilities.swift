import CoreGraphics
import Foundation
import UIKit

let noop: () -> Void = { }

struct AnimationUtils {
    private init() {}
    
    static let defaultDuration = 0.3
    private static let scaleTransform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    
    static func animateIn(_ view: UIView) {
        animateIn(view, completion: noop)
    }
    static func animateIn(_ view: UIView, completion: @escaping () -> Void) {
        view.transform = scaleTransform
        view.alpha = 0.0
        UIView.animate(withDuration: defaultDuration, animations: {
            view.alpha = 1.0
            view.transform = CGAffineTransform.identity
        }, completion: { _ in
            completion()
        })
    }
    
    static func animateOut(_ view: UIView) {
        animateOut(view, completion: noop)
    }
    static func animateOut(_ view: UIView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: defaultDuration, animations: {
            view.alpha = 0.0
            view.transform = scaleTransform
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

func log(format: String, args: CVarArg...) {
    NSLog("[OrderInn] \(format)", args)
}
