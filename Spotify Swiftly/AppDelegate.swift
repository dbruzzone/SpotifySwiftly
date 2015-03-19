//
//  AppDelegate.swift
//  Spotify Swiftly
//
//  Created by Davide Bruzzone on 3/17/15.
//  Copyright (c) 2015 Bitwise Samurai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // Constants
    // TODO: Replace "your-client-id" with your app's client ID
    let kClientId = "your-client-id"
    let kCallbackURL = "spotify-swiftly-login://callback"
    // TODO: If you deploy your token swap service on Heroku, don't forget to specify
    // it's URL here!
    let kTokenSwapURL = "http://localhost:1234/swap"

    var session: SPTSession?
    var player: SPTAudioStreamingController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Create SPTAuth instance; create login URL and open it
        var auth: SPTAuth = SPTAuth.defaultInstance()

        auth.redirectURL = NSURL(string: kCallbackURL)
        auth.tokenSwapURL = NSURL(string: kTokenSwapURL)

        var loginURL: NSURL =
            SPTAuth.loginURLForClientId(kClientId,
                                        withRedirectURL: NSURL(string: kCallbackURL),
                                        scopes: [SPTAuthStreamingScope],
                                        responseType: "code")
        
        // Opening a URL in Safari close to application launch may trigger
        // an iOS bug, so we wait a bit before doing so.
        let params = ["application": application, "loginURL": loginURL]
        var timer =
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("openBrowser:"), userInfo: params, repeats: false)

        return true
    }

    func openBrowser(timer: NSTimer) {
        var userInfo = timer.userInfo as NSDictionary
        var application = userInfo["application"] as UIApplication
        var loginURL = userInfo["loginURL"] as NSURL

        application.openURL(loginURL)
    }

    // Handle auth callback
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {

        // Ask SPTAuth if the URL given is a Spotify authentication callback
        if (SPTAuth.defaultInstance().canHandleURL(url)) {
            // Call the token swap service to get a logged in session
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: { (error: NSError!, session: SPTSession!) in
                if (error != nil) {
                    println("Authentication error: \(error)")

                    return
                }

                self.playUsingSession(session)
            })

            return true
        } else {
            return false
        }
    }

    func playUsingSession(session: SPTSession) {
        // Create a new player if needed
        if (self.player == nil) {
            self.player = SPTAudioStreamingController(clientId: kClientId)
        }

        self.player?.loginWithSession(session, callback: { (error: NSError!) in
            if (error != nil) {
                println("An error occured while enabling playback: \(error)")
                
                return
            }
            
            SPTRequest.requestItemAtURI(NSURL(string: "spotify:album:4L1HDyfdGIkACuygktO7T7"), withSession: nil, callback: { (error: NSError!, id: AnyObject!) in
                if (error != nil) {
                    println("An error occured during album lookup: \(error)")
                    
                    return
                }

                self.player?.playURIs(["spotify:album:4L1HDyfdGIkACuygktO7T7"], withOptions: nil, callback: { (error: NSError!) in
                    if (error != nil) {
                        println("An error occured during album lookup: \(error)")
                        
                        return
                    }
                })
            })
        })
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
