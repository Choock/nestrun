//
//  NRNestAccessService.h
//  NestRun-Objc
//
//  Created by Dima Choock on 06/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

@import UIKit;

@interface NestAccessToken : NSObject

    @property(readonly) NSString* string;
    @property(readonly) NSString* bearer;
    @property(readonly) NSDate*   expiresOn;

@end

typedef void (^AccessReceived)(BOOL);

@interface NRNestAccessService : NSObject

    @property(readonly) BOOL             accessGranted;
    @property(readonly) NestAccessToken* accessToken;
    @property(readonly) NSString*        apiPath;

    @property(readonly) NSURL* camerasURL;
    @property(readonly) NSURL* devicesURL;

    @property(readonly) NSURLRequest* camerasPollRequest;
    @property(readonly) NSURLRequest* devicesPollRequest;

    + (instancetype) shared;
    - (void) loginIn:(UIWebView*)view callback:(AccessReceived) block;

@end
