//
//  RootContainerVC.m
//  Duplets
//
//  Created by Dmitry Demenchoock on 07/01/16.
//  Copyright © 2016 UAB Mechanikus. All rights reserved.
//

#import "RootContainerVC.h"
#import "RootSegues.h"
#import "NRNestAccessService.h"

@interface RootContainerVC ()

@end

@implementation RootContainerVC
{
    __weak UIViewController* _presentChildVC;
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    BOOL acces_granted = [NRNestAccessService shared].accessGranted;
                          
    if(!acces_granted) [self performSegueWithIdentifier:[RootLoginSegue sid] sender:nil];
    else               [self performSegueWithIdentifier:[RootLobbySegue sid] sender:nil];
}

- (void) setup
{

}

- (UIViewController*) presentChildVC
{
    return _presentChildVC;
}


#pragma mark - SIMPLEROOT OVERRIDES

- (void) willPresentNewChild:(UIViewController*)child
{
    [super willPresentNewChild:child];
}

- (void) didPresentNewChild:(UIViewController *)child
{
    [super didPresentNewChild:child];
    _presentChildVC = child;
}

#pragma mark - SEGUES, CONTROLS, EVENTS

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

@end
