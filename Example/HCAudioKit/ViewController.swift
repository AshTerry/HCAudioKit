//
//  ViewController.swift
//  HCAudio
//
//  Created by HC on 12/20/2021.
//  Copyright (c) 2023 HC. All rights reserved.
//

import UIKit
import HCAudioPlayer
import AudioToolbox
import AVFAudio
import AVFoundation

class ViewController: UIViewController {
    
    lazy var btn: UIButton = {
        let btn = UIButton(frame: .init(x: 0, y: 0, width: 100, height: 50))
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(onPressedPlay), for: .touchUpInside)
        return btn
    }()
    
    
    let appid = "6635E33E5775ECAE"
    let secret = "LlrjO93bv8a5L0HbP0BcedRB+Ex1iiNGXi2JCZl757k="
    
    lazy var player = {
        let player = try? Player(appid, secret: secret)
        player?.delegate = self
        return player
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.btn.center = self.view.center
        self.view.addSubview(self.btn)
        
        self.view.backgroundColor = .purple
        
        let noteName = Notification.Name(rawValue:HCPlayerNotification.TimeTickNotification.rawValue)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(listenTimeTick(note:)),
                                               name: noteName,
                                               object: nil)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.player?.clearCache()
        
        if let path = Bundle.main.path(forResource: "plan", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
           let str = String.init(data: data, encoding: .utf8) {
            self.player?.updateConfigure(str)
        }
    }
    
    @objc func listenTimeTick(note: Notification) {
        guard let userInfo = note.userInfo,
              let tick: Int = userInfo["tick"] as? Int  else {
            return
        }
         
        debugPrint("tick:\(tick)")
    }
    
}

extension ViewController : HCPlayerDelegate{
    func onPlayerDidStop(player: HCAudioPlayer.Player) {
        debugPrint(#function)
    }
    
    func onPlayerDidPause(player: HCAudioPlayer.Player) {
        debugPrint(#function)

    }
    
    func onPlayerDidStart(player: HCAudioPlayer.Player) {
        debugPrint(#function)

    }
    
    func onAllFileDidDownload(_ player: HCAudioPlayer.Player, succeed: Set<String>, failed: Set<String>) {
        print(#function)
        player.play()
    }
    
    func onSomeCacheDidFinish(_ player: HCAudioPlayer.Player) {
        print(#function)
        player.play()
    }
    
    @objc func onPressedPlay() {
        switch(self.player?.status){
        case .playing:
            self.player?.pause()
        case .stopped:
            self.player?.play()
        case .paused:
            self.player?.play()
        case .none:
            debugPrint(#function)
        }
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        self.player?.stop()
    }
}
