## [Project 22: Detect-a-Beacon](https://www.hackingwithswift.com/read/22/overview)
Written by [Paul Hudson](https://www.hackingwithswift.com/about)  ![twitter16](https://github.com/juliangyurov/PH-Project6a/assets/13259596/445c8ea0-65c4-4dba-8e1f-3f2750f0ef51)
  [@twostraws](https://twitter.com/twostraws)

**Description:** Learn to find and range iBeacons using our first project for a physical device.

- Setting up

- Requesting location: `Core Location`

- Hunting the beacon: `CLBeaconRegion`

- Wrap up

  
## [Review what you learned](https://www.hackingwithswift.com/review/hws/project-22-detect-a-beacon)

**Challenge**

1. Write code that shows a `UIAlertController` when your beacon is first detected. Make sure you set a Boolean to say the alert has been shown, so it doesn’t keep appearing.

2. Go through two or three other iBeacons in the `Detect Beacon` app and add their `UUIDs` to your app, then register all of them with iOS. Now add a second label to the app that shows new text depending on which beacon was located.

3. Add a circle to your view, then use animation to scale it up and down depending on the distance from the beacon – try 0.001 for unknown, 0.25 for far, 0.5 for near, and 1.0 for immediate. You can make the circle by adding an image, or by creating a view that’s 256 wide by 256 high then setting its `layer.cornerRadius` to 128 so that it’s round.
