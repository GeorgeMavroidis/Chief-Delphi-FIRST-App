//
//  CDFirstBlog.m
//  chiefDelphi
//
//  Created by George on 12/28/2013.
//  Copyright (c) 2013 George. All rights reserved.
//

#import "CDFirstBlog.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "CDSpyTableView.h"
#import "CDFranksViewController.h"
#import "CDHubViewController.h"
#import "CDCompetitionViewController.h"

@interface CDFirstBlog ()

@end

@implementation CDFirstBlog
@synthesize blogScrollView, frankPicIView, franksPosts, superNavController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Maintenance
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.navigationController.toolbarHidden = YES;
    [self populateToolbar];
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.hidesBackButton = YES;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    for (int i = 0; i < 3; i++) {
        CGRect frame;
        frame.origin.x = blogScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = blogScrollView.frame.size;
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        [blogScrollView addSubview:subview];
    }
    frankPicIView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 150)];
    NSURL *franksImage = [[NSURL alloc] initWithString:@"http://www.georgemavroidis.com/cd/frank_4.png"];
    [frankPicIView setImageWithURL:franksImage];
    [blogScrollView addSubview:frankPicIView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    blogScrollView.contentSize = CGSizeMake(blogScrollView.frame.size.width * 3, blogScrollView.frame.size.height);
    franksPosts = [[CDFranksViewController alloc] init];
    //franksPosts.superNavController = self.superNavController;
    self.superNavController = self.navigationController;
    CGRect franksframe = franksPosts.view.frame;
    franksframe.origin.y = 155;
    franksPosts.view.frame = franksframe;
    [blogScrollView addSubview:franksPosts.view];
    
    UISwipeGestureRecognizer *swipeRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(frankTapped)];
    swipeRecognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
    [blogScrollView addGestureRecognizer:swipeRecognizerUp];
    
    
    UISwipeGestureRecognizer *swipeRecognizerD = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(frankTappedD)];
    swipeRecognizerD.direction = UISwipeGestureRecognizerDirectionDown;
    [franksPosts.view addGestureRecognizer:swipeRecognizerD];
 
}
-(void)frankTapped{
   /* NSLog(@"up");
    CGRect frame = franksPosts.view.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         franksPosts.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         // whatever you need to do when animations are complete
                     }];
    frame = frankPicIView.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         frankPicIView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         // whatever you need to do when animations are complete
                     }];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    [[self navigationController] setToolbarHidden:NO animated:YES];
    [self populateToolbar];
     */
}

-(void)frankTappedD{
   /* NSLog(@"Down");
    CGRect frame = franksPosts.view.frame;
    frame.origin.y = 200;
    
    [UIView animateWithDuration:0.7
                     animations:^{
                         franksPosts.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         // whatever you need to do when animations are complete
                     }];
    
    frame = frankPicIView.frame;
    frame.origin.y = 50;
    
    [UIView animateWithDuration:0.7
                     animations:^{
                         frankPicIView.frame = frame;
                         [[self navigationController] setNavigationBarHidden:NO animated:YES];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [[self navigationController] setToolbarHidden:YES animated:YES];
    */
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)populateToolbar{
    UIBarButtonItem *flexiableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //Load the image
    UIImage *buttonImage = [UIImage imageNamed:@"home.png"];
    //create the button and assign the image
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    //sets the frame of the button to the size of the image
    button.frame = CGRectMake(0, 0, 40, 40);
    [button addTarget:self
               action:@selector(homeTapped)
     forControlEvents:UIControlEventTouchUpInside];
    //creates a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //Load the image
    UIImage *rssImage = [UIImage imageNamed:@"rssb.png"];
    //create the button and assign the image
    UIButton *rssButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rssButton setImage:rssImage forState:UIControlStateNormal];
    //sets the frame of the button to the size of the image
    rssButton.frame = CGRectMake(0, 0, 30, 30);
    //creates a UIBarButtonItem with the button as a custom view
    [rssButton addTarget:self
                  action:@selector(launchBlog)
        forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rssBaritem = [[UIBarButtonItem alloc] initWithCustomView:rssButton];
    
    
    //Load the image
    UIImage *worldImage = [UIImage imageNamed:@"world.png"];
    //create the button and assign the image
    UIButton *worldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [worldButton setImage:worldImage forState:UIControlStateNormal];
    //sets the frame of the button to the size of the image
    worldButton.frame = CGRectMake(0, 0, 40, 40);
    //creates a UIBarButtonItem with the button as a custom view
    [worldButton addTarget:self
                    action:@selector(worldTapped)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *worldBarItem = [[UIBarButtonItem alloc] initWithCustomView:worldButton];
    
    //Load the image
    UIImage *regionalImage = [UIImage imageNamed:@"regional.png"];
    //create the button and assign the image
    UIButton *regionalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [regionalButton setImage:regionalImage forState:UIControlStateNormal];
    //sets the frame of the button to the size of the image
    regionalButton.frame = CGRectMake(0, 0, 40, 40);
    //creates a UIBarButtonItem with the button as a custom view
    [regionalButton addTarget:self
                       action:@selector(regionalTapped)
             forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *regionalBarItem = [[UIBarButtonItem alloc] initWithCustomView:regionalButton];
    
    NSArray *toolbarItems = [NSArray arrayWithObjects:customBarItem, flexiableItem,regionalBarItem, flexiableItem, worldBarItem, flexiableItem, rssBaritem, nil];
    
    self.toolbarItems = toolbarItems;
}
-(void)launchBlog
{
    //CDFirstBlog *firstBlog = [[CDFirstBlog alloc] init];
    //firstBlog.superNavController = self.navigationController;
    //[self.navigationController pushViewController:firstBlog animated:NO];
}
-(void)worldTapped{
    CDHubViewController *hub = [[CDHubViewController alloc] init];
   // [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController pushViewController:hub animated:NO];
}
-(void)homeTapped{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)regionalTapped{
    CDCompetitionViewController *cdcvc = [[CDCompetitionViewController alloc] init];
    //firstBlog.superNavController = self.navigationController;
    [self.navigationController pushViewController:cdcvc animated:NO];
    
}

@end
