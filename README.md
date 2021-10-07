# About this repository
This is a fork of [opus-swift](https://github.com/ybrid/opus-swift). I created this fork because I don't want to integrate foreign binaries, while keep using Swift Package Manager.

# opus-swift
A swift wrapper to use the [Opus Interactive Audio Codec](https://opus-codec.org/) libopus API.

It supports iOS devices and simulators (version 12.4 to latest) and macOS (versions 10.15 to latest)

# Versions
We support version 1.3.1 of [libopus API](https://opus-codec.org/docs/opus_api-1.3.1).

# Integration
After integration use
```swift
import SwiftyOpus
```
in your Swift code.

## Swift Package Management
The Package.swift using this framework should look like
```swift
  ...
  dependencies: [
    .package(
      name: "SwiftyOpus",
      url: "https://github.com/TheJKM/opus-swift.git",
      from: "1.3.1"),
  ...
```
## If you don't use Swift Package Managenment
If you manage packages in another way you may download SwiftyOpus.xcframework.zip from [the latest release of this repository](https://github.com/TheJKM/opus-swift/releases) and embed it into your own project manually.

Unzip the file into a directory called 'Frameworks' of your XCode project. In the properties editor, drag and drop the directory into the section 'Frameworks, Libraries and Embedded Content' of the target's 'General' tab.

# Contributing
You are welcome to contribute, but please also have a look at the [original repository](https://github.com/ybrid/opus-swift) if you want to contribute something.

# Licenses
This project is under MIT license. We create the opus binaries for iOS and macOS from [opus sources of version 1.3.1](https://opus-codec.org/release/stable/2019/04/12/libopus-1_3_1.html). Opus is freely licensed under BSD, see the [LICENSE](https://github.com/TheJKM/opus-swift/blob/master/LICENSE) file.
