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

@interface NRGameController()

    @property(nonatomic) int gameScore;
    @property(nonatomic) int gameLives;
    @property(nonatomic) int runScore;
    @property(nonatomic) int secondsToRun;
    @property(nonatomic) int secondsToWait;

@end

@implementation NRGameController
{
    NSMutableDictionary<NSString*, NSString*>* _cameraIDs;
    NSString* _lastRunTarget;
    NRRunController* _currentRun;
    
    NSDate*  _gameStartDate;
    NSDate*  _runStartDate;
    NSTimer* _runTimer;
}

#pragma mark - CONTROL INTERFACE

- (void) startGame
{
    [[NRNestCameraFetcher shared] fetchCameras:^(BOOL success) 
    {
        if(success)
        {
            _cameraIDs = [[NRNestCameraFetcher shared].cameraIDs mutableCopy];
            [_cameraIDs  setObject:@"initial-cam-id" forKey:Initial_cam];
            dispatch_async(dispatch_get_main_queue(), 
            ^{
                [self.display attachCameras:_cameraIDs];
                [self initGame];
                [[NRNestCameraFetcher shared] startCamerasObserving];
                [self nextRunLoop];
            });
        }
    }];
}

- (void) stopGame
{
    [self gameOver];
}

- (void) startSimGame:(NSString*)ename
{
    [[NRNestCameraFetcher shared] fetchCameras:^(BOOL success) 
    {
         if(success)
         {
            // NOTE: for sim only to put all game starts in
            _cameraIDs = [[NRNestCameraFetcher shared].cameraIDs mutableCopy];
            [_cameraIDs  setObject:@"initial-cam-id" forKey:Initial_cam];
            dispatch_async(dispatch_get_main_queue(), 
            ^{
                [self.display attachCameras:_cameraIDs];
                [self initGame];
                [[NRNestCameraFetcher shared] startSimulatedCamerasObserving:ename];
                [self nextRunLoop];
            });
         }
    }];
}

#pragma mark - RUN LOOP and EVENTS

/// Main loop: create and start run - wait for run finish - check gameover conditions - handle gameover or go to loop begin
- (void) nextRunLoop
{
    // Target and red zones:
    NSString*         target_id = [self selectRunTarget];
    NSSet<NSString*>* red_ids   = [self selectRunRedZonesAvoiding:target_id and:_lastRunTarget];
    _lastRunTarget = target_id;
    
    // New run:
    _currentRun = [NRRunController makeRunToTarget:target_id avoiding:red_ids];
    self.runScore = 50;
    
    // Update display - show new run target and zones to avoid:
    [self.display setRunTarget:target_id  runTime:10 waitTime:5 score:self.runScore];
    [self.display setRedZones:red_ids score:-10];
    
    // Start run:
    [self startRunTimer];
    [_currentRun start:
    ^(BOOL inTarget, BOOL inRed, NSString* redID) 
    {
        if(inTarget) 
        {
            NSLog(@"TARGET REACHED");
            [_display targetReached];
            [self runOver];
        }
        if(inRed)  
        {
            NSLog(@"REDZONR TOUCHED");
            [_display redZoneTouched:redID];
            [self decrementRunScore:10];
        }
    }];
}

- (void) startRunTimer
{
    self.secondsToRun = 10;
    [_display secondsToRun:self.secondsToRun];
    _runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimeTick) userInfo:nil repeats:YES];
}
- (void) startTargetWaitTimer
{
    self.secondsToWait = 5;
    _runTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitTimeTick) userInfo:nil repeats:YES];
}

#pragma mark - GAME STATE HANDLERS

- (void) runTimeTick
{
    self.secondsToRun -= 1;
    if(self.secondsToRun>0) return;
    [_runTimer invalidate];
    [self startTargetWaitTimer];
}
- (void) waitTimeTick
{
    self.secondsToWait -= 1;
    [self decrementRunScore:10];
    if(_secondsToWait>=0) return;
    [_runTimer invalidate];
    [self runOver];
}

- (void) decrementRunScore:(int)dec
{
    self.runScore -= dec;
}
- (void) runOver
{
    [_runTimer invalidate];
    [_display runOver];
    self.gameScore += self.runScore;
    [self controlGameState];
}
- (void) controlGameState
{
    if(self.runScore <= 0)
    {
        self.gameLives -= 1;
        if(self.gameLives == 0)
        {
            [self gameOver];
            return;
        }
        else
        {
            self.runScore = 0;
        }
    }
    // New run
    // TODO: start timer and send indication to display
    dispatch_time_t start_time = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
    dispatch_after(start_time, dispatch_get_main_queue(), 
    ^{
        [self nextRunLoop];
    });
}
- (void) gameOver
{
    [_runTimer invalidate];
    [_currentRun cancel];
    [_display gameOver];
}

#pragma mark - SCORE and TIME setters

- (void) setGameScore:(int)score
{
    if(_gameScore == score) return;
    _gameScore = score;
    [_display runScore:self.runScore gameScore:_gameScore livesLeft:self.gameLives];
}
- (void) setGameLives:(int)lives
{
    if(_gameLives == lives) return;
    _gameLives = lives;
    [_display runScore:self.runScore gameScore:self.gameScore livesLeft:_gameLives];
}
- (void) setRunScore:(int)score
{
    if(_runScore == score) return;
    _runScore = (score>0) ? score : 0;
    [_display runScore:_runScore gameScore:self.gameScore livesLeft:self.gameLives];
}
- (void) setSecondsToRun:(int)seconds
{
    if(_secondsToRun == seconds) return;
    _secondsToRun = seconds;
    [_display secondsToRun:_secondsToRun];
}
- (void) setSecondsToWait:(int)seconds
{
    if(_secondsToWait == seconds) return;
    _secondsToWait = seconds;
    [_display secondsToWait:_secondsToWait];
}


#pragma mark - GAME PREPARE

- (void) initGame
{
    self.gameScore = 50;
    self.gameLives = 3;
    [self.display gameStartedWithInitialScore:_gameScore lives:_gameLives];
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
    while(EQS(_lastRunTarget,new_run_target) || EQS(Initial_cam, target_cam_name));
    
    NSLog(@"NEW RUN: TARGET: %@", target_cam_name);
    return new_run_target;
}
- (NSSet<NSString*>*) selectRunRedZonesAvoiding:(NSString*)target and:(NSString*)origin
{
    // Up to 3 red zones can be selected
    NSMutableSet* red_zones = [[NSMutableSet alloc] init];
    NSMutableArray* non_targets = _cameraIDs.allValues.mutableCopy;
    [non_targets removeObject:target];
    [non_targets removeObject:origin];
    [non_targets removeObject:_cameraIDs[Initial_cam]];
    NSString* red_zone;
    for(int i=0; i<4; i++)
    {
        int index = (int)arc4random_uniform((uint32_t)non_targets.count);
        red_zone = non_targets[index];
        [red_zones addObject:red_zone];
    }
    return red_zones;
}

@end
