//
//  NRLobbyVC.m
//  NestRun-Objc
//
//  Created by Dima Choock on 06/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "NRLobbyVC.h"
#import "NRNestCameraFetcher.h"
#import "RootContainerVC.h"
#import "RootSegues.h"
#import "NRModelNames.h"

@interface NRLobbyVC()

@end

@implementation NRLobbyVC

- (void)viewDidLoad 
{
    [super viewDidLoad];
    //[self testStreaming];
}

- (IBAction)onStart:(id)sender 
{
    RootContainerVC* root = (RootContainerVC*)(self.parentViewController);
    [root performSegueWithIdentifier:RootGameSegue.sid sender:self];
}

// Тестовые игровые хендлеры

- (void) testStreaming
{
    [[NRNestCameraFetcher shared] fetchCameras:
     ^(BOOL success) 
     {
         if(success) NSLog(@"CAMERAS FETCHED");
         
         NSString* entry_cam_id = [NRNestCameraFetcher shared].cameraIDs[Bedroom_1_cam];
         NRLobbyVC* __weak wself = self;
         [[NRNestCameraFetcher shared] switchOnListenerForCameraID:entry_cam_id 
                                                           handler:
          ^(CameraEvent* event)
          {
              [wself onCameraEvent:event];
          }];
         
         [[NRNestCameraFetcher shared] startCamerasObserving];
     }];
}

- (void) onCameraEvent:(CameraEvent*)event
{
    NSString* event_string = @"";
    if(event.type & cet_motion) event_string = [event_string stringByAppendingString:@"motion"];
    if(event.type & cet_sound) event_string = [event_string stringByAppendingString:@" sound"];
    if(event.type & cet_person) event_string = [event_string stringByAppendingString:@" person"];
    
    NSLog(@"Camera event:");
    NSLog(@"--- type: %@",event_string);
    NSLog(@"--- started: %@",event.eventStart);
    NSLog(@"--- stopped: %@",event.eventStop);
}




@end
