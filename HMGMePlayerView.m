//
//  HMGMePlayerView.m
//  HomageApp
//
//  Created by Yoav Caspin on 1/5/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import "HMGMePlayerView.h"

@implementation HMGMePlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialiseFrames:frame];
    }
    return self;
}

//initialising from XIB/Storyboard
- (void)awakeFromNib {
    [self initialiseFrames:self.frame];
}

- (void)initialiseFrames:(CGRect)frame {
    self.expandedFrame = frame;
    frame.size.height = 0;
    self.collapsedFrame = frame;
    self.frame = self.collapsedFrame;
}

- (CGRect)lowerFrame:(CGRect)frame withTag:(NSInteger)tag
{
    CGFloat height = CGRectGetHeight(self.expandedFrame);
    frame.origin.y += height;
    if (tag == 70) frame.size.height -= height;
    return frame;
}

- (CGRect)raiseFrame:(CGRect)frame withTag:(NSInteger)tag {
    CGFloat height = CGRectGetHeight(self.expandedFrame);
    frame.origin.y -= height;
    if (tag == 70) frame.size.height += height;
    return frame;
}

-(void)startPosition
{
    self.frame = self.collapsedFrame;
    for (UIView* view in self.superview.subviews) {
        if (CGRectGetMinY(view.frame) > CGRectGetMaxY(self.frame))
            view.frame = [self raiseFrame:view.frame withTag: view.tag];
    }
    
    for (UIView* view in self.subviews) {
        [view setHidden:YES];
    }
}

- (void) collapse
{
    if (CGRectEqualToRect(self.frame, self.collapsedFrame)) return;
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView* view in self.superview.subviews) {
            if (CGRectGetMinY(view.frame) > CGRectGetMaxY(self.frame))
                view.frame = [self raiseFrame:view.frame withTag: view.tag];
        }
        
        for (UIView* view in self.subviews) {
            [view setHidden:YES];
        }
        self.frame = self.collapsedFrame;
    }];
    
}

- (void) expand {
    if (CGRectEqualToRect(self.frame, self.expandedFrame)) return;
    [UIView animateWithDuration:0.5 animations:^{
        for (UIView* view in self.superview.subviews) {
            if (CGRectGetMinY(view.frame) > CGRectGetMaxY(self.frame))
                view.frame = [self lowerFrame:view.frame withTag: view.tag];
        }
        for (UIView* view in self.subviews) {
            [view setHidden:NO];
        }
        self.frame = self.expandedFrame;
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
