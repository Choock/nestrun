//
//  NRRunController.m
//  NestRun-Objc
//
//  Created by Dima Choock on 11/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "NRRunController.h"
#import "NRNestCameraFetcher.h"

@implementation NRRunController
{
    NSString*         _targetID;
    NSSet<NSString*>* _redIDs;
    RunEventsHandler  _runHandler;
}

+ (instancetype) makeRunToTarget:(NSString*)targetID avoiding:(NSSet<NSString*>*)redIDs
{
    NRRunController* run = [[NRRunController alloc] init];
    run->_targetID = targetID;
    run->_redIDs   = redIDs;
    return run;
}

#pragma mark - CONTROL INTERFACE

- (void) start:(RunEventsHandler)handler
{
    _runHandler = handler;
    // Observe target
    NRRunController* __weak wself = self;
    [[NRNestCameraFetcher shared] switchOnListenerForCameraID:_targetID 
    handler:
    ^(CameraEvent* event) 
    {
        [wself handleTargetCameraEvent:event];
    }];
    
    // Observe red zones
    for(NSString* red_id in _redIDs)
    {
        CameraEventHandler red_handler = ^void(CameraEvent* event) 
        {
            [wself handleRedZoneCameraEvent:event cameraID:red_id];
        };
        [[NRNestCameraFetcher shared] switchOnListenerForCameraID:_targetID handler:red_handler];
    }
}
- (void) cancel
{
    [self invalidateRun];
}

#pragma mark - PRIMARY CAM EVENTS HANDLING

- (void) handleTargetCameraEvent:(CameraEvent*) event
{
    // TODO: analyze events
    _runHandler(YES,NO,nil);
}

- (void) handleRedZoneCameraEvent:(CameraEvent*) event cameraID:(NSString*)cid
{
    // TODO: analyze events
    _runHandler(NO,YES,cid);
}

- (void) invalidateRun
{
    [[NRNestCameraFetcher shared] switchOffListenerForCameraID:_targetID];
    for(NSString* red_id in _redIDs)
    {
        [[NRNestCameraFetcher shared] switchOffListenerForCameraID:red_id];
    }
}


@end
