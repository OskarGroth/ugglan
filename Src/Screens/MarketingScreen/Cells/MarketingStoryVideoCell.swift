//
//  MarketingStoryVideoCell.swift
//  Hedvig
//
//  Created by Sam Pettersson on 2019-01-02.
//  Copyright © 2019 Hedvig AB. All rights reserved.
//

import AVKit
import CoreMedia
import Foundation
import UIKit

class MarketingStoryVideoCell: UICollectionViewCell {
    let videoPlayerLayer = AVPlayerLayer()
    let videoPlayer = AVPlayer()
    var duration: TimeInterval = 0
    var cellDidLoad: () -> Void = {}

    override init(frame: CGRect) {
        super.init(frame: frame)
        videoPlayerLayer.videoGravity = .resizeAspectFill
        videoPlayer.isMuted = true
    }

    func play(marketingStory: MarketingStory) {
        backgroundColor = UIColor.from(
            apollo: marketingStory.backgroundColor
        )
        duration = marketingStory.duration

        videoPlayerLayer.frame = bounds
        layer.addSublayer(videoPlayerLayer)

        try? AVAudioSession.sharedInstance().setCategory(
            AVAudioSession.Category.ambient,
            mode: .default,
            options: .mixWithOthers
        )
        try? AVAudioSession.sharedInstance().setActive(true)

        DispatchQueue.global(qos: .background).async {
            guard let playerAsset = marketingStory.playerAsset() else { return }

            let playerItem = AVPlayerItem(asset: playerAsset)
            self.videoPlayer.replaceCurrentItem(with: playerItem)
            self.videoPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            self.videoPlayerLayer.player = self.videoPlayer

            self.videoPlayer.playImmediately(atRate: 1)

            self.cellDidLoad()
        }
    }

    func resume() {
        videoPlayer.playImmediately(atRate: 1)
    }

    func pause() {
        videoPlayer.pause()
    }

    func end() {
        if let duration = videoPlayer.currentItem?.duration {
            videoPlayer.seek(to: duration, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.positiveInfinity)
        }
    }

    func restart() {
        videoPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        videoPlayer.playImmediately(atRate: 1)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
