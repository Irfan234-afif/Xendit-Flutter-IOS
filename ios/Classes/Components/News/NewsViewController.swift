
import UIKit
import Flutter

class NewsViewController: UIViewController {
    var coordinatorDelegate: NewsCoordinatorDelegate?
    
    override func viewDidLoad() {
//        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        super.viewDidLoad()
    }
    
    @IBAction func goToFlutter(_ sender: Any) {
        coordinatorDelegate?.navigateToFlutter()
    }

}
