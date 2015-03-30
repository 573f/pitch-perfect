//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Stephen Skubik-Peplaski on 3/12/15.
//  Copyright (c) 2015 Stephen Skubik-Peplaski. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    let N:Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl,
                                     fileTypeHint: "mp3",
                                            error: nil)
        audioPlayer.enableRate = true
        
        let session = AVAudioSession.sharedInstance()
        var error: NSError?
        session.setCategory(AVAudioSessionCategoryPlayback, error: &error)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
        session.setActive(true, error: &error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func stopPlayerAndEngine() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudio(playRate: Float) {
        stopPlayerAndEngine()
        
        audioPlayer.rate = playRate
        audioPlayer.play()
    }
    
    func playAudioWithEffect(effect: NSObject) {
        stopPlayerAndEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect as AVAudioNode)
        
        audioEngine.connect(audioPlayerNode, to: effect as AVAudioNode, format: nil)
        audioEngine.connect(effect as AVAudioNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

    @IBAction func playSlowSound(sender: UIButton) {
        playAudio(0.5)
    }
    
    @IBAction func playFastSound(sender: UIButton) {
        playAudio(1.5)
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        var highPitchEffect = AVAudioUnitTimePitch()
        highPitchEffect.pitch = 1000
        playAudioWithEffect(highPitchEffect)
    }

    @IBAction func playDarthSound(sender: UIButton) {
        var lowPitchEffect = AVAudioUnitTimePitch()
        lowPitchEffect.pitch = -1000
        playAudioWithEffect(lowPitchEffect)
    }
    
    @IBAction func playEchoSound(sender: UIButton) {
        var delay = AVAudioUnitDelay()
        delay.delayTime = 0.7
        playAudioWithEffect(delay)
    }
    
    @IBAction func playReverbSound(sender: UIButton) {
        var reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(.Cathedral)
        reverb.wetDryMix = 50
        playAudioWithEffect(reverb)
    }
    
    
    @IBAction func stopPlaying(sender: UIButton) {
        stopPlayerAndEngine()
    }
    
}
