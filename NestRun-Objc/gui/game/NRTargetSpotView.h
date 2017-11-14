//
//  NRTargetSpotView.h
//  NestRun-Objc
//
//  Created by Dima Choock on 13/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRTargetSpotView : UIView

    @property(nonatomic,assign) int score;
    @property(nonatomic,assign) BOOL isOrigin;
    
    - (void) reached;
    - (void) missed;

@end
