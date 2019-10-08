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
    
    init(trKId : String, titleString : String, imageString : String, downloadedString : String, playString : String) {
        trackId = trKId
        titleText = titleString
        imageLog = imageString
        countDownloads = downloadedString
        countPlays = playString
    }
}
