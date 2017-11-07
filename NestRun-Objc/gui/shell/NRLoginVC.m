//
//  NRLoginVC.m
//  NestRun-Objc
//
//  Created by Dima Choock on 06/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "NRLoginVC.h"
#import "RootContainerVC.h"
#import "RootSegues.h"
#import "NRNestAccessService.h"

@interface NRLoginVC ()

    @property (weak, nonatomic) IBOutlet UIWebView* loginWebView;

@end

@implementation NRLoginVC

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NRLoginVC* __weak weakself = self;
    [[NRNestAccessService shared] loginIn:self.loginWebView
    callback:
    ^(BOOL success) 
    {
        if(success) [weakself transitToLobby];
        else        [weakself showErrorAndRetry];
    }];
}

#pragma mark - LOGIN RESULT HANDLERS

- (void) transitToLobby
{
    UIViewController* root = self.parentViewController;
    if(!root)
    {
        NSLog(@"GUI inconsistency: root controller not found");
        [self showErrorAndRetry];
    }
    else
    {
        [root performSegueWithIdentifier:[RootLobbySegue sid] sender:nil];
    }
}

- (void) showErrorAndRetry
{
    
}

@end
