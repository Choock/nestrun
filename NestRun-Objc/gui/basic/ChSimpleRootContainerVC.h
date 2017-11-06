//
//  ChSimpleRootContainerVC.h
//  AppComps
//
//  Created by Dmitry Demenchoock on 09/06/15.
//  Copyright (c) 2015 UAB Mechanikus. All rights reserved.
//

@import UIKit;
#import "appmacros.h"

// Animation type id enum --------------------------------------------
typedef NS_ENUM(int, ChSimpleRootContainerReplacementAnimation)
{
    rra_NoAnimation = 0,
    // slide current and pull new
    rra_SlideLeft,
    rra_SlideRight,
    rra_SlideUp,
    rra_SlideDown,
    // slide current and reveal new
    rra_SlideOverLeft,
    rra_SlideOverRight,
    rra_SlideOverUp,
    rra_SlideOverDown,
    // slide new and hide current
    rra_SlideHideLeft,
    rra_SlideHideRight,
    rra_SlideHideUp,
    rra_SlideHideDown,
    // flip
    rra_FlipHLeft,
    rra_FlipHRight,
    rra_FlipVTop,
    rra_FlipVBottom,
    // cross fade
    rra_Dissolve,
    // zoom and cross fade
    rra_ZoomInFade,
    rra_ZoomOutFade    
};

// Animation descriptor dictionary keys ------------------------------
KEY_NAME(RRA_ID);         // ChSimpleRootContainerReplacementAnimation
KEY_NAME(RRA_OPTS);       // UIViewAnimationOptions
KEY_NAME(RRA_TIME);       // duration
KEY_NAME(RRA_X_OVERRUN);  // continue animation in wider container
KEY_NAME(RRA_Y_OVERRUN);  // continue animation in taller container

/**
 *  ChSimpleContainerVC simple custom container viewcontroller.
 *  Implements inserting of any content-viewcontrooler with or without animation
 */
@interface ChSimpleRootContainerVC : UIViewController

    - (void) replacePresentVCwithVC:(UIViewController*)next withAnimation:(ChSimpleRootContainerReplacementAnimation)animation;
    - (void) replacePresentVCwithVC:(UIViewController*)next withAnimationDescriptor:(NSDictionary*)adescriptor;

    // Overridables
    - (void) addToHierarchy:(UIViewController*)next toReplace:(UIViewController*)present presentOver:(BOOL)over;
    - (void) willPresentNewChild:(UIViewController*)child;
    - (void) didPresentNewChild:(UIViewController*)child;
    - (void) didAddNewChildSubview:(UIView*)child_view;

@end
