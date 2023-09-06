//
//  AudioPlayer.swift
//  Restart
//
//  Created by Nindya Alita Rosalia on 16/08/23.
//

import Foundation
import AVFoundation

var audioPlayer:  AVAudioPlayer?

func playSound(sound: String, type: String){ //sound: String --> name file, type: String--> file extension
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        }catch{
            print("Can not play this sound")
        }
    }
    
}
