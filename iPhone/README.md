# Quick start

1. Install the requirement libraries using Cocoapods, NodeJs and Firebase. 

> If you don't have Cocoapods installed, you can do it by following the [installation instructions](https://guides.cocoapods.org/using/getting-started.html#getting-started). 

> If you don't have NodeJS, you can do it by following link: https://nodejs.org

> If you don't have Firebase, you can do it by following link: https://firebase.google.com/docs/cli/

Prepare your GooglePlist file (downloaded from Firebase Console) and run the command (you need to run this only once):

```sh
$ sh setup.sh
```

it's going to replace your config file, install all required dependencies and upload your cloud functions.

2. When all libraries installed, go to **Project.xcworkspace** and open it with Xcode


## Chaneglog

[2.2.0]
Some major update is here with new functionality
* direct messages (as a new tab)
* explore/search profiles (as a new tab)
* display likes and comments count on feed
* bug fixes

[2.1.0]
* compatuble with iPhoneX
* fixed Storyboard rendering (separate into smaller)
* removing own comments added

[2.0.0]
* updated to Swift4
* updated to latest Firebase 4.5
* add firebase analytics (added to documentation)
* added tracers for Firebase Performance, to keep track on app performance
* using remote config for setup colors and background images

[1.8.2]
* fixed script *setup.sh*
* added new video tutorial for setup project
* updated documentation
* added cloud push notification subscription

[1.8.1]
* fix video playback
* performance update

[1.8.0]
* cloud functions used for publishing story
* uses same profile view for non-current user

[1.7.0] 
* allow to report the user/story
* posts, following and followers count on account page
* own stories on account page
* EULA is required in Config file

