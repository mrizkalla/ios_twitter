//
//  TweetVC.m
//  twitter
//
//  Created by Michael Rizkalla on 1/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetVC.h"
#import "ComposeVC.h"
#import "UIImageView+AFNetworking.h"

@interface TweetVC ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screeNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberRetweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFavoritesLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetTextViewHeightConstraint;
- (void)onComposeButton;

@end

const int TWEETVIEWWIDTH = 280;

@implementation TweetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton)];
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.tweet.profileUrl]];
    self.profileImageView.layer.cornerRadius = 5.0;
    self.profileImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = self.tweet.retweetedName == nil ? self.tweet.name : self.tweet.retweetedName;
    self.screeNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.retweetedScreenName == nil ? self.tweet.screenName : self.tweet.retweetedScreenName];
    self.tweetTextView.text = self.tweet.retweetedText == nil ? self.tweet.text : self.tweet.retweetedText;
    [self.tweetTextView sizeToFit];
    self.tweetTextViewHeightConstraint.constant = self.tweetTextView.frame.size.height;

    /*
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    CGRect rect = [self.tweetTextView.text boundingRectWithSize:CGSizeMake(TWEETVIEWWIDTH, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:attributes
                                                        context:nil];
    CGSize sizeThatShouldFitTheContent = [self.tweetTextView sizeThatFits:self.tweetTextView.frame.size];
    heightConstraint.constant = sizeThatShouldFitTheContent.height;
    */
    self.timeLabel.text = self.tweet.time;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onComposeButton {

    ComposeVC *vc = [[ComposeVC alloc] init];
    vc.delegate = self;
    
    
    // Create the navigation controller and present it.
    //UINavigationController *navigationController = [[UINavigationController alloc]
    //                                                initWithRootViewController:addController];
    [self presentViewController:vc animated:YES completion: nil];
}

- (void)ComposeVC:(ComposeVC *)viewController onSuccessfulTweet:(id)response {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
