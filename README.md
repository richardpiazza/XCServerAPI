# XCServerAPI
[![Version](https://img.shields.io/cocoapods/v/XCServerAPI.svg?style=flat)](http://cocoadocs.org/docsets/XCServerAPI)
[![Platform](https://img.shields.io/cocoapods/p/XCServerAPI.svg?style=flat)](http://cocoadocs.org/docsets/XCServerAPI)

An API and model framework for working with Xcode Server.

#### XCServerWebAPI.swift

Wraps an `NSURLSession` for each `XcodeServer` entity.
Two static delegates are available for handling SSL and HTTP Authentication for your server:

    XCServerWebAPI.sessionDelegate: NSURLSessionDelegate
    XCServerWebAPI.credentialDelegate: XCServerWebAPICredentialDelegate

There are default objects assigned to these properties.
The default `sessionDelegate` will accept and trust SSL certificates even if self-signed.
The default `credentialDelegate` will provide no credentials.

The `XCServerWebAPICredentialDelegate` has a default implementation for the method:

    credentialsHeader(forAPI:) -> XCServerWebAPICredentialsHeader

that will return a base 64 encoded username password pair for the HTTP Authorization header.
