//
//  NRGameVC.m
//  NestRun-Objc
//
//  Created by Dima Choock on 11/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "appmacros.h"
#import "NRModelNames.h"
#import "NRGameVC.h"
#import "NRGameController.h"

@interface NRGameVC () <NRGameDisplay>

    @property (weak, nonatomic) IBOutlet UIView *redZoneContainer;
    @property (weak, nonatomic) IBOutlet UIView *targetSpotContainer;

@end

@implementation NRGameVC
{
    NRGameController* _gameController;
    
    NSMutableDictionary<NSString*,UIView*>* _cameraSpotView;
    NSMutableDictionary<NSString*,UIView*>* _cameraRedZoneView;
    
    NSSet<NSString*>* _currentReds;
    NSString* _currentTarget;
}

#pragma mark - NRGameDisplay IMPLEMENTATION

- (void) setRunTarget:(NSString*)cameraID runTime:(int)rsec waitTime:(int)wsec score:(int)score
{
    _cameraSpotView[_currentTarget].hidden = YES;
    _currentTarget = cameraID;
    _cameraSpotView[_currentTarget].hidden = NO;
}
- (void) setRedZones:(NSSet<NSString*>*)cameraIDs score:(int)score
{
    for (NSString* red in _currentReds) {_cameraRedZoneView[red].hidden = YES;}
    _currentReds = cameraIDs;
    for (NSString* red in _currentReds) {_cameraRedZoneView[red].hidden = NO;}
}

- (void) gameStarted
{
    
}

- (void) secondsToStart:(int)seconds
{
    
}
- (void) secondsToRun:(int)seconds
{
    
}
- (void) secondsToWait:(int)seconds
{
    
}

- (void) targetReached
{
    
}
- (void) redZoneTouched:(NSString*)cameraID
{
    
}

- (void) runScore:(int)runScore gameScore:(int)gameScore livesLeft:(int)lives
{
    
}

- (void) gameOver
{
    
}

/// Temp test implementation: manual attaching cameras to spots
- (void) attachCameras:(NSDictionary*)cameraNames
{
    _cameraSpotView = [[NSMutableDictionary alloc] init];
    _cameraRedZoneView = [[NSMutableDictionary alloc] init];
    
    [cameraNames enumerateKeysAndObjectsUsingBlock:
     ^(NSString* _Nonnull cam_name, NSString* _Nonnull cam_id, BOOL* _Nonnull stop) 
     {
         if(EQS(cam_name,Bedroom_1_cam)){_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:1];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:1];}
         if(EQS(cam_name,Bedroom_2_cam)){_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:2];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:2];}
         if(EQS(cam_name,Bedroom_3_cam)){_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:3];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:3];}
         if(EQS(cam_name,Bedroom_4_cam)){_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:4];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:4];}
         if(EQS(cam_name,Bedroom_5_cam)){_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:5];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:5];}
         
         if(EQS(cam_name,Kitchen_cam))  {_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:6];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:6];}
         if(EQS(cam_name,Lobby_cam))    {_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:7];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:7];}
         if(EQS(cam_name,Entryway_cam)) {_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:8];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:8];}
         if(EQS(cam_name,Dining_cam))   {_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:9];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:9];}
         if(EQS(cam_name,Living_cam))   {_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:10];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:10];}
         
         if(EQS(cam_name,Teracce_1_cam)){_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:11];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:11];}
         if(EQS(cam_name,Teracce_2_cam)){_cameraSpotView[cam_id] = [self.targetSpotContainer viewWithTag:12];_cameraRedZoneView[cam_id] = [self.redZoneContainer viewWithTag:12];}
     
         _cameraSpotView[cam_id].hidden = YES;
         _cameraRedZoneView[cam_id].hidden = YES;
     }];
    self.redZoneContainer.hidden = NO;
    self.targetSpotContainer.hidden = NO;
}

#pragma mark - ROUTINES

- (void) prepareToStartGame
{
    
}

#pragma mark - SETUP

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self setupGame];
    [self setupView];
}

- (void) setupGame
{
    _gameController = [[NRGameController alloc] init];
    _gameController.display = self;
    [self prepareToStartGame];
    [_gameController startGame];
}
- (void) setupView
{
    self.redZoneContainer.hidden = YES;
    self.targetSpotContainer.hidden = YES;
}


@end
