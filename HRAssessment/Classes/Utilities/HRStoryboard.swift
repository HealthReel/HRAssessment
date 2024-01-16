import Foundation
import UIKit

enum HRStoryboard : String {
    case HealthReel
}

extension HRStoryboard {
    var instance : UIStoryboard {
        UIStoryboard(name: rawValue, bundle: Bundle.HRAssessment)
    }
    
    func viewController<T : UIViewController>(_ viewControllerClass : T.Type,
                        function : String = #function, // debugging purposes
                        line : Int = #line,
                        file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        instance.instantiateInitialViewController()
    }
}

extension UIViewController {
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        "\(self)"
    }

    static func instantiate(from storyboard: HRStoryboard) -> Self {
        storyboard.viewController(self)
    }
}

