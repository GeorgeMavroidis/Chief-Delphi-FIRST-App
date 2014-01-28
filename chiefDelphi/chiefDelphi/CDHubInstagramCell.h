//
//  CDHubInstagramCell.h
//  Chief Delphi
//
//  Created by George on 1/7/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDHubInstagramCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *instagramImage;
@property (weak, nonatomic) IBOutlet UILabel *instaLikeCount;
@property (weak, nonatomic) IBOutlet UITextView *instaHandle;
@property (weak, nonatomic) IBOutlet UITextView *instaText;
@property (weak, nonatomic) IBOutlet UIImageView *instaHeart;

@end
