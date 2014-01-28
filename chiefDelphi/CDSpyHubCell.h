//
//  CDSpyHubCell.h
//  chiefDelphi
//
//  Created by George on 11/7/2013.
//  Copyright (c) 2013 George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDSpyHubCell : UITableViewCell 
@property (weak, nonatomic) IBOutlet UITextView *titleText;
@property (weak, nonatomic) IBOutlet UITextView *timeText;
@property (weak, nonatomic) IBOutlet UITextView *previewText;
@property (weak, nonatomic) IBOutlet UITextView *handle;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;


@end
