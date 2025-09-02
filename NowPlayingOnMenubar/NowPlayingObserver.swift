import Foundation
import SwiftUI

class NowPlayingObserver: ObservableObject {
  @Published var trackTitle: String = ""
  @Published var trackArtist: String = ""
  @Published var artwork: NSImage? = nil

  var resizedArtwork: NSImage? {
    guard let artwork = artwork else { return nil }

    let newSize = NSSize(width: 18, height: 18)
    let newImage = NSImage(size: newSize)

    newImage.lockFocus()
    artwork.draw(
      in: NSRect(origin: .zero, size: newSize),
      from: NSRect(origin: .zero, size: artwork.size),
      operation: .sourceOver,
      fraction: 1.0
    )
    newImage.unlockFocus()

    return newImage
  }

  private var timer: Timer?

  init() {
    // 3秒ごとに情報を更新
    timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
      self?.updateNowPlayingInfo()
    }
    timer?.fire() // 即時実行
  }

  deinit {
    timer?.invalidate()
  }

  func updateNowPlayingInfo() {
    if let trackInfo = fetchNowPlayingInfo() {
      DispatchQueue.main.async {
        self.trackTitle = trackInfo.title
        self.trackArtist = trackInfo.artist
        self.artwork = trackInfo.artwork
      }
    } else {
      DispatchQueue.main.async {
        self.trackTitle = ""
        self.trackArtist = ""
        self.artwork = nil
      }
    }
  }
}
