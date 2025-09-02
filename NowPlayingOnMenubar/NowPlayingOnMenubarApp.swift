import SwiftUI

@main
struct NowPlayingOnMenubarApp: App {
    // AppKitのAppDelegateをSwiftUIのライフサイクルに接続する
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings { }
    }
}
