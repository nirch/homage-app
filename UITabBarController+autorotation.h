//
//  UITabBarController+autorotation.h
//  HomageApp
//
//  Created by Yoav Caspin on 1/8/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (autorotation)

-(BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;

@end
