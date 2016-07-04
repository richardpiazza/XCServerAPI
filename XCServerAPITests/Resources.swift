//
//  Resources.swift
//  XCServerCoreData
//
//  Created by Richard Piazza on 6/10/16.
//  Copyright © 2016 Richard Piazza. All rights reserved.
//

import Foundation
@testable import XCServerAPI

class Resources {
    
    private static func bot(forPrefix prefix: String) -> BotJSON? {
        guard let path = NSBundle(forClass: Resources.self).pathForResource("\(prefix)_BotResponse", ofType: "txt") else {
            return nil
        }
        
        var json: String
        do {
            json = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        } catch {
            print(error)
            return nil
        }
        
        let bot = BotJSON(withJSON: json)
        guard bot._id != "" else {
            return nil
        }
        
        return bot
    }
    
    private static func integrations(forPrefix prefix: String) -> IntegrationsResponse? {
        guard let path = NSBundle(forClass: self).pathForResource("\(prefix)_IntegrationsResponse", ofType: "txt") else {
            return nil
        }
        
        var json: String
        do {
            json = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        } catch {
            print(error)
            return nil
        }
        
        let response = IntegrationsResponse(withJSON: json)
        guard response.count > 0 && response.results.count > 0 else {
            return nil
        }
        
        return response
    }
    
    private static func integration(forPrefix prefix: String) -> IntegrationJSON? {
        guard let path = NSBundle(forClass: self).pathForResource("\(prefix)_Integration", ofType: "txt") else {
            return nil
        }
        
        var json: String
        do {
            json = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        } catch {
            print(error)
            return nil
        }
        
        let response = IntegrationJSON(withJSON: json)
        
        return response
    }
    
    private static func stats(forPrefix prefix: String) -> StatsJSON? {
        guard let path = NSBundle(forClass: self).pathForResource("\(prefix)_Stats", ofType: "txt") else {
            return nil
        }
        
        var json: String
        do {
            json = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        } catch {
            print(error)
            return nil
        }
        
        let response = StatsJSON(withJSON: json)
        
        return response
    }
    
    private static func commits(forPrefix prefix: String) -> IntegrationCommitsResponse? {
        guard let path = NSBundle(forClass: self).pathForResource("\(prefix)_Commits", ofType: "txt") else {
            return nil
        }
        
        var json: String
        do {
            json = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        } catch {
            print(error)
            return nil
        }
        
        let response = IntegrationCommitsResponse(withJSON: json)
        
        return response
    }
    
    private static func issues(forPrefix prefix: String) -> IntegrationIssuesResponse? {
        guard let path = NSBundle(forClass: self).pathForResource("\(prefix)_Issues", ofType: "txt") else {
            return nil
        }
        
        var json: String
        do {
            json = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        } catch {
            print(error)
            return nil
        }
        
        let response = IntegrationIssuesResponse(withJSON: json)
        
        return response
    }
    
    struct Bakeshop {
        static let prefix: String = "bs"
        static let botIdentifier: String = "bba9b6ff6d6f0899a63d1e347e040bb4"
        static let integrationIdentifier: String = "bba9b6ff6d6f0899a63d1e347e4be8f0"
        static let repositoryIdentifier: String = "6139C8319FDE4527BFD4EA6334BA1CE5BC0DE9DF"
        static let Bot: BotJSON? = Resources.bot(forPrefix: prefix)
        static let Integrations: IntegrationsResponse? = Resources.integrations(forPrefix: prefix)
        static let Integration: IntegrationJSON? = Resources.integration(forPrefix: prefix)
        static let Stats: StatsJSON? = Resources.stats(forPrefix: prefix)
        static let Commits: IntegrationCommitsResponse? = Resources.commits(forPrefix: prefix)
        static let Issues: IntegrationIssuesResponse? = Resources.issues(forPrefix: prefix)
    }
    
    struct CodeQuickKit {
        static let prefix: String = "cqk"
        static let botIdentifier: String = "bba9b6ff6d6f0899a63d1e347e081b6a"
        static let integrationIdentifier: String = "d268530a92c37b78d5fe9634cd09d585"
        static let repositoryIdentifier: String = "3CBDEDAE95CE25E53B615AC684AAEE3F90A98DFE"
        static let Bot: BotJSON? = Resources.bot(forPrefix: prefix)
        static let Integrations: IntegrationsResponse? = Resources.integrations(forPrefix: prefix)
        static let Integration: IntegrationJSON? = Resources.integration(forPrefix: prefix)
        static let Stats: StatsJSON? = Resources.stats(forPrefix: prefix)
        static let Commits: IntegrationCommitsResponse? = Resources.commits(forPrefix: prefix)
        static let Issues: IntegrationIssuesResponse? = Resources.issues(forPrefix: prefix)
    }
    
    struct MiseEnPlace {
        static let prefix: String = "mep"
        static let botIdentifier: String = "bba9b6ff6d6f0899a63d1e347e100570"
        static let integrationIdentifier: String = "bba9b6ff6d6f0899a63d1e347e100e75"
        static let repositoryIdentifier: String = "E72555C40C59CF258F530ADBA0314A60534D9864"
        static let Bot: BotJSON? = Resources.bot(forPrefix: prefix)
        static let Integrations: IntegrationsResponse? = Resources.integrations(forPrefix: prefix)
        static let Integration: IntegrationJSON? = Resources.integration(forPrefix: prefix)
        static let Stats: StatsJSON? = Resources.stats(forPrefix: prefix)
        static let Commits: IntegrationCommitsResponse? = Resources.commits(forPrefix: prefix)
        static let Issues: IntegrationIssuesResponse? = Resources.issues(forPrefix: prefix)
    }
    
    struct PocketBot {
        static let prefix: String = "pb"
        static let botIdentifier: String = "bba9b6ff6d6f0899a63d1e347e00ff15"
        static let integrationIdentifier: String = "445abd7c9c9ac0ab2d3b474f6a1f12ad"
        static let repositoryIdentifier: String = "6D9FFC92170BF5EE19CA25700175BFFFBA40751A"
        static let Bot: BotJSON? = Resources.bot(forPrefix: prefix)
        static let Integrations: IntegrationsResponse? = Resources.integrations(forPrefix: prefix)
        static let Integration: IntegrationJSON? = Resources.integration(forPrefix: prefix)
        static let Stats: StatsJSON? = Resources.stats(forPrefix: prefix)
        static let Commits: IntegrationCommitsResponse? = Resources.commits(forPrefix: prefix)
        static let Issues: IntegrationIssuesResponse? = Resources.issues(forPrefix: prefix)
    }
    
    static var Bots: BotsResponse? {
        guard let path = NSBundle(forClass: Resources.self).pathForResource("BotsResponse", ofType: "txt") else {
            return nil
        }
        
        var json: String
        do {
            json = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding) as String
        } catch {
            print(error)
            return nil
        }
        
        let response = BotsResponse(withJSON: json)
        guard response.count > 0 && response.results.count > 0 else {
            return nil
        }
        
        return response
    }
}
