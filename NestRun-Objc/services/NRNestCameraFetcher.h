//
//  NRNestCameraFetcher.h
//  NestRun-Objc
//
//  Created by Dima Choock on 06/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetcherCompletionHandler)(BOOL);

@interface NRNestCameraFetcher : NSObject

    @property(readonly) NSDictionary* cameraIDs;
    @property(readonly) NSArray*      cameraNames;
    @property(readonly) NSDictionary* cameraLatEvents;

    + (instancetype) shared;   

    - (void) fetchCameras:(FetcherCompletionHandler)handler;

    - (void) listenCameras;

@end
