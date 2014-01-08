//
//  HMGMePlayerView.h
//  HomageApp
//
//  Created by Yoav Caspin on 1/5/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMGMePlayerView : UIView

- (void) collapse;
- (void) expand;
- (void) startPosition;

@property (nonatomic, assign) CGRect expandedFrame;
@property (nonatomic, assign) CGRect collapsedFrame;

@end
