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
    var isBeep = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nil
        self.delegate = self
        self.libraryType = SCANLIBRARYTYPE.SLT_ZXing
        self.setScanStyle()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action:
            #selector(CaptureViewController.close))
    }

    private func setScanStyle() {
        let style = LBXScanViewStyle()
        style.photoframeAngleStyle = .outer
        style.anmiationStyle = .lineMove
        self.style = style
    }
    
    @objc func close() {
       self.dismiss(animated: true)
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
        #if DEBUG
        if (isBeep) {
            AudioServicesPlaySystemSound(1005)
        }
        #endif
        self.dismiss(animated: true)
    }
}
