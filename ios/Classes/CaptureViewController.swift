//
//  CaptureViewController.swift
//  fzxing
//
//  Created by Trevor Wang on 2018/5/4.
//

import UIKit
import LBXScan
import Foundation
import AVFoundation

class CaptureViewController: LBXScanViewController  {
    var scanResult: ((_ result:String) -> Void)?
    var isBeep = false
    var isContinuous = false
    var player = AVAudioPlayer()
    
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
    
    func playSound() {
        let frameworkBundle = Bundle(for: CaptureViewController.self)
        if let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("fzxing.bundle") {
            let beepFile = Bundle(url: bundleURL)?.url(forResource: "beep", withExtension: "mp3")
            do {
                player = try AVAudioPlayer(contentsOf: beepFile! )
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                player.volume = 0.5
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
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
        
        if(isBeep) {
        playSound()

        }
        
        self.scanResult?(value)
        if (isContinuous) {
            self.reStartDevice()
        } else{
            self.dismiss(animated: true)
        }
    }
}
