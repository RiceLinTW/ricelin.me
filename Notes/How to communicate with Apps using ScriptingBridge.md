#macOS Development - How to communicate with Apps(iTunes)

###Question: How can I access iTunes nowplaying song's metadata?

1. Open `Terminal`
2. Run `sdef /Applications/iTunes.app | sdp -fh --basename iTunes`
3. Open `Finder`, go to `Users/YOUR_USER_NAME/`, you will see the `iTunes.h` file.
4. Add this protocol to your swift file and you can add properties you want in here.

	```
import ScriptingBridge
@objc protocol iTunesApplication {
    	@objc optional func currentTrack()-> AnyObject
    	@objc optional var properties: NSDictionary {get}
    	//if you need another object or method from the iTunes.h, you must add it here
}
```
5. Happy coding!

	```
	let iTunesApp: AnyObject = SBApplication(bundleIdentifier: "com.apple.iTunes")!
	```
