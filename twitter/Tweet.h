//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *screenName;
@property (nonatomic, strong, readonly) NSString *timeSince;
@property (nonatomic, strong, readonly) NSString *time;
@property (nonatomic, strong, readonly) NSString *tweetId;
@property (nonatomic, strong, readonly) NSString *profileUrl;
@property (nonatomic, strong, readonly) NSString *retweetedName;
@property (nonatomic, strong, readonly) NSString *retweetedText;
@property (nonatomic, strong, readonly) NSString *retweetedScreenName;
@property (nonatomic, strong, readonly) NSString *retweetedProfileUrl;
@property (nonatomic, strong, readonly) NSString *retweetedId;
@property (nonatomic, strong, readonly) NSString *favoriteCount;
@property (nonatomic, strong, readonly) NSString *retweetCount;


+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
