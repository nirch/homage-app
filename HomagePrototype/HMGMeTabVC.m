//
//  HMGMeTabVC.m
//  HomageApp
//
//  Created by Yoav Caspin on 1/5/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import "HMGMeTabVC.h"

@interface HMGMeTabVC () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *moviePlaceHolder;
@property (weak, nonatomic) IBOutlet UIView *userImagePlaceHolder;
@property (weak, nonatomic) IBOutlet UICollectionView *userRemakesCV;
@property (strong,nonatomic) NSArray *userRemakes;
@property (strong,nonatomic) UIImage *userImage;
@property (strong,nonatomic) NSString *userName;

@end

@implementation HMGMeTabVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

/*- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
 {
 return 1;
 }*/ //if not implemented, this value is set on default to 1

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
    HMGRemakeVideo *remake = self.userRemakes[indexPath.item];
    [self updateCell:cell withRemake:remake];
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell withRemake:(HMGRemakeVideo *)remake
{
    HMGLogDebug(@"%s started" , __PRETTY_FUNCTION__);
    
    if ([cell isKindOfClass: [HMGRemakeCVCell class]]) {
        HMGRemakeCVCell *remakeCell = (HMGRemakeCVCell *) cell;
        remakeCell.imageView.image = [UIImage imageWithContentsOfFile:remake.thumbnailPath];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"pb_play_icon" ofType:@"png"];
        UIImage *playButtonImage = [UIImage imageWithContentsOfFile:imagePath];
        remakeCell.pbImageView.image = playButtonImage;
    }
    
    HMGLogDebug(@"%s finished" , __PRETTY_FUNCTION__);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
