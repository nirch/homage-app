//
//  HMGMePlayerView.h
//  HomageApp
//
//  Created by Yoav Caspin on 1/5/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMGResizeableView : UIView

- (void) collapse;
- (void) expand;
- (void) Position:(NSString *)command;

@property (nonatomic, assign) CGRect expandedFrame;
@property (nonatomic, assign) CGRect collapsedFrame;

@end
