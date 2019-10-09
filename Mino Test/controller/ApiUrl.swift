//
//  ApiUrl.swift
//  Mino Test
//
//  Created by Franklyn AGBOMA on 09/10/2019.
//  Copyright © 2019 Frankyn AGBOMA. All rights reserved.
//

import Foundation

class ApiUrl {
    
    let MUSIC__LIST_URL : String  = "https://mynjo-stage.site.com.ng/api/index.php?/Playlists/getTracks/" +
    "00978d67f6933af10ec8bd8045f089a4/0673CC13-476A-4786-BF27-13ADD9C44261/"
    
    let TRACK_URL : String = "https://mynjo-stage.site.com.ng/api/index.php?/Tracks/get/" +
    "00978d67f6933af10ec8bd8045f089a4/0673CC13-476A-4786-BF27-13ADD9C44261/"
    
    //return url type and return url
    func getUrl(list : Bool, idString : String) ->  String {
        var url = ""
        if list {
            url = MUSIC__LIST_URL + idString
        }
        else {
            url = TRACK_URL + idString
            
        }
        return url
    }
}
