//
//  HMGUser.h
//  HomageApp
//
//  Created by Tomer Harry on 12/31/13.
//  Copyright (c) 2013 Homage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMGUser : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *email;
@property (nonatomic) BOOL firstUse;
@property (nonatomic) BOOL publicUser;
@property (strong, nonatomic) UIImage *image;

@end
