//
//  CDRegionalViewController.m
//  Chief Delphi
//
//  Created by George on 1/24/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import "CDRegionalViewController.h"
#import "CDHubViewController.h"
#import "CDFirstBlog.h"
#import "CDRankingsViewController.h"
#import "CDTeamViewController.h"

@interface CDRegionalViewController (){
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    
    UISegmentedControl *segControl;
    
    NSString *page_scroll;
}
@end

@implementation CDRegionalViewController
@synthesize year, pageControl, scrollView, contextSwitcher, code, rankings, team_view;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        // Custom initialization
    }
    return self;
}


-(void) viewWillDisappear:(BOOL)animated {
    
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
    [super viewWillDisappear:animated];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateToolbar];
    
    NSLog(@"%@ %@", year, code);
    // Do any additional setup after loading the view from its nib.
    
    //Details
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    UIView *subview = [[UIView alloc] initWithFrame:frame];
    //[self.scrollView addSubview:subview];

    //rankings
    frame.origin.x = self.scrollView.frame.size.width * 1;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    
    //CREATE FILE
    
    NSError *error;
    
    // Create file manager
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    
    NSString *filePath = [documentsDirectory
                          stringByAppendingPathComponent:@"code.txt"];
    
    // Write to the file
    [code writeToFile:filePath atomically:YES
             encoding:NSUTF8StringEncoding error:&error];
    
    NSString *yearPath = [documentsDirectory
                          stringByAppendingPathComponent:@"year.txt"];
    
    // Write to the file
    [year writeToFile:yearPath atomically:YES
             encoding:NSUTF8StringEncoding error:&error];
    team_view= [[CDTeamViewController alloc] init];
    CGRect teamframe = team_view.view.frame;
    teamframe.size.height = scrollView.frame.size.height-40;
    teamframe.origin.x = 0;
    team_view.view.frame = teamframe;
    
    [scrollView addSubview:team_view.view];
    
    rankings = [[CDRankingsViewController alloc] init];
    CGRect rankframe = rankings.view.frame;
    rankframe.size.height = scrollView.frame.size.height-40;
    rankframe.origin.x = scrollView.frame.size.width;
    rankings.view.frame = rankframe;
    [rankings setCodeValue:code];
    
    
    //rankings.code = [[NSString alloc] initWithString:code];
    //[rankings setCode:[NSString stringWithString:code]];
    
    [scrollView addSubview:rankings.view];
    
        for (int i = 2; i < 4; i++) {
            frame.origin.x = self.scrollView.frame.size.width * i;
            frame.origin.y = 0;
            frame.size = self.scrollView.frame.size;
        
            subview = [[UIView alloc] initWithFrame:frame];
            [self.scrollView addSubview:subview];
        }
    
    
    
    
    [self.scrollView setContentOffset:CGPointMake(0,self.scrollView.contentOffset.y) animated:NO];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 4, self.scrollView.frame.size.height);
    
    self.scrollView.delegate = self;
    segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"Teams", @"Rankings", @"Schedule", @"Detail", nil]];
    segControl.frame = CGRectMake(0, 40, self.scrollView.frame.size.width, 50);
    segControl.selectedSegmentIndex = 0;
    [segControl addTarget:self
                   action:@selector(pickOne:)
         forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segControl];
    
   // [self.view addSubview:scrollView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollViews{
     if(scrollViews.contentOffset.x == 0){
         segControl.selectedSegmentIndex = 0;
    }
    if(scrollViews.contentOffset.x == scrollViews.contentSize.width/4){
        
        segControl.selectedSegmentIndex = 1;
    }
    if(scrollViews.contentOffset.x == (scrollViews.contentSize.width/4)*2){
        segControl.selectedSegmentIndex = 2;
    }
    if(scrollViews.contentOffset.x == (scrollViews.contentSize.width/4)*3){
        segControl.selectedSegmentIndex = 3;
    }
}
-(void) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    page_scroll = [segControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    
    if([page_scroll isEqualToString:@"Teams"]){
        segControl.selectedSegmentIndex = 0;
        [self.scrollView scrollRectToVisible:CGRectMake(0,0, self.scrollView.frame.size.width,self.scrollView.frame.size.height)  animated: YES];
    }else if([page_scroll isEqualToString:@"Rankings"]){
        segControl.selectedSegmentIndex = 1;
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width,0, self.scrollView.frame.size.width,self.scrollView.frame.size.height)  animated: YES];
    }else if([page_scroll isEqualToString:@"Schedule"]){
        segControl.selectedSegmentIndex = 2;
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width*2,0, self.scrollView.frame.size.width,self.scrollView.frame.size.height)  animated: YES];
    }else{
        segControl.selectedSegmentIndex = 3;
        [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.frame.size.width*3,0, self.scrollView.frame.size.width,self.scrollView.frame.size.height)  animated: YES];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [super viewDidDisappear:animated];
    
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
    CDFirstBlog *firstBlog = [[CDFirstBlog alloc] init];
    //firstBlog.superNavController = self.navigationController;
    [self.navigationController pushViewController:firstBlog animated:NO];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
-(void)worldTapped{
    CDHubViewController *hub = [[CDHubViewController alloc] init];
    [self.navigationController pushViewController:hub animated:NO];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
-(void)homeTapped{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
-(void)regionalTapped{
    //CDCompetitionViewController *cdcvc = [[CDCompetitionViewController alloc] init];
    //firstBlog.superNavController = self.navigationController;
    //[self.navigationController pushViewController:cdcvc animated:NO];
    [[self navigationController] popViewControllerAnimated:YES];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}

@end
