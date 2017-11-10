//
//  NRNestCameraFetcher.h
//  NestRun-Objc
//
//  Created by Dima Choock on 06/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    cet_nothing = 0,
    cet_motion  = 1 << 0,
    cet_sound   = 1 << 1,
    cet_person  = 1 << 2
} CameraEventType;

@interface CameraEvent : NSObject

    @property(nonatomic,readonly) NSDate* eventStart;
    @property(nonatomic,readonly) NSDate* eventStop;
    @property(nonatomic,assign)   CameraEventType type;

@end

typedef void (^FetcherCompletionHandler)(BOOL);
typedef void (^CameraEventHandler)(CameraEvent*);

@interface NRNestCameraFetcher : NSObject

    @property(readonly) NSDictionary* cameraIDs;
    @property(readonly) NSArray*      cameraNames;

    + (instancetype) shared;   

    - (void) fetchCameras:(FetcherCompletionHandler)handler;

    - (void) listenCameras;
    - (void) switchOnListenerForCameraID:(NSString*)cid handler:(CameraEventHandler)event;
    - (void) switchOffListenerForCameraID:(NSString*)cid;

@end
