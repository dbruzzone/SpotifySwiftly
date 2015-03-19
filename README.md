# Spotify Swiftly

## Why?

I've been learning (and loving) [Swift](https://developer.apple.com/swift/) and am, as of March 2015, working on (and also very much enjoying) my [iOS Developer Nanodegree on Udacity](https://www.udacity.com/course/nd003)...

I plan to build a couple of apps that talk to [Spotify](https://www.spotify.com/) so I decided to port [Spotify's iOS SDK tutorial](https://developer.spotify.com/technologies/spotify-ios-sdk/tutorial/) to Swift (for the purpose of honing my Swift skills as I start learning and using the SDK).

This isn't by any means the first example of this... I referred to, learned from and recommend that you also check out [neonichu's CoolSpot project on GitHub](https://github.com/neonichu/CoolSpot) (and am sure that there are also other good examples that I haven't found yet out there).

## How?

1. `git clone` the project
2. The project uses [CocoaPods](http://cocoapods.org) to manage its dependencies so if you don't already have it, go to [CocoaPods' Getting Started page](http://guides.cocoapods.org/using/getting-started.html) and follow the instructions there
3. Right now, the only dependency that isn't available in your cloned project directory is Spotify's SDK. To download and install the project's dependencies, `cd` into the project's root directory and execute the `pod install` command
4. Double click `Spotify Swiftly.xcworkspace` in Finder to open the project in Xcode
5. [Spotify's iOS SDK tutorial](https://developer.spotify.com/technologies/spotify-ios-sdk/tutorial/) includes excellent instructions about how to set up your token swap service locally as well as [on Heroku](https://github.com/simontaen/SpotifyTokenSwap). Follow these instructions to set up your token swap service.

    By the way, I've included the contents of my `config.ru` file (which is used by Heroku when you deploy the token swap service there) below in case you're wondering what it looks like - [The SpotifyTokenSwap example](https://github.com/simontaen/SpotifyTokenSwap) uses a Procfile and [Heroku currently recommends that you use a config.ru file instead](https://devcenter.heroku.com/articles/rack)...  

  *My config.ru file*
          require './spotify_token_swap'

          run Sinatra::Application

6. In Xcode, find the `kClientId` constant's declaration and replace `your-client-id` with your client ID

At this point, you should have a token swap service running and the app should be ready to run!

**Note:** If you don't have a [Premium Account](https://www.spotify.com/us/premium) on Spotify, you'll receive the following error when when you run the app and log in (because you have to have a premium account to play a track via the SDK):

`An error occured while enabling playback: Error Domain=com.spotify.ios-sdk.playback Code=9 "The operation requires a Spotify Premium account."...`
