###To fix macOS Notification Center Widgets bug:

Sometime I slide out my notification center and all the widgets in Today are missing! Here's a way to fix.

1. Open `Terminal`
2.	Type 
	`/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed`
3. Press `Enter` and wait for a while.
4. Go to `System Preference`->`Extensions`->`Today`
5. Now your widgets will all come back.

ref: [https://support.apple.com/en-us/HT203129](https://support.apple.com/en-us/HT203129)
