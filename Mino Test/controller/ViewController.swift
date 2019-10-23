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
    
    var musicDetail : MusicData?
    let apiUrl = ApiUrl()
    
    let defaultMusicCode : Int = 9392
    
    var musicListArray = [MusicData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up custom button test color and background color
        naijaButtonView.setButtonTitleAndColor(buttonName: nil, titleColor: .white, baseColor: nil)
        ghanaButtonView.setButtonTitleAndColor(buttonName: nil, titleColor: .white, baseColor: nil)
        bongoButtonView.setButtonTitleAndColor(buttonName: nil, titleColor: .white, baseColor: nil)
        
        
        
        //register custom cell file
        itemTableView.register(UINib(nibName: "MusicTableViewCell", bundle: nil), forCellReuseIdentifier: "MusicItemCelll")
        
        //set auto size for item
        //configureTableViewItemSize()
        
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
        
        var tagName = ""
        if !naijaStarImage.isHidden {
            naijaButtonView.shakeButton()
            tagName = (naijaButtonView.titleLabel?.text)!
        }
        if !ghanaStartimage.isHidden {
            ghanaButtonView.shakeButton()
            tagName = (ghanaButtonView.titleLabel?.text)!
        }
        if !bongoStarImage.isHidden {
            bongoButtonView.shakeButton()
            tagName = (bongoButtonView.titleLabel?.text)!
        }
        
        makeApiCall(tagInt: tag, tagName: tagName)
    }
    
    
    
    func makeApiCall(tagInt : Int, tagName : String) {
        
        //Http request
        Alamofire.request(apiUrl.getUrl(list: true, idString: String(tagInt)), method: .get, parameters: nil).responseJSON{
            response in
            if response.result.isSuccess {
                //clear the old list
                self.musicListArray.removeAll()
                
                let musicList : JSON = JSON(response.result.value!)
                //print("Music response: \(musicList)")
                self.sortMusicListItem(json: musicList)
            }
            else {
                self.showAlert(tagTitle: tagName)
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
                
                musicListArray.append(MusicData(trackId: trackId, titleText: titleText, imageLog: imageLog, countDownloads: countDownloads, countPlays: countPlays, fileName: "", songId: 0, duration: 0))

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
            //let filter = AspectScaledToFitSizeFilter(size: (musicCell.musicImage?.frame.size)!)
            //print("Image frame: \(musicCell.musicImage?.frame.size)!)")
            musicCell.musicImage?.af_setImage(withURL: url!, placeholderImage: placeHolder)
            musicCell.playCountLabel?.setTextTitleAndColor(lebelTitle: "\(data.countPlays) Plays", labelColor: .white, groundColor: nil)
            musicCell.downloadedCountLabel?.setTextTitleAndColor(lebelTitle: "\(data.countDownloads) Downloadeds", labelColor: .white, groundColor: nil)
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
    
    //Height of cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //Action clicked on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell index row: \(indexPath.row)")
        //get trackID
        musicDetail = musicListArray[indexPath.row]
        //send detail of selected cell to details view
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Check get segue action selected reference
        if segue.identifier == "showDetails" {
            //cast DetailsViewdController to segue destination
            let destinationController = segue.destination as! DetailsViewController
            
            //set trackID in DetailsViewController
            destinationController.musicDetails = musicDetail
        }
    }
    //Set table view row height to an extendable size.
    //This allows item view to fill it container
    func configureTableViewItemSize() {
        itemTableView.rowHeight = UITableView.automaticDimension
        itemTableView.estimatedRowHeight = UITableView.automaticDimension
        print("Item size: \(UITableView.automaticDimension)")
    }
    
    private func showAlert(tagTitle : String?){
        //Should tagTitle ve null/nil, place default string
        var vTitle = "Select Music"
        if let viewTitle = tagTitle {
            vTitle = viewTitle
        }
        
        let alert = UIAlertController(title: "Info!", message: "Mino could not retrieve \(vTitle), please check your internet connection and retry.", preferredStyle: .alert)
        let acton = UIAlertAction(title: "Dismiss", style: .cancel){ (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(acton)
        //show alert
        present(alert, animated: true, completion: nil)
    }
    
    //Minimize application when back is clicked
    @IBAction func dismissMusic(_ sender: UIButton) {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
    }
    
}

