import AppKit
import SwiftUI

// メニューバーに表示するSwiftUIビュー
struct MenuBarView: View {
    @ObservedObject var nowPlayingObserver: NowPlayingObserver

    var body: some View {
        // 曲のタイトルがある場合のみコンテンツを表示
        if !nowPlayingObserver.trackTitle.isEmpty {
            HStack(spacing: 4) {
                if let artwork = nowPlayingObserver.resizedArtwork {
                    Image(nsImage: artwork)
                        .cornerRadius(4)
                } else {
                    Image(systemName: "music.note")
                       .frame(width: 18, height: 18)
                }

                let trackInfo = "\(nowPlayingObserver.trackTitle) - \(nowPlayingObserver.trackArtist)"
                MarqueeText(
                        text: trackInfo,
                        font: .menuBarFont(ofSize: 0)
                    )
                    .frame(width: 7 * 8.5)
                    .id(trackInfo)

            }
            .padding(.horizontal, 4)
        } else {
            // 曲が再生されていない場合は何も表示しない
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var nowPlayingObserver = NowPlayingObserver()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // NSStatusItemをシステムステータスバーに作成
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            // クリック時のアクションを設定
            button.action = #selector(statusItemClicked)
            button.target = self

            // SwiftUIビューをホストする
            let hostingView = NSHostingView(rootView: MenuBarView(nowPlayingObserver: nowPlayingObserver))
            button.addSubview(hostingView)

            // Auto Layoutでサイズを設定
            hostingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hostingView.topAnchor.constraint(equalTo: button.topAnchor),
                hostingView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                hostingView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
                hostingView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            ])
        }
    }

    @objc func statusItemClicked() {
        if let event = NSApp.currentEvent, event.modifierFlags.contains(.option) {
            // Optionキーが押されている場合：終了確認ダイアログを表示
            showQuitConfirmation()
        } else {
            // Optionキーが押されていない場合：Musicアプリを開く
            openMusicApp()
        }
    }

    private func openMusicApp() {
        // Music.appまたはiTunes.appを探して起動する
        let musicURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Music")
        let itunesURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.iTunes")

        if let url = musicURL {
            NSWorkspace.shared.open(url)
        } else if let url = itunesURL {
            NSWorkspace.shared.open(url)
        } else {
            print("Could not find Music or iTunes to open.")
        }
    }

    private func showQuitConfirmation() {
        let alert = NSAlert()
        alert.messageText = "NowPlayingOnMenubarを終了しますか？"
        alert.informativeText = "アプリケーションを終了してもよろしいですか？"
        alert.addButton(withTitle: "終了する")
        alert.addButton(withTitle: "キャンセル")
        alert.alertStyle = .warning

        // ダイアログをモーダルで表示し、最初のボタン（終了する）が押されたか確認
        if alert.runModal() == .alertFirstButtonReturn {
            NSApp.terminate(nil)
        }
    }
}
