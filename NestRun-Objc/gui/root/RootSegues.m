//
//  RootSegues.m
//  Duplets
//
//  Created by Dmitry Demenchoock on 07/01/16.
//  Copyright © 2016 UAB Mechanikus. All rights reserved.
//

#import "RootSegues.h"
#import "RootContainerVC.h"


@implementation RootLoginSegue

+ (NSString*) sid 
{
    return [RootLoginSegue.class description];
}

- (void) perform
{
    RootContainerVC* root = (RootContainerVC*)self.sourceViewController;
    [root replacePresentVCwithVC:self.destinationViewController withAnimation:rra_NoAnimation];
}

@end

@implementation RootLobbySegue

+ (NSString*) sid 
{
    return [RootLobbySegue.class description];
}

- (void) perform
{
    RootContainerVC* root = (RootContainerVC*)self.sourceViewController;
    ChSimpleRootContainerReplacementAnimation animation = rra_SlideDown;
    
//    if     ([root.presentChildVC isKindOfClass:[GameFieldVC class]]) animation = rra_SlideDown;
//    else if([root.presentChildVC isKindOfClass:[GameStatsVC class]]) animation = rra_SlideDown;
//    else                                                             animation = rra_Dissolve;
    
    NSDictionary* a_descriptor = @{
                                   RRA_ID       :@(animation),
                                   RRA_OPTS     :@(UIViewAnimationOptionCurveLinear),
                                   RRA_TIME     :@(0.3),
                                   RRA_X_OVERRUN:@(0),
                                   RRA_Y_OVERRUN:@(0)
                                   };
    
    [root replacePresentVCwithVC:self.destinationViewController
         withAnimationDescriptor:a_descriptor];
}

@end





