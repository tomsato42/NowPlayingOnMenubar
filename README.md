# NowPlayingOnMenubar

A macOS menu bar application that displays the currently playing song from Apple Music (or iTunes).

## Features

-   Displays current track's artwork, title, and artist in the menu bar.
-   Clicking the menu bar item launches the Music.app (or iTunes.app).
-   **Option-Click to Quit:** Hold down the `Option` (⌥) key and click the menu bar item to bring up a confirmation dialog to quit the application. This is useful as the application runs in the background without a Dock icon.

## Usage

1.  Build and run the project using Xcode.
2.  Ensure Music.app (or iTunes.app) is running and playing a song.
3.  The song information will appear in your macOS menu bar.

## Important Security Note: Running Unsigned Applications

When you download applications from the internet that are not from the Mac App Store or not signed by an identified developer, macOS's built-in security feature, Gatekeeper, will prevent them from opening by default. This is a crucial security measure designed to protect your system from potentially malicious software.

**This application is currently unsigned.** Therefore, when you first attempt to open it after downloading, you will likely encounter a warning message such as "App can't be opened because it is from an unidentified developer."

**Proceed with caution.** Only run applications from sources you trust. If you understand the risks and wish to proceed, you can bypass Gatekeeper using the following steps:

1.  Locate the application icon in Finder.
2.  **Right-click** (or Control-click) the the application icon.
3.  Select "Open" from the contextual menu.
4.  In the dialog that appears, you will now see an "Open" button. Click it to launch the application.

After performing these steps once, you should be able to open the application normally by double-clicking it.

## Compatibility

-   **Tested Environment:** Confirmed to be working on **M4 macOS Sequoia 15.6**.

## License

This application is provided for **non-commercial use** only.

---

# NowPlayingOnMenubar

macOSのメニューバーに、Apple Music（またはiTunes）で現在再生中の曲情報を表示するアプリケーションです。

## 機能

-   現在再生中の曲のアートワーク、タイトル、アーティストをメニューバーに表示します。
-   メニューバーの項目をクリックすると、Music.app（またはiTunes.app）が起動します。
-   **Optionキーを押しながらクリックで終了:** `Option` (⌥) キーを押しながらメニューバーの項目をクリックすると、アプリケーションを終了するための確認ダイアログが表示されます。このアプリケーションはDockアイコンなしでバックグラウンドで動作するため、この機能が便利です。

## 使用方法

1.  Xcodeを使用してプロジェクトをビルドし、実行します。
2.  Music.app（またはiTunes.app）が起動しており、曲が再生中であることを確認してください。
3.  曲情報がmacOSのメニューバーに表示されます。

## 互換性

-   **動作確認環境:** **M4 macOS Sequoia 15.6** で動作することを確認済みです。

## ライセンス

このアプリケーションは**非商用利用のみ**に提供されます。

## 同梱物

-   このプロジェクトのソースコード
-   ビルド済みのアプリケーション
