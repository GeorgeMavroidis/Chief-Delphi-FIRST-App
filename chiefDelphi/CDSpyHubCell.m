//
//  CDSpyHubCell.m
//  chiefDelphi
//
//  Created by George on 11/7/2013.
//  Copyright (c) 2013 George. All rights reserved.
//

#import "CDSpyHubCell.h"

@implementation CDSpyHubCell
@synthesize titleText, timeText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
