//
//  EneGIVE - LaunchViewController
//  Copyright © 2017 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    convenience init() {
        self.init(nibName: "LaunchView", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
