//
//  NRGameLobby.m
//  NestRun-Objc
//
//  Created by Dima Choock on 14/11/2017.
//  Copyright © 2017 Dima Choock. All rights reserved.
//

#import "NRGameLobbyVC.h"
#import "RootContainerVC.h"
#import "RootSegues.h"
#import "NRModelNames.h"
#import  "NRNestCameraFetcher.h"

@interface NRGameLobbyVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

    @property (strong,readonly) NSArray<NSDictionary*>* usersData;
    @property (weak, nonatomic) IBOutlet UICollectionView *playerList;

    @property (weak, nonatomic) IBOutlet UIView *topContainer;
    @property (weak, nonatomic) IBOutlet UIView *botContainer;
    @property (weak, nonatomic) IBOutlet UIView *contentContainer;

    @property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation NRGameLobbyVC
{
    NSArray<NSDictionary*>* _usersData;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    self.playerList.delegate = self;
    self.playerList.dataSource = self;
    [self.view layoutSubviews];
    [self setupView];
    //[self testStreaming];
}

- (void) setupView
{
    // Collection view
    self.playerList.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
//    CAGradientLayer* gradient_mask = [CAGradientLayer layer];
//    CGRect mask_frame = self.contentContainer.bounds;
//    gradient_mask.frame = mask_frame;
//    gradient_mask.colors = @[ (id)[[[UIColor blackColor] colorWithAlphaComponent:0.4] CGColor], 
//                              (id)[[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor], 
//                              (id)[[[UIColor blackColor] colorWithAlphaComponent:0.0] CGColor],
//                              (id)[[[UIColor blackColor] colorWithAlphaComponent:0.0] CGColor],
//                              (id)[[[UIColor blackColor] colorWithAlphaComponent:0.3] CGColor], 
//                              (id)[[[UIColor blackColor] colorWithAlphaComponent:0.4] CGColor]];
//    gradient_mask.locations = @[@(0), @(0.02),@(0.5),@(0.5),@(0.98),@(1)];
//    [self.contentContainer.layer addSublayer:gradient_mask];
    
    CALayer* content_layer = self.contentContainer.layer;
    content_layer.shadowColor = [[UIColor blackColor] CGColor];
    content_layer.shadowOpacity = 1;
    content_layer.shadowRadius = 18;
    content_layer.shadowOffset = CGSizeMake(0, 8);
    
    self.topContainer.backgroundColor = [UIColor colorNamed:@"darkBack"];
    self.botContainer.backgroundColor = [UIColor colorNamed:@"darkBack"]; 
    
//    self.gameScoreLabel.textColor = [UIColor colorNamed:@"whiteText"];
//    self.livesLeftLabel.textColor = [UIColor colorNamed:@"whiteText"];
//    self.runTimeLabel.textColor   = [UIColor colorNamed:@"whiteText"];
    
    CALayer* button_layer = self.startButton.layer;
    button_layer.cornerRadius = 15;
    button_layer.borderWidth = 1;
    button_layer.borderColor = [[UIColor colorNamed:@"whiteText"] CGColor];
}

#pragma mark - HANDLERS

- (IBAction)onStartButton:(id)sender 
{
    RootContainerVC* root = (RootContainerVC*)(self.parentViewController);
    [root performSegueWithIdentifier:RootGameSegue.sid sender:self];
}


#pragma mark - COLLECTION VIEW (simple fast implementation)

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat screen_width = [UIScreen mainScreen].bounds.size.width;
    CGFloat cell_width = screen_width/2 - 12;
    CGFloat cell_height = cell_width*22/16;
    return  CGSizeMake(cell_width, cell_height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profileCell" forIndexPath:indexPath];
    [self configure:cell index:indexPath];
    return cell;
}

- (void) configure:(UICollectionViewCell*)cell index:(NSIndexPath *)index
{
    UIImageView* image = [cell viewWithTag:9];
    UILabel* name_label = [cell viewWithTag:10];
    UILabel* score_label = [cell viewWithTag:20];
    image.layer.cornerRadius = 8;
    image.layer.borderWidth = 0.5;
    image.layer.borderColor = [[UIColor colorNamed:@"liteGray"] CGColor];
    
    NSDictionary* descriptor = self.usersData[index.row];
    image.image = [UIImage imageNamed:descriptor[image_key]];
    name_label.text = descriptor[name_key];
    score_label.text = descriptor[score_key];
}

#pragma mark - AUX

/// Demo data

static NSString* name_key  = @"uname";
static NSString* image_key = @"upict";
static NSString* score_key = @"score";

- (NSArray<NSDictionary*>*) usersData
{
    if(_usersData != nil) return _usersData;
    
    
    _usersData = @[
                       @{name_key:@"Tony",   image_key:@"tony", score_key:@"23 600"},
                       @{name_key:@"Matt",   image_key:@"matt", score_key:@"21 120"},
                       @{name_key:@"Serega", image_key:@"serg", score_key:@"18 760"},
                       @{name_key:@"El",     image_key:@"el", score_key:@"12 100"},
                       @{name_key:@"Marik",  image_key:@"mark", score_key:@"9 800"},
                  ];
    return _usersData;
}

#pragma mark - PRE GAME STREAMING TEST

- (void) testStreaming
{
    [[NRNestCameraFetcher shared] fetchCameras:
     ^(BOOL success) 
     {
         if(success) NSLog(@"CAMERAS FETCHED");
         
         NSString* entry_cam_id = [NRNestCameraFetcher shared].cameraIDs[Bedroom_1_cam];
         NRGameLobbyVC* __weak wself = self;
         [[NRNestCameraFetcher shared] switchOnListenerForCameraID:entry_cam_id 
                                                           handler:
          ^(CameraEvent* event)
          {
              [wself onCameraEvent:event];
          }];
         
         [[NRNestCameraFetcher shared] startCamerasObserving];
     }];
}

- (void) onCameraEvent:(CameraEvent*)event
{
    NSString* event_string = @"";
    if(event.type & cet_motion) event_string = [event_string stringByAppendingString:@"motion"];
    if(event.type & cet_sound) event_string = [event_string stringByAppendingString:@" sound"];
    if(event.type & cet_person) event_string = [event_string stringByAppendingString:@" person"];
    
    NSLog(@"Camera event:");
    NSLog(@"--- type: %@",event_string);
    NSLog(@"--- started: %@",event.eventStart);
    NSLog(@"--- stopped: %@",event.eventStop);
}


@end
