LightSaver Roku App
===================

Overview
--------
LightSaver is a Roku SceneGraph app that turns a linked photo collection into a
full-screen wallpaper slideshow. The app pairs with the [LightSaver Web App](https://github.com/wrossman/LightSaver-Web-App) to
link an Adobe Lightroom album, selected Google Photos, or user-uploaded images,
downloads image IDs and keys to the device, and cycles through them with optional
blurred-background mode.

Features
--------
- Pairing flow with QR code and one-time session code.
- Pulls image resources from the LightSaver Web App and caches image IDs and
  keys in the Roku registry.
- Full-screen slideshow with configurable display time.
- Optional blurred background for a layered look.
- Settings screen to adjust timing, toggle background, and revoke access.

Companion Web App
-----------------
The [LightSaver Web App](https://github.com/wrossman/LightSaver-Web-App) is the server that hosts and manages the content the Roku
app pulls from.

How It Works
------------
1) On first launch, the Roku app shows a QR code and session code.
2) You choose your images in the LightSaver Web App after linking your session
   to your device.
3) The app polls the service, retrieves a resource package, and stores it in
   the registry.
4) The wallpaper screen downloads and displays images in a loop, checking for
   updates as needed.

Notes
-----
- The app stores config and resource links in the Roku registry section
  `Config`.
- Fonts are provided under the SIL Open Font License; see
  `components/data/fonts/charger-font/misc/SIL Open Font License.txt`.
