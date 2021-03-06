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
#import "TwitterClient.h"

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

- (IBAction)onReplyButton:(id)sender;
- (IBAction)onFavoriteButton:(id)sender;

@property BOOL mIsFavorited;

@end


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
    NSLog(@"%@", self.tweet.favoriteCount);
    self.numberFavoritesLabel.text = [NSString stringWithFormat:@"%@", self.tweet.favoriteCount];
    self.numberRetweetsLabel.text = [NSString stringWithFormat:@"%@", self.tweet.retweetCount];    
    
    NSString *t = self.tweet.time;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"EEE MMM dd HH:mm:ss zzzz yyyy"];
    NSDate *convertedDate = [df dateFromString:t];
    [df setDateFormat:@"MM/dd/yy, HH:mm a"];
    self.timeLabel.text = [df stringFromDate:convertedDate];
    
    // TODO:
    // A good thing to do here is to set the favorite and retweeted buttons to be in the "on"
    // state based on the favorited and retweeted flag in the tweet model.
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

- (IBAction)onReplyButton:(id)sender {
    ComposeVC *vc = [[ComposeVC alloc] init];
    vc.delegate = self;
    vc.prependText = self.screeNameLabel.text;
    vc.in_reply_to_status_id = self.tweet.retweetedId == nil ? self.tweet.retweetedId : self.tweet.tweetId;
    [self presentViewController:vc animated:YES completion: nil];
}

- (IBAction)onFavoriteButton:(id)sender {
    // TODO
    // Check the model first to determine if the user has already favorited this tweet.  If so then unfavorite the tweet
    
    [[TwitterClient instance] favorite:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Retweet response%@", response);
        
        // Increase the favorite count
        int a = [self.numberFavoritesLabel.text integerValue];
        self.numberFavoritesLabel.text = [NSString stringWithFormat:@"%d", a+1];
        
        // TODO
        // Set the status of the image button to "on" by chaning the background image
        // Change the model on this tweet to indicate it has been favorited
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request failed !");
        
        NSLog(@"%@",[error localizedDescription]);
        
        // Put up some message to the user telling him/her the favorite failed
        
    }];
    
    
}

- (void)ComposeVC:(ComposeVC *)viewController onSuccessfulTweet:(id)response {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
