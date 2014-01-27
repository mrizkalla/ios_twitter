//
//  ComposeVC.h
//  twitter
//
//  Created by Michael Rizkalla on 1/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComposeVCDelegate;

@interface ComposeVC : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) id<ComposeVCDelegate> delegate;
@property (nonatomic, strong) NSString* prependText;
@property (nonatomic, strong) NSString* in_reply_to_status_id;

@end

// 3. Definition of the delegate's interface
@protocol ComposeVCDelegate <NSObject>

- (void)ComposeVC:(ComposeVC*)viewController onSuccessfulTweet:(id)response;

@end