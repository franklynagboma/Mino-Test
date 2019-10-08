//
//  ViewController.swift
//  Mino Test
//
//  Created by Franklyn AGBOMA on 04/10/2019.
//  Copyright © 2019 Frankyn AGBOMA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var naijaStarImage: UIImageView!
    @IBOutlet weak var ghanaStartimage: UIImageView!
    @IBOutlet weak var bongoStarImage: UIImageView!
    
    @IBOutlet var naijaButtonView: CustomButton!
    @IBOutlet var ghanaButtonView: CustomButton!
    @IBOutlet var bongoButtonView: CustomButton!
    @IBOutlet weak var itemTableView: UITableView!
    
    let MUSIC__LIST_URL : String  = "https://mynjo-stage.site.com.ng/api/index.php?/Playlists/getTracks/" +
    "00978d67f6933af10ec8bd8045f089a4/0673CC13-476A-4786-BF27-13ADD9C44261/"
    
    let TRACK_URL : String = "https://mynjo-stage.site.com.ng/api/index.php?/Tracks/get/" +
    "00978d67f6933af10ec8bd8045f089a4/0673CC13-476A-4786-BF27-13ADD9C44261/"
    let defaultMusicCode : Int = 9392
    
    var musicListArray = [MusicData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up custom button test color and background color
        naijaButtonView.setButtonTitleAndColor(buttonName: nil, titleColor: .white, baseColor: .lightGray)
        ghanaButtonView.setButtonTitleAndColor(buttonName: nil, titleColor: .white, baseColor: .lightGray)
        bongoButtonView.setButtonTitleAndColor(buttonName: nil, titleColor: .white, baseColor: .lightGray)
        
        //register custom cell file
        itemTableView.register(UINib(nibName: "MusicTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicItemCelll")
        //set auto size for item
        configureTableViewItemSize()
        //Hide or show star image base on selected
        hideOrShowStartImage(tag : defaultMusicCode)
    }


    /*
     The method reffers to the there button hits type.
     Get button tag to trigger the right button hit
     pressed.
     */
    @IBAction func HitsButtonClicked(_ sender: CustomButton) {
        let getTag = sender.tag
        
        hideOrShowStartImage(tag: getTag)
    }
    
    func hideOrShowStartImage(tag : Int) {

        naijaStarImage.isHidden = tag != 9392
        ghanaStartimage.isHidden = tag != 9394
        bongoStarImage.isHidden = tag != 12185
        
        
        makeApiCall(tagInt: tag)
    }
    
    
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
    
    func makeApiCall(tagInt : Int) {
        
        //Http request
        Alamofire.request(getUrl(list: true, idString: String(tagInt)), method: .get, parameters: nil).responseJSON{
            response in
            if response.result.isSuccess {
                //clear the old list
                self.musicListArray.removeAll()
                
                let musicList : JSON = JSON(response.result.value!)
                //print("Music respons: \(musicList)")
                self.sortMusicListItem(json: musicList)
            }
        }
    }
    
    func sortMusicListItem(json : JSON) {
        for count in 0...json.count {
            if let trackId : String = json[count]["track_id"].string {
                let titleText : String = json[count]["title"].string!
                let imageLog : String =  json[count]["image_loc"].string!
                let countDownloads = json[count]["count_downloads"].string!
                let countPlays = json[count]["count_plays"].string!
                
                musicListArray.append(MusicData(trKId: trackId, titleString: titleText, imageString: imageLog, downloadedString: countDownloads, playString: countPlays))

            }
        }
        itemTableView.reloadData()
    }
    
    //set table view data source and size
    //Item to bind
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let musicCell = tableView.dequeueReusableCell(withIdentifier: "MusicItemCelll", for: indexPath) as! CustomTableViewCell
        
        //Present view if list is not empty
        if !musicListArray.isEmpty {
            let data = musicListArray[indexPath.row]
            musicCell.musicTitle?.text = data.titleText
            let url = URL(string: data.imageLog)
            let placeHolder = UIImage(named: "album-placeholder")
            musicCell.musicImage?.af_setImage(withURL: url!, placeholderImage: placeHolder)
            musicCell.playCountButton?.setButtonTitleAndColor(buttonName: "\(data.countPlays) Plays", titleColor: .white, baseColor: .lightGray)
            musicCell.downloadedCountButton?.setButtonTitleAndColor(buttonName: "\(data.countDownloads) Downloadeds", titleColor: .white, baseColor: .lightGray)
        }
        
        return musicCell
    }
    //Item list size
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if musicListArray.isEmpty {
            return 0
        }
        else {
            return musicListArray.count
            
        }
    }
    
    //Set table view row height to an extendable size.
    //This allows item view to fill it container
    func configureTableViewItemSize() {
        itemTableView.rowHeight = UITableView.automaticDimension
        itemTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
}

