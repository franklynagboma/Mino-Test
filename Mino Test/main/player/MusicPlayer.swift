//
//  MusicPlayer.swift
//  Mino Test
//
//  Created by Franklyn AGBOMA on 23/10/2019.
//  Copyright © 2019 Frankyn AGBOMA. All rights reserved.
//

import Foundation
import StreamingKit
import MediaPlayer

protocol SongHasLoaded {
    func songLoaded(loaded : Bool?, isPlaying : Bool)
    func updateSliderTime(minimum : Float, maximum : Float, progress : Float)
}

class MusicPlayer : NSObject, STKAudioPlayerDelegate {
    
    private static let instance = MusicPlayer()
    private var timer : Timer?
    private var audioPlayer : STKAudioPlayer!
    private var backgroundSession : Bool = false
    private var isPlaying : Bool = false
    private var currentlyPlaying : Bool = false
    private var shouldPause : Bool = false
    
    private var delegateLoaded : SongHasLoaded?
    
    
    override init() {
        super.init()
        initializePlayer()
        initializeTimer()
    }
    
    internal static func getInstance() -> MusicPlayer {
        return instance
    }
    
    private func initializePlayer() {
        var opts = STKAudioPlayerOptions()
        opts.flushQueueOnSeek = true
        opts.enableVolumeMixer = true
        opts.bufferSizeInSeconds = 200
        opts.secondsRequiredToStartPlayingAfterBufferUnderun = 220
        
        //set up audioPlayer
        audioPlayer = STKAudioPlayer.init(options: opts)
        audioPlayer.delegate = self
    }
    
    private func initializeTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(progressTimer), userInfo: nil, repeats: true)
    }
    
    @objc func progressTimer() {
        
        if audioPlayer.duration != 0 && currentlyPlaying {
            delegateLoaded?.updateSliderTime(minimum: 0, maximum: Float(audioPlayer.duration), progress: Float(audioPlayer.progress))
        }
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        logPrint(type: "audioPlayer start", message: "Song starts")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        logPrint(type: "audioPlayer Buffer", message: "Song finished buffer")
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        logPrint(type: "audioPlayer state", message: "Song state value \(state.rawValue) previousState \(previousState)")
        //When song starts playing state value = 3
        if !shouldPause {
            shouldPause = state.rawValue == 3
        }
        delegateLoaded?.songLoaded(loaded: shouldPause, isPlaying: state.rawValue == 3)
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
        logPrint(type: "audioPlayer Finished", message: "Song finished playing")
        //When song finished
        stopTrack()
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
        logPrint(type: "audioPlayer error", message: "Song Error \(errorCode)")
        //When error occurs on selected song
        stopTrack()
    }
    
    func delegate(delegateLoaded : SongHasLoaded?) {
        self.delegateLoaded = delegateLoaded
    }
    
    //Check if song was playing, pause song else, play song with url sent.
    func playOrPauseTrack(url : String, songId : Int) {
        
        if !isPlaying {
            isPlaying = true
            currentlyPlaying = true
            audioPlayer.play(url, withQueueItemID: songId as NSNumber)
        }
        else {
            //Only perform resume or pause on an already loaded song,
            //i.e, currentlyPlaying is true or false
            if !currentlyPlaying {
                currentlyPlaying = true
                shouldPause = true
                audioPlayer.resume()
            }
            else {
                currentlyPlaying = false
                audioPlayer.pause()
            }
        }
        
        setActive(active: currentlyPlaying)
    }
    
    
    func stopTrack() {
        isPlaying = false
        currentlyPlaying = false
        shouldPause = false
        audioPlayer.stop()
        audioPlayer.clearQueue()
        setActive(active: false)
        delegateLoaded?.songLoaded(loaded: currentlyPlaying, isPlaying: currentlyPlaying)
    }
    
    func seekBar(time : Double) {
        audioPlayer.seek(toTime: time)
    }
    
    
    //Get the duration of current song playing in timer mode
    func getTimerString(duration: Int) -> String {
        let (h, m, s) = intToHMSInt(duration: duration)
        return ("\(h):\(m):\(s)")
    }
    
    //get int duration in Hours, Minutes and Seconds
    private func intToHMSInt(duration : Int) -> (Int, Int, Int) {
        var h = 0
        var m = 0
        var s = 0
        
        if duration > 0{
            h = duration / 3600
            m = (duration % 3600) / 60
            s = (duration % 3600) % 60
        }
        
        return (h, m, s)
    }
    
    func setActive(active : Bool) {
        do {
            try AVAudioSession.sharedInstance().setActive(active)
            //try AVAudioSession.sharedInstance().setActive(active, options: .init())
            
        }
        catch {
            print("Error on track play: \(error)")
        }
    }
    
    func getCurrentlyPlaying() -> Bool {
        return currentlyPlaying
    }
    
    func setCurrentlyPlaying(value : Bool)  {
        currentlyPlaying = value
    }
    
    func logPrint(type : String, message : String) {
        print("\(type) \(message)")
    }
    
    func setUpMusicPlayer() {
        if !backgroundSession {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                backgroundSession = true
            }
            catch {
                print("Failed to set up MusicPlayer")
            }
        }
    }
    
}
