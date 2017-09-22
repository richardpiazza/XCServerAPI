//
//  CodeCoverageTests.swift
//  XCServerAPITests
//
//  Created by Richard Piazza on 7/28/17.
//  Copyright © 2017 Richard Piazza. All rights reserved.
//

import XCTest
@testable import XCServerAPI

class CodeCoverageTests: XCTestCase {
    
    let json = """
    {
      "trg":{
    "XCServerAPITests.xctest":{
      "lnpd":0,
      "dvcs":[
        {
          "dvc":"B0B6593",
          "lnp":78.50287907869482,
          "lnpd":0
        }
      ],
      "fls":{
        "BotTests.swift":{
          "lnpd":0,
          "cnt":3,
          "tte":"BotTests.swift",
          "lnp":80.55555820465088,
          "dvcs":[
            {
              "dvc":"B0B6593",
              "lnp":80.55555555555556,
              "lnpd":0
            }
          ],
          "mth":[
            {
              "tte":"XCServerAPITests.BotTests.setUp() -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":100,
                  "lnpd":0
                }
              ],
              "lnp":100,
              "lnpd":0
            },
            {
              "tte":"XCServerAPITests.BotTests.tearDown() -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":100,
                  "lnpd":0
                }
              ],
              "lnp":100,
              "lnpd":0
            },
            {
              "tte":"XCServerAPITests.BotTests.testBot() -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":75,
                  "lnpd":0
                }
              ],
              "lnp":75,
              "lnpd":0
            }
          ]
        },
        "ConfigurationTests.swift":{
          "lnpd":0,
          "cnt":3,
          "tte":"ConfigurationTests.swift",
          "lnp":85.71428656578064,
          "dvcs":[
            {
              "dvc":"B0B6593",
              "lnp":85.71428571428571,
              "lnpd":0
            }
          ],
          "mth":[
            {
              "tte":"XCServerAPITests.ConfigurationTests.setUp() -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":100,
                  "lnpd":0
                }
              ],
              "lnp":100,
              "lnpd":0
            },
            {
              "tte":"XCServerAPITests.ConfigurationTests.tearDown() -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":100,
                  "lnpd":0
                }
              ],
              "lnp":100,
              "lnpd":0
            },
            {
              "tte":"XCServerAPITests.ConfigurationTests.testConfiguration() -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":82.92682926829268,
                  "lnpd":0
                }
              ],
              "lnp":82.92682766914368,
              "lnpd":0
            }
          ]
        }
      },
      "cnt":17,
      "lnp":78.50287907869482
    },
    "XCServerAPI.framework":{
      "lnpd":0,
      "dvcs":[
        {
          "dvc":"B0B6593",
          "lnp":55.09803921568628,
          "lnpd":0
        }
      ],
      "fls":{
        "XCServerWebAPI.swift":{
          "lnpd":0,
          "cnt":15,
          "tte":"XCServerWebAPI.swift",
          "lnp":45.945945382118225,
          "dvcs":[
            {
              "dvc":"B0B6593",
              "lnp":45.94594594594595,
              "lnpd":0
            }
          ],
          "mth":[
            {
              "tte":"(extension in XCServerAPI):XCServerAPI.XCServerWebAPICredentialDelegate.credentialsHeader(forAPI: XCServerAPI.XCServerWebAPI) -> Swift.Optional<(value: Swift.String, key: Swift.String)>",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":15.789473684210526,
                  "lnpd":0
                }
              ],
              "lnp":15.789473056793213,
              "lnpd":0
            },
            {
              "tte":"(extension in XCServerAPI):XCServerAPI.XCServerWebAPICredentialDelegate.clearCredentials(forAPI: XCServerAPI.XCServerWebAPI) -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":0,
                  "lnpd":0
                }
              ],
              "lnp":0,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.Errors.code.getter : Swift.Int",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":100,
                  "lnpd":0
                }
              ],
              "lnp":100,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.Errors.localizedDescription.getter : Swift.String",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":100,
                  "lnpd":0
                }
              ],
              "lnp":100,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.Errors.localizedFailureReason.getter : Swift.String",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":100,
                  "lnpd":0
                }
              ],
              "lnp":100,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.Errors.localizedRecoverySuggestion.getter : Swift.String",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":100,
                  "lnpd":0
                }
              ],
              "lnp":100,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.Errors.nsError.getter : __ObjC.NSError",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":0,
                  "lnpd":0
                }
              ],
              "lnp":0,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.XCServerDefaultSessionDelegate.urlSession(__ObjC.URLSession, didReceive: __ObjC.URLAuthenticationChallenge, completionHandler: (__ObjC.URLSession.AuthChallengeDisposition, Swift.Optional<__ObjC.URLCredential>) -> ()) -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":0,
                  "lnpd":0
                }
              ],
              "lnp":0,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.XCServerDefaultCredentialDelegate.credentials(forAPI: XCServerAPI.XCServerWebAPI) -> Swift.Optional<(username: Swift.String, password: Swift.Optional<Swift.String>)>",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":100,
                  "lnpd":0
                }
              ],
              "lnp":100,
              "lnpd":0
            },
            {
              "tte":"static XCServerAPI.XCServerWebAPI.api(forFQDN: Swift.String) -> XCServerAPI.XCServerWebAPI",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":0,
                  "lnpd":0
                }
              ],
              "lnp":0,
              "lnpd":0
            },
            {
              "tte":"static XCServerAPI.XCServerWebAPI.resetAPI(forFQDN: Swift.String) -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":0,
                  "lnpd":0
                }
              ],
              "lnp":0,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.__allocating_init(fqdn: Swift.String) -> XCServerAPI.XCServerWebAPI",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":0,
                  "lnpd":0
                }
              ],
              "lnp":0,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.request(method: CodeQuickKit.WebAPI.HTTPRequestMethod, path: Swift.String, queryItems: Swift.Optional<Swift.Array<Foundation.URLQueryItem>>, data: Swift.Optional<Foundation.Data>) throws -> __ObjC.NSMutableURLRequest",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":77.77777777777779,
                  "lnpd":0
                }
              ],
              "lnp":77.77777910232544,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.ping((Swift.Int, Swift.Optional<Swift.Dictionary<Swift.AnyHashable, Any>>, Swift.Optional<Foundation.Data>, Swift.Optional<Swift.Error>) -> ()) -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":100,
                  "lnpd":0
                }
              ],
              "lnp":100,
              "lnpd":0
            },
            {
              "tte":"XCServerAPI.XCServerWebAPI.versions((Swift.Optional<XCServerAPI.VersionDocument>, Swift.Optional<Swift.Int>, Swift.Optional<Swift.Error>) -> ()) -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":72.72727272727273,
                  "lnpd":0
                }
              ],
              "lnp":72.72727489471436,
              "lnpd":0
            }
          ]
        },
        "XCServerWebAPI+Issues.swift":{
          "lnpd":0,
          "cnt":1,
          "tte":"XCServerWebAPI+Issues.swift",
          "lnp":51.99999809265137,
          "dvcs":[
            {
              "dvc":"B0B6593",
              "lnp":52,
              "lnpd":0
            }
          ],
          "mth":[
            {
              "tte":"XCServerAPI.XCServerWebAPI.issues(forIntegrationWithIdentifier: Swift.String, completion: (Swift.Optional<XCServerAPI.XCServerWebAPI.Issues>, Swift.Optional<Swift.Error>) -> ()) -> ()",
              "dvcs":[
                {
                  "dvc":"B0B6593",
                  "lnp":52,
                  "lnpd":0
                }
              ],
              "lnp":51.99999809265137,
              "lnpd":0
            }
          ]
        }
      },
      "cnt":8,
      "lnp":55.09803921568628
    }
      },
        "dvcs":[
    {
      "osVersion":"11.0",
      "connected":true,
      "simulator":true,
      "modelCode":"iPhone7,2",
      "deviceType":"com.apple.iphone-simulator",
      "modelName":"iPhone 6",
      "revision":"3-15ee58e0fc1354ea841ce6f96ccdb4d1",
      "modelUTI":"com.apple.iphone-6-b4b5b9",
      "doc_type":"device",
      "trusted":true,
      "name":"iPhone 6",
      "supported":true,
      "identifier":"3BC0F91B-1840-429F-B778-AFECB76E41A7",
      "enabledForDevelopment":true,
      "platformIdentifier":"com.apple.platform.iphonesimulator",
      "ID":"7b0bfdf8f209bf9b85b8aa0205007db9",
                "architecture":"x86_64",
                "retina":false,
                "isServer":false,
                "tinyID":"B0B6593"
            }
        ],
        "integrationID":"32fac4f96c4c026c27d9ab9f562e1cd1",
        "integrationNumber":23,
        "lnp":38.211569486056696,
        "lnpd":0
    }
    """
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCoverage() {
        guard let coverage = CoverageHierarchy.decode(json: json) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(coverage.integrationID, "32fac4f96c4c026c27d9ab9f562e1cd1")
        XCTAssertEqual(coverage.integrationNumber, 23)
        XCTAssertEqual(coverage.percent, 38.211569486056696)
        XCTAssertEqual(coverage.delta, 0)
        
        guard let device = coverage.devices!.first(where: { (dd) -> Bool in
            return dd.identifier == "3BC0F91B-1840-429F-B778-AFECB76E41A7"
        }) else {
            XCTFail()
            return
        }
        
        guard let coverageTargets = coverage.targets else {
            XCTFail()
            return
        }
        
        guard let xcserverapi = coverageTargets["XCServerAPI.framework"] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(xcserverapi.percent, 55.098039215686278)
        XCTAssertEqual(xcserverapi.delta, 0)
        
        guard let xcserverapiResults = xcserverapi.results else {
            XCTFail()
            return
        }
        
        let deviceResultA = xcserverapiResults.first { (cr) -> Bool in
            return cr.tinyID == "B0B6593"
        }
        
        XCTAssertNotNil(deviceResultA)
        XCTAssertEqual(device.tinyID, deviceResultA?.tinyID)
        
        guard let files = xcserverapi.files else {
            XCTFail()
            return
        }
        
        guard let webAPI = files["XCServerWebAPI.swift"] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(webAPI.name, "XCServerWebAPI.swift")
        
        guard let methods = webAPI.methods else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(webAPI.count, methods.count)
        
        let ping = methods[13]
        
        XCTAssertEqual(ping.percent, 100)
    }
}
