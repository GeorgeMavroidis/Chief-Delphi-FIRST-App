//
//  CDHubTwitterCell.h
//  Chief Delphi
//
//  Created by George on 1/8/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDHubTwitterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *twitterContent;
@property (weak, nonatomic) IBOutlet UIImageView *twitImage;
@property (weak, nonatomic) IBOutlet UILabel *twitHandle;
@property (weak, nonatomic) IBOutlet UILabel *twitTime;

@end
