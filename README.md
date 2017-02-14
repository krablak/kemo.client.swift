# 🚀 Kemo client for OS X 🚀 #

OS X client for end2end encrypted messaging [kemo.rocks](https://kemo.rocks) implemented in Swift and little bit of JS. Project is still in development but feel free to use it for whatever you want.

More about project releases and update can be found on [blog.kemo.rocks](http://blog.kemo.rocks).

### Project Structure ###

Here are some important points in projects structure:

- **ViewController.swift** classic heart of application
- **ChatCommands.swift** components handling special chat commands. Right place for extending application features.
- **UIComponents.swift** custom UI components (like messages view)
- **UIComponents.swift** custom UI components (like chat view)
- **KeyUtils.swift** bridge to [zxcvbn](https://github.com/dropbox/zxcvbn) JS implementation. JS sources are stored within *js/* folder.
- **Dependencies/** third-party and Kemo core libraries

### Prerequisities

- Xcode Version 8.2 

### Building ###
Just import project into Xcode, build and run.

### Who do I talk to? ###

Contact me on twitter [@krablak](https://twitter.com/krablak) or via our team email [team@kemo.rocks](mailto:team@kemo.rocks). Any feedback is welcome.

### Licences ###

We are using following third party libraries, so please respect their licences:

- [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift)
- [Starscream](https://github.com/daltoniam/Starscream)
- [zxcvbn](https://github.com/dropbox/zxcvbn)