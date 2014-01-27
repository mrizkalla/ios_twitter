//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"
@interface Tweet ()
- (NSString *)dateDiff:(NSString *)origDate;
@end

@implementation Tweet

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)name {
    return [self.data valueOrNilForKeyPath:@"user.name"];
}

- (NSString *)screenName {
    return [self.data valueOrNilForKeyPath:@"user.screen_name"];
}

- (NSString *)time {
    return [self dateDiff:[self.data valueOrNilForKeyPath:@"created_at"]];
}

- (NSString *)profileUrl {
    return [self.data valueOrNilForKeyPath:@"user.profile_image_url"];
}

- (NSString *)retweetedName {
    return [self.data valueOrNilForKeyPath:@"retweeted_status.user.name"];
}

- (NSString *)retweetedText {
    return [self.data valueOrNilForKeyPath:@"retweeted_status.text"];
}

- (NSString *)retweetedScreenName {
    return [self.data valueOrNilForKeyPath:@"retweeted_status.user.screen_name"];
}

- (NSString *)retweetedProfileUrl {
    return [self.data valueOrNilForKeyPath:@"retweeted_status.user.profile_image_url"];
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

-(NSString *)dateDiff:(NSString *)origDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"EEE MMM dd HH:mm:ss zzzz yyyy"];
    NSDate *convertedDate = [df dateFromString:origDate];
    double ti = [convertedDate timeIntervalSinceNow];
    ti = ti * -1;
    if(ti < 1) {
    	return @"n/a";
    } else 	if (ti < 60) {
    	return @"now";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
    	return [NSString stringWithFormat:@"%dm", diff];
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
    	return[NSString stringWithFormat:@"%dh", diff];
    } else if (ti < 2629743) {
    	int diff = round(ti / 60 / 60 / 24);
    	return[NSString stringWithFormat:@"%dd", diff];
    } else if (ti < 31536000) {
        int diff = round(ti / 60 / 60 / 24 / 30);
        return[NSString stringWithFormat:@"%dm", diff];
    } else {
        int diff = round(ti / 60 / 60 / 24 / 365);
        return[NSString stringWithFormat:@"%dy", diff];
    }
}
@end
