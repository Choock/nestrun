//
//  NRRedZoneView.m
//  NestRun-Objc
//
//  Created by Dima Choock on 13/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "NRRedZoneView.h"

@implementation NRRedZoneView
{
    UILabel* __weak _touchScore;
    UIImageView* __weak _image;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        _touchScore = [self viewWithTag:66];
        _touchScore.textColor = [UIColor whiteColor];
        self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        _image = [self viewWithTag:44];
        _image.image = [UIImage animatedImageNamed:@"redZone-" duration:1.4];
    }
    return self;
}
- (void) setScore:(int)score
{
    _score = score;
    _touchScore.text = [NSString stringWithFormat:@"%d",score];
}

- (void) touched
{
    UIColor* def_color = self.backgroundColor;
    [UIView animateWithDuration:0.1 
                     animations:
     ^{
         self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
     } completion:
     ^(BOOL finished) 
     {
         [UIView animateWithDuration:0.3 
         animations:
          ^{
              self.backgroundColor = def_color;
          }];
     }];
}


@end
