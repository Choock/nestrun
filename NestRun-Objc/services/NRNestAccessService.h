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

@end

typedef void (^AccessReceived)(BOOL);

@interface NRNestAccessService : NSObject

    @property(readonly) NestAccessToken* accessToken;
    @property(readonly) BOOL             accessGranted;

    + (instancetype) shared;
    - (void) loginIn:(UIWebView*)view callback:(AccessReceived) block;

@end
