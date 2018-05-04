//
//  CaptureViewController.swift
//  fzxing
//
//  Created by Trevor Wang on 2018/5/4.
//

import UIKit
import LBXScan

class CaptureViewController: LBXScanViewController  {
    var scanResult: ((_ result:String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

}

extension CaptureViewController: LBXScanViewControllerDelegate {
    public func scanResult(with array: [LBXScanResult]!) {
        for result in array {
            if let str = result.strScanned {
                print(str)
            }
        }
        let value = array.first?.strScanned ?? ""
        self.scanResult?(value)
        self.dismiss(animated: true)
    }
}
