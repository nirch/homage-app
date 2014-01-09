//
//  HMGUserRemakeCVCell.h
//  HomageApp
//
//  Created by Yoav Caspin on 1/5/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMGUserRemakeCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (strong, nonatomic) IBOutlet UIImageView *moreView;
@property (strong, nonatomic) IBOutlet UIView *expandedView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIButton *remakeButton;

@end
