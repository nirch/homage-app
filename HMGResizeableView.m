//
//  HMGMePlayerView.m
//  HomageApp
//
//  Created by Yoav Caspin on 1/5/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import "HMGResizeableView.h"

@implementation HMGResizeableView

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

-(void)Position:(NSString *)command
{
    if ([command isEqualToString:@"align"] && (CGRectEqualToRect(self.frame, self.collapsedFrame))) return;
    
    self.frame = self.collapsedFrame;
    for (UIView* view in self.superview.subviews) {
        if (CGRectGetMinY(view.frame) > CGRectGetMaxY(self.frame))
        {
            CGPoint selfFrameOrigin = self.frame.origin;
            CGSize selfFrameSize = self.frame.size;
            CGFloat selforiginX = selfFrameOrigin.x;
            CGFloat selforiginY = selfFrameOrigin.y;
            CGFloat selfheight = selfFrameSize.height;
            CGFloat selfwidth = selfFrameSize.width;
            
            CGPoint viewFrameOrigin = view.frame.origin;
            CGSize viewFrameSize = view.frame.size;
            CGFloat vieworiginX = viewFrameOrigin.x;
            CGFloat vieworiginY = viewFrameOrigin.y;
            CGFloat viewheight = viewFrameSize.height;
            CGFloat viewwidth = viewFrameSize.width;
            
            CGFloat viewMinY = CGRectGetMinY(view.frame);
            CGFloat selfMaxY = CGRectGetMaxY(self.frame);
            
            NSLog(@"self.frame geos: %f,%f,%f,%f. max Y of self: %f", selforiginX , selforiginY , selfwidth , selfheight , selfMaxY);
            NSLog(@"view.frame geos: %f,%f,%f,%f. min Y of view: %f", vieworiginX , vieworiginY , viewwidth , viewheight,  viewMinY);
        
            view.frame = [self raiseFrame:view.frame withTag: view.tag];
            
            viewFrameOrigin = view.frame.origin;
            viewFrameSize = view.frame.size;
            vieworiginX = viewFrameOrigin.x;
            vieworiginY = viewFrameOrigin.y;
            viewheight = viewFrameSize.height;
            viewwidth = viewFrameSize.width;
            viewMinY = CGRectGetMinY(view.frame);
            
            NSLog(@"view.frame after raise geos after raise: %f,%f,%f,%f. min Y of view: %f", vieworiginX , vieworiginY , viewwidth , viewheight,  viewMinY);
        }
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
