//
//  CDFirstBlog.h
//  chiefDelphi
//
//  Created by George on 12/28/2013.
//  Copyright (c) 2013 George. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDFranksViewController.h"

@interface CDFirstBlog : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *blogScrollView;
@property (strong, nonatomic) IBOutlet UIViewController *franksPosts;
@property (strong, nonatomic) IBOutlet UIImageView *frankPicIView;


@property (nonatomic, retain) UINavigationController *superNavController;

-(void)populateToolbar;
-(void)frankTapped;
@end
