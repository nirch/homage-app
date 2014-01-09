//
//  HMGMeTabVC.m
//  HomageApp
//
//  Created by Yoav Caspin on 1/5/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import "HMGMeTabVC.h"
#import "HMGMePlayerView.h"
#import <MediaPlayer/MediaPlayer.h>

#ifdef USES_IASK_STATIC_LIBRARY
#import "InAppSettingsKit/IASKSettingsReader.h"
#else
#import "IASKSettingsReader.h"
#endif

@interface HMGMeTabVC () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet HMGMePlayerView *moviePlaceHolder;
@property (strong,nonatomic) MPMoviePlayerController *movieplayer;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UICollectionView *userRemakesCV;
@property (strong,nonatomic) NSArray *userRemakes;
@property (strong,nonatomic) NSIndexPath *expandedCellIndexPath;

@end

@implementation HMGMeTabVC

- (IASKAppSettingsViewController*)appSettingsViewController {
	if (!appSettingsViewController) {
		appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
		appSettingsViewController.delegate = self;
		BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"AutoConnect"];
		appSettingsViewController.hiddenKeys = enabled ? nil : [NSSet setWithObjects:@"AutoConnectLogin", @"AutoConnectPassword", nil];
	}
	return appSettingsViewController;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    HMGHomage *homageCore = [HMGHomage sharedHomage];
    self.userName.text = homageCore.me.userName;
    self.userImage.image = homageCore.me.image;
    self.userRemakes = homageCore.myRemakes;
    self.expandedCellIndexPath = nil;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.moviePlaceHolder startPosition];
    self.expandedCellIndexPath = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.moviePlaceHolder startPosition];
    self.expandedCellIndexPath = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.moviePlaceHolder startPosition];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
 return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    HMGLogDebug(@"%s started and finished" , __PRETTY_FUNCTION__);
    return [self.userRemakes count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    UICollectionViewCell *cell = [self.userRemakesCV dequeueReusableCellWithReuseIdentifier:@"RemakeCell"
                                                                              forIndexPath:indexPath];
    HMGRemake *remake = self.userRemakes[indexPath.item];
    [self updateCell:cell withRemake:remake];
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Return the size of each cell to draw
    CGSize cellSize = (CGSize) { .width = 319, .height = [self heightForCellAtIndexPath:indexPath]};
    return cellSize;
}

-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.expandedCellIndexPath])
    {
        return 154;
    } else {
        return 121;
    }

}


- (void)updateCell:(UICollectionViewCell *)cell withRemake:(HMGRemake *)remake
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    if ([cell isKindOfClass: [HMGUserRemakeCVCell class]]) {
        HMGUserRemakeCVCell *remakeCell = (HMGUserRemakeCVCell *) cell;
        //remakeCell.thumbnail.userInteractionEnabled = YES;
        NSLog(@"item size is: %f,%f" , remakeCell.intrinsicContentSize.height , remakeCell.intrinsicContentSize.width);
        remakeCell.thumbnail.image = remake.thumbnail;
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}


-(IBAction)playRemake:(UITapGestureRecognizer *)gesture
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    CGPoint tapLocation = [gesture locationInView:self.userRemakesCV];
    NSIndexPath *indexPath = [self.userRemakesCV indexPathForItemAtPoint:tapLocation];
    if (indexPath)
    {
        HMGRemake *remake = self.userRemakes[indexPath.item];
        [self.moviePlaceHolder expand];
        [self playRemakeVideoWithURL:remake.video];
        HMGLogInfo(@"the user selected remake at index: @d" , indexPath.item);
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}


- (IBAction)expandRemakeCell:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.userRemakesCV];
    NSIndexPath *indexPath = [self.userRemakesCV indexPathForItemAtPoint:tapLocation];
    if (indexPath)
    {
        [self collapseCellAtIndexPath:self.expandedCellIndexPath];
        self.expandedCellIndexPath = indexPath;
        HMGUserRemakeCVCell *cell = (HMGUserRemakeCVCell *)[self.userRemakesCV cellForItemAtIndexPath:indexPath];
        [cell.moreView setHidden:YES];
        [cell.expandedView setHidden:NO];
        [self.userRemakesCV performBatchUpdates:nil completion:nil];
    }
    
}

-(void)collapseCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return;
    HMGUserRemakeCVCell *cell = (HMGUserRemakeCVCell *)[self.userRemakesCV cellForItemAtIndexPath:indexPath];
    [cell.expandedView setHidden:YES];
    [cell.moreView setHidden:NO];
}



-(void)playRemakeVideoWithURL:(NSURL *)videoURL
{
    self.movieplayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    self.movieplayer.controlStyle = MPMovieControlStyleEmbedded;
    self.movieplayer.shouldAutoplay = YES;
    [self.movieplayer.view setFrame: self.moviePlaceHolder.bounds];
    self.movieplayer.scalingMode = MPMovieScalingModeFill;
    [self.moviePlaceHolder addSubview:self.movieplayer.view];
    [self.movieplayer setFullscreen:NO animated:YES];
}

- (IBAction)showSettingModal:(id)sender
{
    UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
    [self.appSettingsViewController setShowCreditsFooter:NO];
    self.appSettingsViewController.showDoneButton = YES;
    [self presentViewController:aNavController animated:YES completion:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
	// your code here to reconfigure the app for changed settings
}

@end
