//
//  TweetVC.h
//  twitter
//
//  Created by Michael Rizkalla on 1/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeVC.h"

@interface TweetVC : UIViewController <ComposeVCDelegate>

@property (nonatomic, strong) Tweet *tweet;

@end
