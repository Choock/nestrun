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
#import "NRTargetSpotView.h"
#import "NRRedZoneView.h"
#import "RootContainerVC.h"
#import "RootSegues.h"

@interface NRGameVC () <NRGameDisplay>

    @property (weak, nonatomic) IBOutlet UIView *allSpotsContainer;
    @property (weak, nonatomic) IBOutlet UILabel *gameScoreLabel;
    @property (weak, nonatomic) IBOutlet UILabel *livesLeftLabel;
    @property (weak, nonatomic) IBOutlet UILabel *livesTitleLabel;
    @property (weak, nonatomic) IBOutlet UILabel *runTimeLabel;

    @property (weak, nonatomic) IBOutlet UIView *topbarContainer;
    @property (weak, nonatomic) IBOutlet UIView *fieldContainer;
    @property (weak, nonatomic) IBOutlet UIView *botbarContainer;
    @property (weak, nonatomic) IBOutlet UIButton *leaveButton;

@end

@implementation NRGameVC
{
    NRGameController* _gameController;
    
    NSMutableDictionary<NSString*,NRTargetSpotView*>* _cameraSpotView;
    NSMutableDictionary<NSString*,NRRedZoneView*>* _cameraRedZoneView;
    
    NSSet<NSString*>* _currentReds;
    NSString* _currentTarget;
    NSString* _currentOrigin;
}

#pragma mark - NRGameDisplay IMPLEMENTATION

- (void) setRunTarget:(NSString*)cameraID runTime:(int)rsec waitTime:(int)wsec score:(int)score
{
    _currentTarget = cameraID;
    _cameraSpotView[_currentTarget].hidden = NO;
    _cameraSpotView[_currentTarget].isOrigin = NO;
    _cameraSpotView[_currentTarget].score = score;
    self.runTimeLabel.text = [NSString stringWithFormat:@":%02d", rsec];
}
- (void) setRedZones:(NSSet<NSString*>*)cameraIDs score:(int)score
{
    for (NSString* red in _currentReds) {_cameraRedZoneView[red].hidden = YES;}
    _currentReds = cameraIDs;
    for (NSString* red in _currentReds) 
    {
        _cameraRedZoneView[red].hidden = NO;
        _cameraRedZoneView[red].score = -10;
    }
}

- (void) gameStartedWithInitialScore:(int)score lives:(int)lives
{
    self.gameScoreLabel.text = [NSString stringWithFormat:@"%d",score];
    self.livesLeftLabel.text = [NSString stringWithFormat:@"%d",lives];
}

- (void) secondsToStart:(int)seconds
{
    
}
- (void) secondsToRun:(int)seconds
{
    self.runTimeLabel.text = [NSString stringWithFormat:@":%02d", seconds];
}
- (void) secondsToWait:(int)seconds
{
    
}

- (void) targetReached
{
    [_cameraSpotView[_currentTarget] reached];
}
- (void) redZoneTouched:(NSString*)cameraID
{
    [_cameraRedZoneView[cameraID] touched];
}

- (void) runScore:(int)runScore gameScore:(int)gameScore livesLeft:(int)lives
{
    _cameraSpotView[_currentTarget].score = runScore;
    self.gameScoreLabel.text = [NSString stringWithFormat:@"%d",gameScore];
    self.livesLeftLabel.text = [NSString stringWithFormat:@"%d",lives];
}

- (void) runOver
{
    [self moveOrigin];
}
- (void) gameOver
{
    self.livesLeftLabel.hidden = YES;
    self.livesTitleLabel.text = @"GAME OVER";
}

- (void) moveOrigin
{
    _cameraSpotView[_currentOrigin].hidden = YES;
    _currentOrigin = _currentTarget;
    _cameraSpotView[_currentOrigin].isOrigin = YES;
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
         
         if(EQS(cam_name,Initial_cam)){_cameraSpotView[cam_id] = [self.allSpotsContainer viewWithTag:108];_cameraRedZoneView[cam_id] = [self.allSpotsContainer viewWithTag:8];}
     
         _cameraSpotView[cam_id].hidden = YES;
         _cameraRedZoneView[cam_id].hidden = YES;
         
     }];
    
    self.allSpotsContainer.hidden = NO;
    _currentOrigin = cameraNames[Initial_cam];
    _cameraSpotView[_currentOrigin].hidden = NO;
    _cameraSpotView[_currentOrigin].isOrigin = YES;
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
    self.allSpotsContainer.hidden = YES;
    CALayer* field_layer = self.fieldContainer.layer;
    field_layer.shadowColor = [[UIColor blackColor] CGColor];
    field_layer.shadowOpacity = 1;
    field_layer.shadowRadius = 18;
    field_layer.shadowOffset = CGSizeMake(0, 8);
    
    self.topbarContainer.backgroundColor = [UIColor colorNamed:@"darkBack"];
    self.botbarContainer.backgroundColor = [UIColor colorNamed:@"darkBack"]; 
    
    self.gameScoreLabel.textColor = [UIColor colorNamed:@"whiteText"];
    self.livesLeftLabel.textColor = [UIColor colorNamed:@"whiteText"];
    self.runTimeLabel.textColor   = [UIColor colorNamed:@"whiteText"];
    
    CALayer* button_layer = self.leaveButton.layer;
    button_layer.cornerRadius = 15;
    button_layer.borderWidth = 1;
    button_layer.borderColor = [[UIColor colorNamed:@"whiteText"] CGColor];
}

#pragma mark - HANDLERS

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

- (IBAction)onLeaveGame:(id)sender 
{
    [_gameController stopGame];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), 
    ^{
        RootContainerVC* root = (RootContainerVC*)(self.parentViewController);
        [root performSegueWithIdentifier:RootLobbySegue.sid sender:self];
    });
}



@end
