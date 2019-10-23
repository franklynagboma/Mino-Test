//
//  MusicData.swift
//  Mino Test
//
//  Created by Franklyn AGBOMA on 08/10/2019.
//  Copyright © 2019 Frankyn AGBOMA. All rights reserved.
//

import Foundation

class MusicData {
    let trackId : String
    let titleText : String
    let imageLog : String
    let countDownloads : String
    let countPlays : String
    let fileName : String
    let songId : Int
    let duration : Int
    
    init(trackId : String, titleText : String, imageLog : String, countDownloads : String, countPlays : String, fileName : String, songId : Int, duration : Int) {
        self.trackId = trackId
        self.titleText = titleText
        self.imageLog = imageLog
        self.countDownloads = countDownloads
        self.countPlays = countPlays
        self.fileName = fileName
        self.songId = songId
        self.duration = duration
    }
}
