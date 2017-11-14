//
//  NRGameController.h
//  NestRun-Objc
//
//  Created by Dima Choock on 11/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NRGameDisplay

    - (void) attachCameras:(NSDictionary*)cameraNames;
    - (void) gameStartedWithInitialScore:(int)score lives:(int)lives;

    - (void) setRunTarget:(NSString*)cameraID runTime:(int)rsec waitTime:(int)wsec score:(int)score;
    - (void) setRedZones:(NSSet<NSString*>*)cameraIDs score:(int)score;

    - (void) secondsToStart:(int)seconds;
    - (void) secondsToRun:(int)seconds;
    - (void) secondsToWait:(int)seconds;

    - (void) targetReached;
    - (void) runOver;
    - (void) redZoneTouched:(NSString*)cameraID;

    - (void) runScore:(int)runScore gameScore:(int)gameScore livesLeft:(int)lives;
    - (void) gameOver;

@end

@interface NRGameController : NSObject

    @property(nonatomic,strong) id<NRGameDisplay> display;

    - (void) startGame;
    - (void) stopGame;
    - (void) startSimGame:(NSString*)ename;

@end
