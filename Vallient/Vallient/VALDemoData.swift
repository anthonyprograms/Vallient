//
//  VALDemoData.swift
//  Vallient
//
//  Created by Anthony Williams on 6/18/16.
//  Copyright © 2016 Anthony Williams. All rights reserved.
//

import UIKit
import CoreLocation

class VALDemoData: NSObject {
    struct data {
        var name: String
        var info: String
        var imageUrl: String
        var address: String
        var coordinates: CLLocationCoordinate2D
        var site: String
    }

    class func fillDemoData() -> [data] {
        let slack = data(name: "Slack", info: "Slack is a cloud-based team collaboration tool co-founded by Stewart Butterfield, Eric Costello, Cal Henderson, and Serguei Mourachov. Slack began as an internal tool used by their company, Tiny Speck, in the development of Glitch, a now defunct online game. Slack is where work happens.", imageUrl: "https://blog.agilebits.com/wp-content/uploads/2014/09/Slack-icon.png", address: "155 5th St, San Francisco, CA 94103", coordinates: CLLocationCoordinate2DMake(37.7823802, -122.4052252), site: "https://slack.com")
        let dropbox = data(name: "Dropbox", info: "Dropbox's mission is to provide a home for everyone's most important information and bring it to life. We make it easy for hundreds of millions of people to access, share, and collaborate on their files so they can be more productive — at home and at work.", imageUrl: "https://cf.dropboxstatic.com/static/images/brand/glyph-vflK-Wlfk.png", address: "333 Brannan St, San Francisco, CA 94107", coordinates: CLLocationCoordinate2DMake(37.7807981, -122.3925007), site: "https://dropbox.com")
        let airbnb = data(name: "Airbnb", info: "Airbnb is a community marketplace for people to list, discover and book unique spaces around the world through mobile phones or the internet. Whether an apartment for a night, a castle for a week, or a villa for a month, Airbnb connects people to unique travel experiences at any price point, with over 500,000 listings in 33,000 cities and 192 countries.", imageUrl: "https://crunchbase-production-res.cloudinary.com/image/upload/c_pad,h_140,w_140/v1405534850/vubc5kxhmw6jalain0ot.jpg", address: "888 Brannan St, San Francisco, CA 94103", coordinates: CLLocationCoordinate2DMake(37.7721234, -122.4052934), site: "https://airbnb.com")
        let twitter = data(name: "Twitter", info: "Twitter is a global social networking platform that allows its users to send and read 140-character messages known as “tweets”. It enables registered users to read and post their tweets through the web, short message service (SMS), and mobile applications.", imageUrl: "https://g.twimg.com/Twitter_logo_blue.png", address: "1355 Market St #900, San Francisco, CA 94103", coordinates: CLLocationCoordinate2DMake(37.7767902, -122.4164055), site: "https://twitter.com")
        let doorDash = data(name: "Door Dash", info: "DoorDash enables delivery in areas where it was not previously available. The company's mission is to empower small business owners to offer delivery in an affordable and convenient way. We are achieving this mission first by enabling restaurant food delivery.", imageUrl: "https://doordash-static.s3.amazonaws.com/static/img/doordash-square-red.jpg", address: "116 New Montgomery St #400, San Francisco, CA 94105", coordinates: CLLocationCoordinate2DMake(37.7870722, -122.4004509), site: "https://doordash.com")
        let twitch = data(name: "Twitch", info: "Founded in June 2011, Twitch is social video for gamers. It is the world’s leading video platform and community for gamers where more than 100 million gather every month to broadcast, watch and talk about video games. Twitch’s video platform is the backbone of both live and on-demand distribution for the entire video game ecosystem. This includes game developers, publishers, media outlets, events, user generated content, and the entire esports scene. In February 2014, Wall Street Journal ranked Twitch as the 4th largest website in terms of peak internet traffic in the U.S. fortifying the brand as an entertainment industry leader and the epicenter of social video for gamers.", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/Twitch_logo.svg/2000px-Twitch_logo.svg.png", address: "225 Bush St Ste 900, San Francisco, CA 94104", coordinates: CLLocationCoordinate2DMake(37.790841, -122.4012801), site: "https://twitch.com")
        let pinterest = data(name: "Pinterest", info: "Pinterest is a visual discovery and planning tool. People (Pinners) use the site and apps to get ideas for their future, such as recipes, places to travel, and products to buy, and save the things they love to their own boards. Pinners also follow the boards of others who they find interesting.", imageUrl: "https://upload.wikimedia.org/wikipedia/commons/0/08/Pinterest-logo.png", address: "808 Brannan St San Francisco, California 94103", coordinates: CLLocationCoordinate2DMake(37.7730108, -122.4037708), site: "https://pinterest.com")
        
        return [slack, dropbox, airbnb, twitter, doorDash, twitch, pinterest]
    }
}