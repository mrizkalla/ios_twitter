//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"
#import "RetweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeVC.h"
#import "TweetVC.h"

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onSignOutButton;
- (void)onComposeButton;
- (void)reload;
- (void)populateTweetCell:(TweetCell*)cell withTweet:(Tweet*)tweet;
- (void)populateRetweetCell:(RetweetCell*)cell withTweet:(Tweet*)tweet;
@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"";

        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register the custom cell NIB
    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"TweetCell"];
    UINib *customNib2 = [UINib nibWithNibName:@"RetweetCell" bundle:nil];
    [self.tableView registerNib:customNib2 forCellReuseIdentifier:@"RetweetCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onComposeButton)];
    
    UIImage *image = [UIImage imageNamed:@"twitter_icon"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0, 0, 20, 20);
    
    self.navigationItem.titleView = imageView;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TweetCellIdentifier = @"TweetCell";
    static NSString *RetweetCellIdentifier = @"RetweetCell";

    Tweet *tweet = self.tweets[indexPath.row];
    
    if (tweet.retweetedName == nil) {
        TweetCell *cell = (TweetCell*)[tableView dequeueReusableCellWithIdentifier:TweetCellIdentifier];
        [self populateTweetCell:cell withTweet:tweet];
        return cell;
    } else {
        RetweetCell *cell = [tableView dequeueReusableCellWithIdentifier:RetweetCellIdentifier];
        [self populateRetweetCell:cell withTweet:tweet];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *theText=[[_loadedNames objectAtIndex: indexPath.row] name];
    //CGSize labelSize = [theText sizeWithFont:[UIFont fontWithName: @"FontA" size: 15.0f] constrainedToSize:kLabelFrameMaxSize];
    //return kHeightWithoutLabel+labelSize.height;
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    // First calculate the height of the action row if one exists
    CGFloat topSectionHeight;
    if (tweet.retweetedName != nil) {
        topSectionHeight = 58;
    } else {
        topSectionHeight = 30;
    }
    
    
    // Now calculate size of tweet text
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    // NSString class method: boundingRectWithSize:options:attributes:context is
    // available only on ios7.0 sdk.
    NSString *tweetText = tweet.retweetedText == nil ? tweet.text : tweet.retweetedText;
    CGRect rect = [tweetText boundingRectWithSize:CGSizeMake(231, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:attributes
                                            context:nil];
    
    return topSectionHeight + (rect.size.height > 40 ? rect.size.height : 40);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetVC *vc = [[TweetVC alloc] init];
    vc.tweet = self.tweets[indexPath.row];;
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - Table view delegate



- (void)ComposeVC:(ComposeVC *)viewController onSuccessfulTweet:(id)response {
    NSLog(@"In delegate: %@", response);
    Tweet *tweet = [[Tweet alloc] initWithDictionary:(NSDictionary*)response];
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    
    [viewController dismissViewControllerAnimated:true completion:nil];

}


#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

- (void)onComposeButton {
    // Push a modal view controller for compose view
    // Create the root view controller for the navigation controller
    // The new view controller configures a Cancel and Done button for the
    // navigation bar.
    ComposeVC *addController = [[ComposeVC alloc] init];
    addController.delegate = self;
    
    
    // Create the navigation controller and present it.
    //UINavigationController *navigationController = [[UINavigationController alloc]
    //                                                initWithRootViewController:addController];
    [self presentViewController:addController animated:YES completion: nil];
    
}

- (void)populateTweetCell:(TweetCell *)cell withTweet:(Tweet *)tweet {
    cell.tweetTextView.text = tweet.text;
    cell.tweetTextView.textContainer.lineFragmentPadding = 0;
    cell.tweetTextView.textContainerInset = UIEdgeInsetsZero;
    cell.nameLabel.text = tweet.name;
    cell.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
    cell.timeLabel.text = tweet.time;
    
    // Set the profile image with rounded corners
    [cell.avatarImage setImageWithURL:[NSURL URLWithString:tweet.profileUrl]];
    cell.avatarImage.layer.cornerRadius = 5.0;
    cell.avatarImage.layer.masksToBounds = YES;

}

- (void)populateRetweetCell:(RetweetCell *)cell withTweet:(Tweet *)tweet {
    cell.tweetTextView.text = tweet.retweetedText;
    cell.tweetTextView.textContainer.lineFragmentPadding = 0;
    cell.tweetTextView.textContainerInset = UIEdgeInsetsZero;
    cell.nameLabel.text = tweet.retweetedName;
    cell.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.retweetedScreenName];
    cell.timeLabel.text = tweet.time;
    cell.actionLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.name];

    
    // Set the profile image with rounded corners
    [cell.avatarImage setImageWithURL:[NSURL URLWithString:tweet.retweetedProfileUrl]];
    cell.avatarImage.layer.cornerRadius = 5.0;
    cell.avatarImage.layer.masksToBounds = YES;
}

@end
