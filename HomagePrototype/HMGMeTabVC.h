//
//  HMGMeTabVC.h
//  HomageApp
//
//  Created by Yoav Caspin on 1/5/14.
//  Copyright (c) 2014 Homage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGLog.h"
#import "HMGUserRemakeCVCell.h"
#import "HMGHomage.h"
#import "HMGShareViewController.h"

#if USES_IASK_STATIC_LIBRARY
#import "InAppSettingsKit/IASKAppSettingsViewController.h"
#else
#import "IASKAppSettingsViewController.h"
#endif


@interface HMGMeTabVC : UIViewController <IASKSettingsDelegate, UITextViewDelegate> {
    IASKAppSettingsViewController *appSettingsViewController;
}

@end
