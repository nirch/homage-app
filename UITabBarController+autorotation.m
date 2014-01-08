//
//  UITabBarController+autorotation.m
//  HomageApp
//
//  Created by Yoav Caspin on 1/8/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import "UITabBarController+autorotation.h"

@implementation UITabBarController (autorotation)

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
