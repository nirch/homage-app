//
//  HMGsegmentCVCell.h
//  HomagePrototype
//
//  Created by Yoav Caspin on 9/22/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMGsegmentCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *playOrigSegmentButton;
@property (weak, nonatomic) IBOutlet UIImageView *origSegmentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userSegmentImageView;
@property (weak, nonatomic) IBOutlet UIButton *userSegmentRecordButton;
@property (weak, nonatomic) IBOutlet UIButton *userSegmentPlayButton;
@property (weak, nonatomic) IBOutlet UITextView *segmentDescription;
@property (weak, nonatomic) IBOutlet UILabel *segmentName;
@property (weak, nonatomic) IBOutlet UILabel *segmentDuration;

@property (weak,nonatomic) IBOutlet UICollectionView *singleSegmentTakesCView;

@property (weak, nonatomic) NSString *segmentType;
@property (strong, nonatomic) NSURL *origSegmentVideo;

@end
