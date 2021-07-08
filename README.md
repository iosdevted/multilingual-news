# Maru. <img src = "https://user-images.githubusercontent.com/50784573/116805031-7699d280-ab5e-11eb-8630-c5a50d7d8678.png" width = 50 align = right>

![Language](https://img.shields.io/badge/reactive-RxSwift-red)
![Language](https://img.shields.io/badge/Swift-5.0-ff69b4)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

<a href="https://apps.apple.com/us/app/multilingual-news/id1560598461" > <img src="https://raw.githubusercontent.com/younatics/MotionBook/master/Images/appstore.png" width="170" height="58"></a>

<center>
  <img src="https://user-images.githubusercontent.com/50784573/116805043-89aca280-ab5e-11eb-8f3d-70be951ce9ba.jpg"/>
</center>

This application is for busy multilingual people. Choose your languages from 12 languages and read the latest news with this one application. Keep up-to-date on the latest issues without forgetting the languages

Using Maru you can read

- English
- French
- Japanese
- Korean
- Chinese
- Russian
- German
- Italian
- Portuguese
- Dutch
- Swedish
- Norwegian

on a simple and nice interface.

## Features

- Architecture

  - MVVM Architecture

- Reactive

  - [RxSwift](https://github.com/ReactiveX/RxSwift)

- Image Cache

  - [Kingfisher](https://github.com/onevcat/Kingfisher)

- Cody Style & Convention

  - [SwiftLint](https://github.com/realm/SwiftLint)

- Database

  - [Realm](https://github.com/realm/realm-cocoa)(v1.1.0: Replace from CoreData to Realm)

- UI

  - [SnapKit](https://github.com/SnapKit/SnapKit)
  - [KRProgressHUD](https://github.com/krimpedance/KRProgressHUD)
  - [M13Checkbox](https://github.com/Marxon13/M13Checkbox)

- Tool

  - [Fastlane](https://docs.fastlane.tools/getting-started/ios/setup/)
  - Github Actions

## Update

- v1.2.1: Minor bug fixes and UI improvements.

- v1.2.0: This version introduces a new design & tab bar at the bottom of an app screen.

- v1.1.0: Replace from CoreData to Realm. This version introduces a hamburger tab giving you the ability to change the order of languages.

- v1.0.2: Minor bug fixes and UI improvements.

## Requirements

- iOS 13.0+

## Installation

1. Download the source code by cloning this repository
2. Sign up for [NewsAPI.org](https://newsapi.org) and get your own API Key.
3. Install the pods by running

```
pod install
```

4. Open the xcworkspace file with the latest version of Xcode

## Technical notes

- MVVM - My preferred architecture.
    - MVVM stands for “Model View ViewModel”
    - It’s a software architecture often used by Apple developers to replace MVC. Model-View-ViewModel (MVVM) is a structural design pattern that separates objects into three distinct groups:
- Models hold application data. They’re usually structs or simple classes.
- Views display visual elements and controls on the screen. They’re typically - subclasses of UIView.
- View models transform model information into values that can be displayed on a view. They’re usually classes, so they can be passed around as references.

![MVVM](https://user-images.githubusercontent.com/50784573/116212433-c869e380-a77f-11eb-88f0-f826c6a6ea3e.jpeg)
