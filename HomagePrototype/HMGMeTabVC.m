//
//  HMGMeTabVC.m
//  HomageApp
//
//  Created by Yoav Caspin on 1/5/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import "HMGMeTabVC.h"
#import "HMGResizeableView.h"
#import <MediaPlayer/MediaPlayer.h>

#ifdef USES_IASK_STATIC_LIBRARY
#import "InAppSettingsKit/IASKSettingsReader.h"
#else
#import "IASKSettingsReader.h"
#endif

@interface HMGMeTabVC () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet HMGResizeableView *moviePlaceHolder;
@property (strong,nonatomic) MPMoviePlayerController *movieplayer;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UICollectionView *userRemakesCV;
@property (strong,nonatomic) NSArray *userRemakes;
@property (strong,nonatomic) NSIndexPath *expandedCellIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *closeMovieView;
@property (weak,nonatomic) HMGShareViewController *shareVC;

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
    self.userRemakes = homageCore.myRemakes;
    self.expandedCellIndexPath = nil;
    [self.moviePlaceHolder Position:@"init"];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    self.expandedCellIndexPath = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.moviePlaceHolder Position:@"align"];
    self.expandedCellIndexPath = nil;
    [self.userRemakesCV reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.movieplayer stop];
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
    [self updateCell:cell withRemake:remake withIndexPath:indexPath];
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
        return 235;
    } else {
        return 206;
    }

}


- (void)updateCell:(UICollectionViewCell *)cell withRemake:(HMGRemake *)remake withIndexPath:(NSIndexPath *)indexPath
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    if ([cell isKindOfClass: [HMGUserRemakeCVCell class]]) {
        HMGUserRemakeCVCell *remakeCell = (HMGUserRemakeCVCell *) cell;
        remakeCell.thumbnail.image = remake.thumbnail;
        remakeCell.shareButton.tag = indexPath.item;
        if (![indexPath isEqual:self.expandedCellIndexPath])
        {
            [self collapseCellAtIndexPath:indexPath];
        }
        [self setRemakeCell:remakeCell withStatus: remake.status];
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

-(void)setRemakeCell:(HMGUserRemakeCVCell *)remakeCell withStatus:(HMGRemakeStatus)status
{
    switch (status)
    {
        case HMGRemakeStatusInProgress:
            remakeCell.thumbnail.userInteractionEnabled = NO;
            remakeCell.statusLabel.text = @"incomplete";
            [remakeCell.shareButton setHidden:YES];
            remakeCell.shareButton.enabled = NO;
            remakeCell.remakeButton.enabled = YES;
            remakeCell.completeButton.enabled = YES;
            remakeCell.deleteButton.enabled = YES;
            break;
        case HMGRemakeStatusDone:
            remakeCell.thumbnail.userInteractionEnabled = YES;
            remakeCell.statusLabel.text = @"";
            remakeCell.shareButton.enabled = YES;
            [remakeCell.completeButton setHidden:YES];
            remakeCell.completeButton.enabled = NO;
            remakeCell.remakeButton.enabled = YES;
            remakeCell.deleteButton.enabled = YES;
            break;
        case HMGRemakeStatusNew:
            remakeCell.thumbnail.userInteractionEnabled = NO;
            remakeCell.statusLabel.text = @"New";
            remakeCell.shareButton.enabled = NO;
            remakeCell.remakeButton.enabled = YES;
            remakeCell.completeButton.enabled = YES;
            remakeCell.deleteButton.enabled = YES;
            break;
        case HMGRemakeStatusRendering:
            remakeCell.thumbnail.userInteractionEnabled = NO;
            remakeCell.statusLabel.text = @"rendering";
            remakeCell.shareButton.enabled = NO;
            [remakeCell.completeButton setHidden:YES];
            remakeCell.completeButton.enabled = NO;
            remakeCell.remakeButton.enabled = YES;
            remakeCell.deleteButton.enabled = NO;
            break;
            
    }
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


- (IBAction)collapseMovieView:(id)sender
{
    [self.moviePlaceHolder collapse];
    [self.movieplayer stop];
    self.movieplayer = nil;
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
    self.movieplayer.shouldAutoplay = NO;
    [self.movieplayer.view setFrame: self.moviePlaceHolder.bounds];
    self.movieplayer.scalingMode = MPMovieScalingModeFill;
    [self.moviePlaceHolder addSubview:self.movieplayer.view];
    [self.moviePlaceHolder addSubview:self.closeMovieView];
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

#pragma mark sharing
- (IBAction)shareButtonPushed:(UIButton *)button
{
    HMGShareViewController *vc = [[HMGShareViewController alloc] initWithDefaultNibInParentVC:self];
    self.shareVC = vc;
    NSInteger index = button.tag;
    HMGRemake *remake = self.userRemakes[index];
    NSURL *videoURL = remake.video;
    self.shareVC.URLToShare = [videoURL absoluteString];
    self.shareVC.storyID = remake.storyID;
    self.shareVC.thumbnail = remake.thumbnail;
}

- (IBAction)reloadDataPushed:(id)sender
{
    [self.userRemakesCV reloadData];
}


@end