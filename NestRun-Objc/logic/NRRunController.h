//
//  NRRunController.h
//  NestRun-Objc
//
//  Created by Dima Choock on 11/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RunEventsHandler)(BOOL, BOOL, NSString*);

@interface NRRunController : NSObject

    + (instancetype) makeRunToTarget:(NSString*)targetID avoiding:(NSSet<NSString*>*)redIDs;
    
    - (void) start:(RunEventsHandler)handler;
    - (void) cancel;

@end
