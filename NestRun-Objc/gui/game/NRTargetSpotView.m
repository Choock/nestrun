//
//  NRTargetSpotView.m
//  NestRun-Objc
//
//  Created by Dima Choock on 13/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "NRTargetSpotView.h"

@implementation NRTargetSpotView
{
    UILabel* __weak _targetScore;
    UIImageView* __weak _image;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        _targetScore = [self viewWithTag:55];
        _targetScore.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        _image = [self viewWithTag:11];
    }
    return self;
}

- (void) setScore:(int)score
{
    _score = score;
    _targetScore.textColor = (score>0) ? [UIColor whiteColor] : [UIColor redColor];
    _targetScore.text = [NSString stringWithFormat:@"%d",score];
}
- (void) setIsOrigin:(BOOL)isOrigin
{
    _isOrigin = isOrigin;
    _targetScore.hidden = isOrigin;
    _image.image = (isOrigin)? [UIImage animatedImageNamed:@"origin-" duration:1.5] : [UIImage animatedImageNamed:@"target-" duration:1];
}

- (void) reached
{
    // TODO: target reached animation
}
- (void) missed
{
    // TODO: target missed animation
}


@end
