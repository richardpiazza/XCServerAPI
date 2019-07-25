let botsResponseJSON = """
{
    "count": 2,
    "results": [
                {
                "_id": "7b0bfdf8f209bf9b85b8aa0205102b39",
                "_rev": "5-935dc8a5892b549b159cb001ccc271e5",
                "group": {
                "name": "D4A38F79-6573-46B5-877C-B7A5E662DC9F"
                },
                "configuration": {
                "triggers": [],
                "hourOfIntegration": 0,
                "performsUpgradeIntegration": false,
                "disableAppThinning": false,
                "provisioningConfiguration": {
                "addMissingDevicesToTeams": false,
                "manageCertsAndProfiles": false
                },
                "periodicScheduleInterval": 0,
                "deviceSpecification": {
                "filters": [
                            {
                            "platform": {
                            "_id": "55c38846721f430c8fa94d67030020e0",
                            "displayName": "iOS",
                            "_rev": "15-7382c20978c7c104397747a672826a8b",
                            "simulatorIdentifier": "com.apple.platform.iphonesimulator",
                            "identifier": "com.apple.platform.iphoneos",
                            "buildNumber": "14E8301",
                            "version": "10.3.1"
                            },
                            "filterType": 0,
                            "architectureType": 0
                            }
                            ],
                "deviceIdentifiers": []
                },
                "buildEnvironmentVariables": {},
                "schemeName": "CrazyMonkeyTwinCitiesiOS",
                "additionalBuildArguments": [],
                "codeCoveragePreference": 2,
                "performsTestAction": true,
                "scheduleType": 3,
                "useParallelDeviceTesting": true,
                "performsArchiveAction": true,
                "builtFromClean": 3,
                "performsAnalyzeAction": true,
                "exportsProductFromArchive": true,
                "weeklyScheduleDay": 0,
                "runOnlyDisabledTests": false,
                "testingDestinationType": 0,
                "minutesAfterHourToIntegrate": 0,
                "testLocalizations": [],
                "sourceControlBlueprint": {
                "DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationStrategiesKey": {
                "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9": {
                "DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationTypeKey": "DVTSourceControlSSHKeysAuthenticationStrategy"
                }
                },
                "DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey": [
                                                                            {
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryEnforceTrustCertFingerprintKey": true,
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryURLKey": "bitbucket.org:richardpiazza/com.crazymonkeytwincities.ios.git",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryTrustedCertFingerprintKey": "978C1BF26F146B5C3BECAA4646747C40",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryIdentifierKey": "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositorySystemKey": "com.apple.dt.Xcode.sourcecontrol.Git"
                                                                            }
                                                                            ],
                "DVTSourceControlWorkspaceBlueprintLocationsKey": {
                "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9": {
                "DVTSourceControlBranchIdentifierKey": "master",
                "DVTSourceControlBranchOptionsKey": 4,
                "DVTSourceControlWorkspaceBlueprintLocationTypeKey": "DVTSourceControlBranch"
                }
                },
                "DVTSourceControlWorkspaceBlueprintWorkingCopyRepositoryLocationsKey": {},
                "DVTSourceControlWorkspaceBlueprintVersion": 205,
                "DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey": "Crazy Monkey Twin Cities.xcworkspace",
                "DVTSourceControlWorkspaceBlueprintIdentifierKey": "C83C0E6A-F936-4C52-B475-8147D9488784",
                "DVTSourceControlWorkspaceBlueprintAdditionalValidationRemoteRepositoriesKey": [],
                "DVTSourceControlWorkspaceBlueprintWorkingCopyStatesKey": {
                "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9": 0
                },
                "DVTSourceControlWorkspaceBlueprintNameKey": "Crazy Monkey Twin Cities",
                "DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey": {
                "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9": "CrazyMonkey/"
                },
                "DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey": "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9"
                }
                },
                "requiresUpgrade": false,
                "name": "CrazyMonkeyTwinCitiesiOS Bot",
                "type": 1,
                "sourceControlBlueprintIdentifier": "7559BA65-0DE8-44CE-8BAF-542529CDF63A",
                "integration_counter": 2,
                "doc_type": "bot",
                "tinyID": "BF9D28C",
                "lastRevisionBlueprint": {
                "DVTSourceControlWorkspaceBlueprintAdditionalValidationRemoteRepositoriesKey": [],
                "DVTSourceControlWorkspaceBlueprintLocationsKey": {
                "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9": {
                "DVTSourceControlBranchIdentifierKey": "master",
                "DVTSourceControlLocationRevisionKey": "cdfd4c217d5b85530c2b81849d327e400af84015",
                "DVTSourceControlBranchOptionsKey": 4,
                "DVTSourceControlBranchRemoteNameKey": "origin",
                "DVTSourceControlWorkspaceBlueprintLocationTypeKey": "DVTSourceControlBranch"
                }
                },
                "DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey": "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9",
                "DVTSourceControlWorkspaceBlueprintIdentifierKey": "8C2D69B0-B9A6-48BF-BB17-B7ABB0D34F2D",
                "DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey": {
                "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9": "CrazyMonkey/"
                },
                "DVTSourceControlWorkspaceBlueprintNameKey": "Crazy Monkey Twin Cities",
                "DVTSourceControlWorkspaceBlueprintVersion": 205,
                "DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey": "Crazy Monkey Twin Cities.xcworkspace",
                "DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey": [
                                                                            {
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryURLKey": "bitbucket.org:richardpiazza/com.crazymonkeytwincities.ios.git",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositorySystemKey": "com.apple.dt.Xcode.sourcecontrol.Git",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryIdentifierKey": "3B5CFDF38F1AD11BC1804F5A657156F5835DCED9"
                                                                            }
                                                                            ]
                }
                },
                {
                "_id": "a7341f3521c7245492693c0d780006f9",
                "_rev": "33-98a45812535fd887382ef2837c943f3d",
                "group": {
                "name": "5C5B2618-7DF5-41AF-A799-14AEA4A93EFC"
                },
                "configuration": {
                "triggers": [
                             {
                             "phase": 1,
                             "scriptBody": "#!/bin/sh\\n\\necho Pre-Integration Script Running\\n\\n",
                             "type": 1,
                             "name": "preintegration",
                             "conditions": {
                             "status": 2,
                             "onAllIssuesResolved": true,
                             "onWarnings": true,
                             "onBuildErrors": true,
                             "onAnalyzerWarnings": true,
                             "onFailingTests": true,
                             "onSuccess": true
                             }
                             },
                             {
                             "phase": 2,
                             "scriptBody": "#!/bin/sh\\n\\necho Post-Integration Script Running\\n\\n",
                             "type": 1,
                             "name": "postintegration",
                             "conditions": {
                             "status": 2,
                             "onAllIssuesResolved": true,
                             "onWarnings": true,
                             "onBuildErrors": true,
                             "onAnalyzerWarnings": true,
                             "onFailingTests": true,
                             "onSuccess": true
                             }
                             },
                             {
                             "phase": 2,
                             "scriptBody": "",
                             "emailConfiguration": {
                             "ccAddresses": [],
                             "allowedDomainNames": [],
                             "includeCommitMessages": true,
                             "includeLogs": true,
                             "replyToAddress": "",
                             "includeIssueDetails": true,
                             "includeBotConfiguration": true,
                             "additionalRecipients": [],
                             "scmOptions": {
                             "FBDCD372C080F115B518613EB0C4141F30E28CCE": 1
                             },
                             "emailCommitters": true,
                             "fromAddress": "",
                             "type": 3,
                             "includeResolvedIssues": true,
                             "weeklyScheduleDay": 7,
                             "minutesAfterHour": 0,
                             "hour": 12
                             },
                             "type": 2,
                             "name": "newissueemail",
                             "conditions": {
                             "status": 2,
                             "onAllIssuesResolved": true,
                             "onWarnings": true,
                             "onBuildErrors": true,
                             "onAnalyzerWarnings": true,
                             "onFailingTests": true,
                             "onSuccess": false
                             }
                             },
                             {
                             "phase": 2,
                             "scriptBody": "",
                             "emailConfiguration": {
                             "ccAddresses": [],
                             "allowedDomainNames": [],
                             "includeCommitMessages": true,
                             "includeLogs": true,
                             "replyToAddress": "",
                             "includeIssueDetails": true,
                             "includeBotConfiguration": true,
                             "additionalRecipients": [],
                             "scmOptions": {
                             "FBDCD372C080F115B518613EB0C4141F30E28CCE": 1
                             },
                             "emailCommitters": true,
                             "fromAddress": "",
                             "type": 0,
                             "includeResolvedIssues": true,
                             "weeklyScheduleDay": 7,
                             "minutesAfterHour": 0,
                             "hour": 12
                             },
                             "type": 2,
                             "name": "Periodic Email Report",
                             "conditions": {
                             "status": 2,
                             "onAllIssuesResolved": true,
                             "onWarnings": true,
                             "onBuildErrors": true,
                             "onAnalyzerWarnings": true,
                             "onFailingTests": true,
                             "onSuccess": true
                             }
                             }
                             ],
                "testingDestinationType": 0,
                "performsUpgradeIntegration": false,
                "disableAppThinning": false,
                "provisioningConfiguration": {
                "addMissingDevicesToTeams": false,
                "manageCertsAndProfiles": false
                },
                "periodicScheduleInterval": 0,
                "deviceSpecification": {
                "filters": [
                            {
                            "platform": {
                            "_id": "81a37f1603cadd6069d5b856520035c8",
                            "displayName": "iOS",
                            "_rev": "231-60161daf2b8792858b98069f2df05adb",
                            "simulatorIdentifier": "com.apple.platform.iphonesimulator",
                            "identifier": "com.apple.platform.iphoneos",
                            "buildNumber": "15A5304f",
                            "version": "11.0"
                            },
                            "filterType": 2,
                            "architectureType": 0
                            }
                            ],
                "deviceIdentifiers": []
                },
                "buildEnvironmentVariables": {
                "BOT_ENV_TEST": "Hello World"
                },
                "schemeName": "XCServerAPI",
                "additionalBuildArguments": [],
                "codeCoveragePreference": 2,
                "performsTestAction": true,
                "scheduleType": 2,
                "useParallelDeviceTesting": false,
                "performsArchiveAction": false,
                "builtFromClean": 0,
                "performsAnalyzeAction": true,
                "sourceControlBlueprint": {
                "DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationStrategiesKey": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": {
                "DVTSourceControlWorkspaceBlueprintRemoteRepositoryAuthenticationTypeKey": "DVTSourceControlAuthenticationStrategy"
                }
                },
                "DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey": [
                                                                            {
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositorySystemKey": "com.apple.dt.Xcode.sourcecontrol.Git",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryURLKey": "https://github.com/richardpiazza/XCServerAPI",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryTrustedCertFingerprintKey": "1627ACA576282D36631B564DEBDFA648",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryIdentifierKey": "FBDCD372C080F115B518613EB0C4141F30E28CCE",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryTrustSelfSignedCertKey": true
                                                                            }
                                                                            ],
                "DVTSourceControlWorkspaceBlueprintLocationsKey": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": {
                "DVTSourceControlBranchIdentifierKey": "master",
                "DVTSourceControlBranchOptionsKey": 4,
                "DVTSourceControlWorkspaceBlueprintLocationTypeKey": "DVTSourceControlBranch"
                }
                },
                "DVTSourceControlWorkspaceBlueprintWorkingCopyRepositoryLocationsKey": {},
                "DVTSourceControlWorkspaceBlueprintVersion": 205,
                "DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey": "XCServerAPI.xcworkspace",
                "DVTSourceControlWorkspaceBlueprintIdentifierKey": "D33CB06B-8AA0-427A-B7DC-46F4735D8169",
                "DVTSourceControlWorkspaceBlueprintAdditionalValidationRemoteRepositoriesKey": [],
                "DVTSourceControlWorkspaceBlueprintWorkingCopyStatesKey": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": 0
                },
                "DVTSourceControlWorkspaceBlueprintNameKey": "XCServerAPI",
                "DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": "XCServerAPI/"
                },
                "DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey": "FBDCD372C080F115B518613EB0C4141F30E28CCE"
                },
                "exportsProductFromArchive": true,
                "weeklyScheduleDay": 0,
                "runOnlyDisabledTests": false,
                "minutesAfterHourToIntegrate": 0,
                "testLocalizations": [],
                "hourOfIntegration": 0
                },
                "requiresUpgrade": false,
                "name": "XCServerAPI Bot",
                "type": 1,
                "sourceControlBlueprintIdentifier": "B3AEE2A8-E68F-477D-A2C7-1806DE6CC350",
                "integration_counter": 15,
                "doc_type": "bot",
                "tinyID": "7803918",
                "lastRevisionBlueprint": {
                "DVTSourceControlWorkspaceBlueprintRemoteRepositoriesKey": [
                                                                            {
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositorySystemKey": "com.apple.dt.Xcode.sourcecontrol.Git",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryURLKey": "https://github.com/richardpiazza/XCServerAPI",
                                                                            "DVTSourceControlWorkspaceBlueprintRemoteRepositoryIdentifierKey": "FBDCD372C080F115B518613EB0C4141F30E28CCE"
                                                                            }
                                                                            ],
                "DVTSourceControlWorkspaceBlueprintLocationsKey": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": {
                "DVTSourceControlBranchIdentifierKey": "master",
                "DVTSourceControlLocationRevisionKey": "2bde8ec3aaef0742ec7e028c26c7548ccd5aba78",
                "DVTSourceControlBranchOptionsKey": 4,
                "DVTSourceControlBranchRemoteNameKey": "origin",
                "DVTSourceControlWorkspaceBlueprintLocationTypeKey": "DVTSourceControlBranch"
                }
                },
                "DVTSourceControlWorkspaceBlueprintPrimaryRemoteRepositoryKey": "FBDCD372C080F115B518613EB0C4141F30E28CCE",
                "DVTSourceControlWorkspaceBlueprintIdentifierKey": "91E481D6-958E-48CB-99DB-79BF7456C5B4",
                "DVTSourceControlWorkspaceBlueprintWorkingCopyPathsKey": {
                "FBDCD372C080F115B518613EB0C4141F30E28CCE": "XCServerAPI/"
                },
                "DVTSourceControlWorkspaceBlueprintNameKey": "XCServerAPI",
                "DVTSourceControlWorkspaceBlueprintVersion": 205,
                "DVTSourceControlWorkspaceBlueprintRelativePathToProjectKey": "XCServerAPI.xcworkspace",
                "DVTSourceControlWorkspaceBlueprintAdditionalValidationRemoteRepositoriesKey": []
                }
                }
                ]
}
"""
