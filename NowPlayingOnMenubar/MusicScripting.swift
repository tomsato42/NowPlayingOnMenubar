import AppKit
import Foundation

struct TrackInfo {
    let title: String
    let artist: String
    let artwork: NSImage?
}

private func imageFromAppleEventDescriptor(_ desc: NSAppleEventDescriptor) -> NSImage? {
    let candidateTypes: [DescType] = [
        desc.descriptorType,
        typeData,
        typeTIFF,
        DescType(FourCharCode("PNGf")),
        DescType(FourCharCode("JPEG"))
    ]

    for t in candidateTypes {
        if t == desc.descriptorType {
            // desc.data は Non-Optional
            let d: Data = desc.data
            if let img = NSImage(data: d) { return img }
        } else if let coerced = desc.coerce(toDescriptorType: t) {
            // coerced.data も Non-Optional
            let d: Data = coerced.data
            if let img = NSImage(data: d) { return img }
        }
    }

    // 最後の手段：そのまま data を読む（Non-Optional）
    let d: Data = desc.data
    if let img = NSImage(data: d) { return img }
    return nil
}

/// four-char から DescType を作るヘルパ
private func FourCharCode(_ s: String) -> OSType {
    var result: UInt32 = 0
    for u in s.utf8 {
        result = (result << 8) + UInt32(u)
    }
    return OSType(result)
}

func fetchNowPlayingInfo() -> TrackInfo? {
    let scriptSource = """
    if application "Music" is running then
      try
        tell application "Music"
          if player state is not playing and player state is not paused then return { "status", "not_playing" }
          tell current track
            set trackName to its name
            set trackArtist to its artist
            set artworkData to missing value
            try
              set artworkData to (get data of artwork 1)
            end try
            return { trackName, trackArtist, artworkData }
          end tell
        end tell
      on error errMsg
        return { "error", "Music - " & errMsg }
      end try
    else if application "iTunes" is running then
      try
        tell application "iTunes"
          if player state is not playing and player state is not paused then return { "status", "not_playing" }
          tell current track
            set trackName to its name
            set trackArtist to its artist
            set artworkData to missing value
            try
              set artworkData to (get data of artwork 1)
            end try
            return { trackName, trackArtist, artworkData }
          end tell
        end tell
      on error errMsg
        return { "error", "iTunes - " & errMsg }
      end try
    else
      return { "status", "app_not_running" }
    end if
    """

    guard let script = NSAppleScript(source: scriptSource) else {
        print("[Debug] FATAL: Failed to create AppleScript object.")
        return nil
    }

    var error: NSDictionary?
    let descriptor = script.executeAndReturnError(&error)

    if let error = error {
        print("[Debug] AppleScript execution error: \(error)")
        print("--- HINT: システム設定 > プライバシーとセキュリティ > オートメーション を確認。'ミュージックを制御' を許可 ---")
        return nil
    }

    // AppleScriptからの成功ケース/ステータスは「リスト」で返す前提
    guard descriptor.descriptorType == typeAEList else {
        // 文字列だけ返ってくるケースもあるのでログして終了
        if let s = descriptor.stringValue {
            print("[Debug] Unexpected string result: \(s)")
        } else {
            print("[Debug] Unexpected descriptor: \(descriptor)")
        }
        return nil
    }

    let itemCount = descriptor.numberOfItems
    if itemCount == 2, let tag = descriptor.atIndex(1)?.stringValue, let value = descriptor.atIndex(2)?.stringValue {
        // { "status", "xxx" } または { "error", "xxx" }
        if tag == "status" {
            print("[Debug] Status: \(value)")
        } else if tag == "error" {
            print("[Debug] Script error (semantic): \(value)")
        } else {
            print("[Debug] Unknown tag: \(tag) value: \(value)")
        }
        return nil
    }

    // 期待形: { trackName, trackArtist, artworkData }
    guard itemCount == 3,
          let title = descriptor.atIndex(1)?.stringValue,
          let artist = descriptor.atIndex(2)?.stringValue
    else {
        print("[Debug] List parsing failed. items=\(itemCount), desc=\(descriptor)")
        return nil
    }

    var image: NSImage? = nil
    if let artDesc = descriptor.atIndex(3) {
        // missing value は typeNull っぽく見えることがある
        let dt = artDesc.descriptorType
        if dt != typeNull {
            image = imageFromAppleEventDescriptor(artDesc)
            if image == nil {
                // デバッグのため4-Char表示
                let t = dt
                let fc = String(bytes: [
                    UInt8((t >> 24) & 0xFF),
                    UInt8((t >> 16) & 0xFF),
                    UInt8((t >> 8) & 0xFF),
                    UInt8(t & 0xFF)
                ], encoding: .macOSRoman) ?? "????"

                // data は Non-Optional なので ?.count は使わない
                let dataSize = artDesc.data.count
                print("[Debug] Artwork present but could not decode. DescType=\(t) '\(fc)' size=\(dataSize)")
}
        }
    }

    return TrackInfo(title: title, artist: artist, artwork: image)
}
