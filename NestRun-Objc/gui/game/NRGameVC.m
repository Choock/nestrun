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

    @property (weak, nonatomic) IBOutlet UIView *allSpotsContainer;

@end

@implementation NRGameVC
{
    NRGameController* _gameController;
    
    NSMutableDictionary<NSString*,UIView*>* _cameraSpotView;
    NSMutableDictionary<NSString*,UIView*>* _cameraRedZoneView;
    
    NSSet<NSString*>* _currentReds;
    NSString* _currentTarget;
    NSString* _currentOrigin;
}

#pragma mark - NRGameDisplay IMPLEMENTATION

- (void) setRunTarget:(NSString*)cameraID runTime:(int)rsec waitTime:(int)wsec score:(int)score
{
    _currentTarget = cameraID;
    _cameraSpotView[_currentTarget].hidden = NO;
    _cameraSpotView[_currentTarget].backgroundColor = [UIColor blueColor];
}
- (void) setRedZones:(NSSet<NSString*>*)cameraIDs score:(int)score
{
    for (NSString* red in _currentReds) {_cameraRedZoneView[red].hidden = YES;}
    _currentReds = cameraIDs;
    for (NSString* red in _currentReds) {_cameraRedZoneView[red].hidden = NO;}
}

- (void) gameStartedWithInitialScore:(int)score lives:(int)lives
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

- (void) runOver
{
    [self moveOrigin];
}
- (void) gameOver
{
    
}

- (void) moveOrigin
{
    _cameraSpotView[_currentOrigin].hidden = YES;
    _currentOrigin = _currentTarget;
    _cameraSpotView[_currentOrigin].backgroundColor = [UIColor greenColor];
}

/// Temp test implementation: manual attaching cameras to spots
- (void) attachCameras:(NSDictionary*)cameraNames
{
    _cameraSpotView = [[NSMutableDictionary alloc] init];
    _cameraRedZoneView = [[NSMutableDictionary alloc] init];
    
    [cameraNames enumerateKeysAndObjectsUsingBlock:
     ^(NSString* _Nonnull cam_name, NSString* _Nonnull cam_id, BOOL* _Nonnull stop) 
     {
         if(EQS(cam_name,Bedroom_1_cam)){_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:101];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:1];}
         if(EQS(cam_name,Bedroom_2_cam)){_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:102];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:2];}
         if(EQS(cam_name,Bedroom_3_cam)){_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:103];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:3];}
         if(EQS(cam_name,Bedroom_4_cam)){_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:104];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:4];}
         if(EQS(cam_name,Bedroom_5_cam)){_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:105];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:5];}
         
         if(EQS(cam_name,Kitchen_cam))  {_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:106];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:6];}
         if(EQS(cam_name,Lobby_cam))    {_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:107];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:7];}
         if(EQS(cam_name,Entryway_cam)) {_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:108];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:8];}
         if(EQS(cam_name,Dining_cam))   {_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:109];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:9];}
         if(EQS(cam_name,Living_cam))   {_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:110];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:10];}
         
         if(EQS(cam_name,Teracce_1_cam)){_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:111];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:11];}
         if(EQS(cam_name,Teracce_2_cam)){_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:112];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:12];}
     
         _cameraSpotView[cam_id].hidden = YES;
         _cameraRedZoneView[cam_id].hidden = YES;
     }];
    
    self.allSpotsContainer.hidden = NO;
    _currentOrigin = cameraNames[Entryway_cam];
    _cameraSpotView[_currentOrigin].hidden = NO;
    _cameraSpotView[_currentOrigin].backgroundColor = [UIColor greenColor];
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
    //[_gameController startGame];
    [_gameController startSimGame:@"put"];
}
- (void) setupView
{
    self.allSpotsContainer.hidden = YES;
}

#pragma mark - RECOGNISERS

- (IBAction)onTap:(UITapGestureRecognizer *)sender 
{
    UIView* tapped_view = sender.view;
    BOOL __block found = NO;
    [_cameraSpotView enumerateKeysAndObjectsUsingBlock:
    ^(NSString * _Nonnull cid, UIView * _Nonnull view, BOOL * _Nonnull stop) 
    {
        if(tapped_view != view) return;
        [self sendSimEventFor:cid];
        found = YES;
        *stop = YES;
    }];
    [_cameraRedZoneView enumerateKeysAndObjectsUsingBlock:
     ^(NSString * _Nonnull cid, UIView * _Nonnull view, BOOL * _Nonnull stop) 
     {
         if(tapped_view != view) return;
         [self sendSimEventFor:cid];
         *stop = YES;
     }];
}
     
- (void) sendSimEventFor:(NSString*)cid
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"put" object:nil userInfo:@{@"cid":cid}];
}



@end
