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

class DetailsViewController: UIViewController, SongHasLoaded {

    var musicDetails : MusicData?
    let apiUrl = ApiUrl()
    var fileName : String = ""
    var songId : Int = 0
    private var hasData : Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var detaildplayCountLabel: CustomLabel!
    @IBOutlet weak var detailsDownloadCountLabel: CustomLabel!
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startTimerLable: UILabel!
    @IBOutlet weak var sliderBar: UISlider!
    
    //viewDidLoad is called before viewDidAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print("Track ID: \(musicTrackingId)")
        
        //default view
        songLoaded(loaded: false, isPlaying: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //only make api call when string is not null
        if let detail = musicDetails {
            //Since detail is the same api data set from previous view except for filename(mp3 file url)
            //Get new api data set to retrieve filename(mp3 file url)
            makeApiCall(musicDetails: detail)
        
            //If api calls is neccessary, uncomment above and comment below setDetailsViewItem
            //else do the opposite
            //setDetailsViewItem(musicDetails: detail)
            
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
        let fileName = json["track"]["filename"].string ?? ""
        let id = json["track"]["id"].string!
        let duration = json["track"]["duration"].string!
        let songId = Int (id) ?? -1
        let time = Int (duration) ?? 0
        
        let details = MusicData(trackId: "", titleText: title, imageLog: imageLog, countDownloads: musicDetails!.countDownloads, countPlays: playCount, fileName: fileName, songId: songId, duration: time)
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
        startTimerLable.text = "0:0:0"
        timerLabel.text = MusicPlayer.getInstance().getTimerString(duration: musicDetails.duration)
        
        fileName = musicDetails.fileName
        songId = musicDetails.songId
        
        playOrPause()
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
    
    @IBAction func seekPressed(_ sender: UISlider) {
        MusicPlayer.getInstance().setCurrentlyPlaying(value: false)
    }
    
    @IBAction func seekReleased(_ sender: UISlider) {
        MusicPlayer.getInstance().seekBar(time: Double(sliderBar.value))
        MusicPlayer.getInstance().setCurrentlyPlaying(value: true)
    }
    
    @IBAction func onPlayPauseClicked(_ sender: UIButton) {
        playOrPause()
    }
    
    private func playOrPause() {
        if !fileName.isEmpty && songId > -1 {
            MusicPlayer.getInstance().playOrPauseTrack(url: fileName, songId: songId)
            MusicPlayer.getInstance().delegate(delegateLoaded: self)
        }
        
    }
    
    func songLoaded(loaded: Bool?, isPlaying : Bool) {
        hasData = loaded ?? false
        //set button playOrPause enable
        playOrPauseButton.isEnabled = hasData
        updatePlayOrPauseView(isPlay: isPlaying)
    }
    
    func updateSliderTime(minimum: Float, maximum: Float, progress: Float) {
        sliderBar.minimumValue = minimum
        sliderBar.maximumValue = maximum
        sliderBar.value = progress
        
        //start timer progress
        startTimerLable.text = MusicPlayer.getInstance().getTimerString(duration: Int(progress))
    }
    
    func updatePlayOrPauseView(isPlay : Bool) {
        if isPlay {
            playOrPauseButton.setImage(UIImage(named: "ic_pause_white"), for: .normal)
        }
        else {
            playOrPauseButton.setImage(UIImage(named: "ic_play_white"), for: .normal)
        }
    }
    
    @IBAction func dismissDetails(_ sender: UIButton) {
        MusicPlayer.getInstance().stopTrack()
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
