//
//  HMGMeTabVC.m
//  HomageApp
//
//  Created by Yoav Caspin on 1/5/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import "HMGMeTabVC.h"
#import <MediaPlayer/MediaPlayer.h>

#ifdef USES_IASK_STATIC_LIBRARY
#import "InAppSettingsKit/IASKSettingsReader.h"
#else
#import "IASKSettingsReader.h"
#endif

@interface HMGMeTabVC () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic) MPMoviePlayerController *movieplayer;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UICollectionView *userRemakesCV;
@property (strong,nonatomic) NSArray *userRemakes;
//@property (weak,nonatomic) HMGShareViewController *shareVC;

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
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
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
    
    //border design
    [cell.layer setBorderColor:[UIColor colorWithRed:213.0/255.0f green:210.0/255.0f blue:199.0/255.0f alpha:1.0f].CGColor];
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setCornerRadius:7.5f];
    [cell.layer setShadowOffset:CGSizeMake(0, 1)];
    [cell.layer setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [cell.layer setShadowRadius:8.0];
    [cell.layer setShadowOpacity:0.8];

    return cell;
}

/*- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
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

}*/


- (void)updateCell:(UICollectionViewCell *)cell withRemake:(HMGRemake *)remake withIndexPath:(NSIndexPath *)indexPath
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    if ([cell isKindOfClass: [HMGUserRemakeCVCell class]]) {
        HMGUserRemakeCVCell *remakeCell = (HMGUserRemakeCVCell *) cell;
        remakeCell.shareButton.tag = indexPath.item;
        remakeCell.actionButton.tag = indexPath.item;
        remakeCell.closeMovieButton.tag = indexPath.item;
        
        if (remake.thumbnail)
        {
            remakeCell.thumbnail.image = remake.thumbnail;
        } else
        {
            if (remake.thumbnailURL)
            {
                // Loading the thumbnail (doing this on a different thread)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    // Downloading the thumbnail from URL
                    NSError *thumbnailDownloadError;
                    remake.thumbnail = [UIImage imageWithData:[NSData dataWithContentsOfURL:remake.thumbnailURL options:NSDataReadingMappedAlways error:&thumbnailDownloadError]];
                    if (thumbnailDownloadError)
                    {
                        NSString *errorDescription = [NSString stringWithFormat:@"Trying to download image from: %@, resulted with the following error: %@", remake.thumbnailURL.path, thumbnailDownloadError.description];
                        HMGLogError(errorDescription);
                        [NSException raise:@"ConnectivityException" format:@"%@", errorDescription];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        remakeCell.thumbnail.image = remake.thumbnail;
                    });
                });
            } else
            {
                // Error - No URL
                HMGLogError(@"story <%@> has no thumbnail URL", remake.remakeID);
            }
        }
        
        [self setRemakeCell:remakeCell withStatus: remake.status];
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}

-(void)setRemakeCell:(HMGUserRemakeCVCell *)remakeCell withStatus:(HMGRemakeStatus)status
{
    NSString *imagePath;
    UIImage *bgimage;
    
    switch (status)
    {
        case HMGRemakeStatusInProgress:
            imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"under-construction" ofType:@"png"];
            bgimage = [UIImage imageWithContentsOfFile:imagePath];
            [remakeCell.actionButton setBackgroundImage:bgimage forState:UIControlStateNormal];
            [remakeCell.shareButton setHidden:YES];
            remakeCell.shareButton.enabled = NO;
            remakeCell.remakeButton.enabled = YES;            
            remakeCell.deleteButton.enabled = YES;
            break;
        case HMGRemakeStatusDone:
            imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"pb_play_icon" ofType:@"png"];
            bgimage = [UIImage imageWithContentsOfFile:imagePath];
            [remakeCell.actionButton setBackgroundImage:bgimage forState:UIControlStateNormal];
            remakeCell.shareButton.enabled = YES;
            remakeCell.remakeButton.enabled = YES;
            remakeCell.deleteButton.enabled = YES;
            break;
        
        case HMGRemakeStatusNew:
            imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"under-construction.png" ofType:nil];
            bgimage = [UIImage imageWithContentsOfFile:imagePath];
            [remakeCell.actionButton setBackgroundImage:bgimage forState:UIControlStateNormal];
            [remakeCell.shareButton setHidden:YES];
            remakeCell.shareButton.enabled = NO;
            remakeCell.remakeButton.enabled = YES;
            remakeCell.deleteButton.enabled = YES;
            break;

        case HMGRemakeStatusRendering:
            [remakeCell.actionButton setTitle:@"render" forState:UIControlStateNormal];
            remakeCell.shareButton.enabled = NO;
            remakeCell.remakeButton.enabled = YES;
            remakeCell.deleteButton.enabled = NO;
            break;
            
    }
}


- (IBAction)actionButtonPushed:(UIButton *)sender
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    NSInteger index = sender.tag;
    HMGRemake *remake = self.userRemakes[index];
    HMGLogInfo(@"the user selected remake at index: %d" , index);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    HMGUserRemakeCVCell *cell = (HMGUserRemakeCVCell *)[self.userRemakesCV cellForItemAtIndexPath:indexPath];
    //HMGUserRemakeCVCell *cell = (HMGUserRemakeCVCell *)sender.superview.superview;
    
    [self displayViewBounds:cell.moviePlaceHolder];
    
    switch (remake.status)
    {
        case HMGRemakeStatusDone:
            [self playRemakeVideoWithURL:remake.video inCell:cell];
            break;
        case HMGRemakeStatusInProgress:
            //TODO:connect to recorder at last non taken scene
            break;
        case HMGRemakeStatusNew:
            //TODO:connect to recorder at last non taken scene
            break;
        case HMGRemakeStatusRendering:
            break;
    }

    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}


/*-(IBAction)playRemake:(UITapGestureRecognizer *)gesture
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    CGPoint tapLocation = [gesture locationInView:self.userRemakesCV];
    NSIndexPath *indexPath = [self.userRemakesCV indexPathForItemAtPoint:tapLocation];
    if (indexPath)
    {
        HMGRemake *remake = self.userRemakes[indexPath.item];
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
        HMGUserRemakeCVCell *cell = (HMGUserRemakeCVCell *)[self.userRemakesCV cellForItemAtIndexPath:indexPath];
        [self.userRemakesCV performBatchUpdates:nil completion:nil];
    }
    
}*/

/*- (IBAction)collapseMovieView:(id)sender
{
    [self.moviePlaceHolder collapse];
    [self.movieplayer stop];
    self.movieplayer = nil;
}*/

/*-(void)collapseCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return;
    HMGUserRemakeCVCell *cell = (HMGUserRemakeCVCell *)[self.userRemakesCV cellForItemAtIndexPath:indexPath];
    [cell.expandedView setHidden:YES];
    [cell.moreView setHidden:NO];
}*/



-(void)playRemakeVideoWithURL:(NSURL *)videoURL inCell:(UICollectionViewCell *)cell
{
    
    HMGUserRemakeCVCell *remakeCell;
    if ([cell isKindOfClass:[HMGUserRemakeCVCell class]])
    {
        remakeCell = (HMGUserRemakeCVCell *)cell;
    }
    self.movieplayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    self.movieplayer.controlStyle = MPMovieControlStyleEmbedded;
    self.movieplayer.scalingMode = MPMovieScalingModeFill;
    [self.movieplayer.view setFrame: cell.bounds];
    self.movieplayer.shouldAutoplay = YES;
    [remakeCell.moviePlaceHolder insertSubview:self.movieplayer.view belowSubview:remakeCell.closeMovieButton];
    [remakeCell.thumbnail setHidden:YES];
    [remakeCell addSubview:remakeCell.moviePlaceHolder];
    [self.movieplayer setFullscreen:NO animated:YES];
}
- (IBAction)closeMovieButtonPushed:(UIButton *)sender
{
    [self.movieplayer stop];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    HMGUserRemakeCVCell *cell = (HMGUserRemakeCVCell *)[self.userRemakesCV cellForItemAtIndexPath:indexPath];
    [cell.moviePlaceHolder removeFromSuperview];
    [cell.thumbnail setHidden:NO];
    
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
/*- (IBAction)shareButtonPushed:(UIButton *)button
{
    HMGShareViewController *vc = [[HMGShareViewController alloc] initWithDefaultNibInParentVC:self];
    self.shareVC = vc;
    NSInteger index = button.tag;
    HMGRemake *remake = self.userRemakes[index];
    NSURL *videoURL = remake.video;
    self.shareVC.URLToShare = [videoURL absoluteString];
    self.shareVC.storyID = remake.storyID;
    self.shareVC.thumbnail = remake.thumbnail;
}*/

- (IBAction)reloadDataPushed:(id)sender
{
    HMGHomage *homageCore = [HMGHomage sharedHomage];
    self.userRemakes = homageCore.myRemakes;
    [self.userRemakesCV reloadData];
}

-(void)displayViewBounds:(UIView *)view
{
    CGRect frame = view.bounds;
    CGFloat originX = frame.origin.x;
    CGFloat originY = frame.origin.y;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    NSLog(@"view bounds of cell are: origin:(%f,%f) height: %f width: %f" , originX,originY,height,width);
    
}


@end
