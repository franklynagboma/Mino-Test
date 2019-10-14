//
//  DetailsViewController.swift
//  Mino Test
//
//  Created by Franklyn AGBOMA on 09/10/2019.
//  Copyright © 2019 Frankyn AGBOMA. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

class DetailsViewController: UIViewController {

    var musicDetails : MusicData?
    let apiUrl = ApiUrl()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var detaildplayCountLabel: CustomLabel!
    @IBOutlet weak var detailsDownloadCountLabel: CustomLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print("Track ID: \(musicTrackingId)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //only make api call when string is not null
        if let detail = musicDetails {
            //Since detail is the same from previous view,
            //no need to call api, comment for now.
            
            //makeApiCall(musicDetails: detail)
        
            //If api calls is neccessary, uncomment above and comment below setDetailsViewItem
            setDetailsViewItem(musicDetails: detail)
            
        }
        else {
            //show alert
            showAlert()
        }
    }

    
    func makeApiCall(musicDetails : MusicData) {
        
        //Http request
        Alamofire.request(apiUrl.getUrl(list: false, idString: musicDetails.trackId), method: .get, parameters: nil).responseJSON{
            response in
            if response.result.isSuccess {
                let musicData : JSON = JSON(response.result.value!)
                //print("Music details: \(musicData)")
                self.setDetailsViewItem(json: musicData)
            }
        }
    }
    
    //set upd view from Json
    private func setDetailsViewItem(json : JSON) {
        let title = json["track"]["title"].string!
        let imageLog = json["track"]["image_loc"].string!
        let playCount = json["track"]["count_plays"].string!
        
        let details = MusicData(trKId: "", titleString: title, imageString: imageLog, downloadedString: musicDetails!.countPlays, playString: playCount)
        setDetailsViewItem(musicDetails: details)
    }
    //set upd view from bundle
    private func setDetailsViewItem(musicDetails : MusicData) {
        titleLabel.text = musicDetails.titleText
        let url = URL(string: musicDetails.imageLog)
        let placeHolder = UIImage(named: "album-placeholder")
        //let filter = AspectScaledToFitSizeFilter(size: (musicCell.musicImage?.frame.size)!)
        detailsImage.af_setImage(withURL: url!, placeholderImage: placeHolder)
        detaildplayCountLabel.setTextTitleAndColor(lebelTitle: "\(musicDetails.countPlays) Plays", labelColor: .white, groundColor: nil)
        detailsDownloadCountLabel.setTextTitleAndColor(lebelTitle: "\(musicDetails.countDownloads) Downloadeds", labelColor: .white, groundColor: nil)
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "Info!", message: "Track details not found", preferredStyle: .alert)
        let acton = UIAlertAction(title: "Dismiss", style: .cancel){ (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(acton)
        //show alert
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismissDetails(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
