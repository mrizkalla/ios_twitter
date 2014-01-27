//
//  ComposeVC.m
//  twitter
//
//  Created by Michael Rizkalla on 1/26/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ComposeVC.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TimelineVC.h"

@interface ComposeVC ()
@property (weak, nonatomic) IBOutlet UILabel *charCounterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

- (IBAction)onTweetButton:(id)sender;
- (IBAction)onCancelButton:(id)sender;

@end

@implementation ComposeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tweetTextView becomeFirstResponder];
    User *currentUser = [User currentUser];
    
    // Set the name and screen name
    self.nameLabel.text = currentUser.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", currentUser.screenName];

    // Set the profile image with rounded corners
    [self.profileImageView setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    self.profileImageView.layer.cornerRadius = 5.0;
    self.profileImageView.layer.masksToBounds = YES;
    
    // Set the delegate
    self.tweetTextView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTweetButton:(id)sender {
    NSLog (@"On Tweet called");

    [[TwitterClient instance] tweetThis:self.tweetTextView.text success:^(AFHTTPRequestOperation *operation, id response) {
        
        NSLog(@"Retweet response%@", response);
        
        if ([self.delegate respondsToSelector:@selector(ComposeVC:onSuccessfulTweet:)]) {
            [self.delegate ComposeVC:self onSuccessfulTweet:response];
        }
 
 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request failed !");
        
        NSLog(@"%@",[error localizedDescription]);
        
        // Put up some message to the user telling him/her the tweet failed
        
    }];
 


}

- (IBAction)onCancelButton:(id)sender {
        [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 140;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.charCounterLabel.text = [NSString stringWithFormat:@"%d",140 - textView.text.length];
}


@end
