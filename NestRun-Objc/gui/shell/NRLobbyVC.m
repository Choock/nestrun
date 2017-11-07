//
//  NRLobbyVC.m
//  NestRun-Objc
//
//  Created by Dima Choock on 06/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "NRLobbyVC.h"
#import "NRNestCameraFetcher.h"

@interface NRLobbyVC ()

@end

@implementation NRLobbyVC

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [[NRNestCameraFetcher shared] fetchCameras:
    ^(BOOL success) 
    {
        if(success) NSLog(@"CAMERAS FETCHED");
    }];
}



@end
