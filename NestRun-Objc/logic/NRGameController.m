//
//  NRGameController.m
//  NestRun-Objc
//
//  Created by Dima Choock on 11/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "NRGameController.h"
#import "NRRunController.h"
#import "NRNestCameraFetcher.h"
#import "NRModelNames.h"

@implementation NRGameController
{
    NSDictionary<NSString*, NSString*>* _cameraIDs;
    NSString* _lastRunTarget;
    
    NRRunController* _currentRun;
}

#pragma mark - CONTROL INTERFACE

- (void) startGame
{
    [[NRNestCameraFetcher shared] fetchCameras:^(BOOL success) 
    {
        if(success) _cameraIDs = [NRNestCameraFetcher shared].cameraIDs;
        dispatch_async(dispatch_get_main_queue(), 
        ^{
            [self.display attachCameras:_cameraIDs];
            [self.display gameStarted];
            [[NRNestCameraFetcher shared] startCamerasObserving];
            [self runLoop];
        });
    }];
    
}

/// Main loop: create and start run - wait for run finish - check gameover conditions - handle gameover or go to loop begin
- (void) runLoop
{
    // Target and red zones:
    NSString*         target_id = [self selectRunTarget];
    NSSet<NSString*>* red_ids   = [self selectRunRedZonesAvoiding:target_id];
    
    // New run:
    _currentRun = [NRRunController makeRunToTarget:target_id avoiding:red_ids];
    
    // Update display - show new run target and zones to avoid:
    [self.display setRunTarget:target_id  runTime:10 waitTime:5 score:50];
    [self.display setRedZones:red_ids score:-10];
    
    // Start run:
    [_currentRun start:
     ^(BOOL inTarget, BOOL inRed, NSString* redID) 
    {
        if(inTarget) [self handleTargetRiched];
        if(inRed)    [self handleRedZoneTouched:redID];
        [self controlRunConditions];
        [self controlGameConditions];
    }];
}

#pragma mark - GAME ROUTINES

- (void) handleTargetRiched
{
    NSLog(@"RUN TARGET REACHED");
}

- (void) handleRedZoneTouched:(NSString*)redID
{
    NSLog(@"RUN RED ZONR TOUCHED %@",redID);
}
- (void) controlRunConditions
{
    
}
- (void) controlGameConditions
{
    
}


/// Test random selectors for a terget and red zones. Real game will require much more sophisticated approach
- (NSString*) selectRunTarget
{
    NSString* new_run_target;
    NSString* target_cam_name;
    do
    {
        int index = (int)arc4random_uniform((uint32_t)_cameraIDs.count);
        target_cam_name = _cameraIDs.allKeys[index];
        new_run_target  = _cameraIDs[target_cam_name];
    }
    while(EQS(_lastRunTarget,new_run_target));
    _lastRunTarget = new_run_target;
    
    NSLog(@"NEW RUN: TARGET: %@", target_cam_name);
    return _lastRunTarget;
}
- (NSSet<NSString*>*) selectRunRedZonesAvoiding:(NSString*)target
{
    // Up to 3 red zones can be selected
    NSMutableSet* red_zones = [[NSMutableSet alloc] init];
    NSMutableArray* non_targets = _cameraIDs.allValues.mutableCopy;
    [non_targets removeObject:target];
    NSString* red_zone;
    for(int i=0; i<3; i++)
    {
        int index = (int)arc4random_uniform((uint32_t)non_targets.count);
        red_zone = non_targets[index];
        [red_zones addObject:red_zone];
    }
    return red_zones;
}

@end
