//
//  CDSpyTableView.m
//  chiefDelphi
//
//  Created by George on 11/7/2013.
//  Copyright (c) 2013 George. All rights reserved.
//

#import "CDSpyTableView.h"
#import "CDSpyHubCell.h"
#import "CDForumViewController.h"
#import "UIImageView+WebCache.h"
#import "CDFirstBlog.h"
#import "CDHubViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CDCompetitionViewController.h"

@implementation CDSpyTableView{
    NSArray *tableData;
    
    NSXMLParser *parser;
    
    NSMutableArray *universalFeeds;
    
    NSMutableDictionary *items;
   
    UIRefreshControl *refreshControl;
    
    UITableView *mainTableView;
    
    
    NSMutableString *firstID;
    NSMutableString *what;
    NSMutableString *when;
    NSMutableString *title;
    NSMutableString *preview;
    NSMutableString *poster;
    NSMutableString *threadid;
    NSMutableString *postid;
    NSMutableString *lastpost;
    NSMutableString *userid;
    NSMutableString *profileURLFast;
    NSMutableString *forumid;
    NSMutableString *forumname;
    NSMutableString *views;
    NSMutableString *replies;
    int count;
    NSUInteger height;
    NSString *element;
    
    
}
@synthesize lastContentOffset;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    //[[self navigationItem] setTitle:@"CD Spy"];
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, 100, 100)];
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView reloadData];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [mainTableView addSubview:refreshControl];
    count = 0;
    self.view = mainTableView;
    
    [self runParsers];
    
    UIPanGestureRecognizer *showExtrasSwipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipe:)];
    //showExtrasSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    showExtrasSwipe.delegate = self;
    [mainTableView addGestureRecognizer:showExtrasSwipe];
    
    
   [self populateToolbar];
    
    
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
    [self.navigationController  pushViewController:firstBlog animated:NO];
}
-(void)worldTapped{
    CDHubViewController *hub = [[CDHubViewController alloc] init];
    //[[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self.navigationController pushViewController:hub animated:NO];
}
-(void)regionalTapped{
    CDCompetitionViewController *cdcvc = [[CDCompetitionViewController alloc] init];
    //firstBlog.superNavController = self.navigationController;
    [self.navigationController pushViewController:cdcvc animated:NO];
    
}
-(void)homeTapped{
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidDisappear:YES];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
    //self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}

- (void)cellSwipe:(UIPanGestureRecognizer *)gesture
{
    /*
    CGPoint location = [gesture locationInView:mainTableView];
    NSIndexPath *swipedIndexPath = [mainTableView indexPathForRowAtPoint:location];
    UITableViewCell *swipedCell  = [mainTableView cellForRowAtIndexPath:swipedIndexPath];
    
    CGPoint translation = [gesture translationInView:self.view];
    CGPoint cellPosition = location;
    
    cellPosition.x += translation.x;
    cellPosition.y = swipedCell.center.y;
    [swipedCell setFrame:CGRectMake(location.x+translation.x - swipedCell.bounds.size.width ,
                                    swipedCell.frame.origin.y,
                                    swipedCell.bounds.size.width,
                                    swipedCell.bounds.size.height)];
    [gesture setTranslation:CGPointZero inView:mainTableView];
    
    //Logic for when gesture ended
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"Done");
        if(swipedCell.frame.origin.x < swipedCell.bounds.size.width/2){
            [UIView animateWithDuration:0.5 animations:^{
                swipedCell.frame = CGRectMake(0,
                                              swipedCell.frame.origin.y,
                                              swipedCell.bounds.size.width,
                                              swipedCell.bounds.size.height);
            }];
            
        }
        if(mainTableView.frame.origin.x < mainTableView.bounds.size.width/2){
            [UIView animateWithDuration:0.5 animations:^{
                mainTableView.frame = CGRectMake(0,
                                                 0,
                                                 mainTableView.bounds.size.width,
                                                 mainTableView.bounds.size.height);
            }];
        }
    }
    //Logic for where the full table pulls with the swiped cell
    if((swipedCell.frame.origin.x + swipedCell.frame.size.width) < swipedCell.bounds.size.width/3*2){
        [mainTableView setFrame: CGRectMake(mainTableView.frame.origin.x+ translation.x,
                                            mainTableView.frame.origin.y,
                                            mainTableView.bounds.size.width,
                                            mainTableView.bounds.size.height)];
    }
    */
    
}
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    CGPoint currentOffset = scrollView.contentOffset;
    if (currentOffset.y > self.lastContentOffset.y && currentOffset.y > 40){
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        // Downward
    }else if(currentOffset.y == self.lastContentOffset.y){
        //[[self navigationController] setNavigationBarHidden:YES];
        NSLog(@"test");
    }else{
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        // Upward
    }
    self.lastContentOffset = currentOffset;
     */
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //CDForumViewController *new = [[CDForumViewController alloc] init];
    
    //[self.navigationController pushViewController:new animated:YES];
    //Find length of thread
    
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //show post to just show post
    NSString *threadString = [@"http://www.chiefdelphi.com/forums/showthread.php?p=" stringByAppendingString:[[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"postid"]];
    threadString = [threadString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    threadString = [threadString stringByAppendingString:@"#post"];
    threadString = [threadString stringByAppendingString:[[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"postid"]];
    threadString = [threadString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    NSURL *url = [NSURL URLWithString:threadString];//prints txt file
    NSString *webData= [NSString stringWithContentsOfURL:url];
    
    
        CGRect frame;
    frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size = scrollview.frame.size;
        UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: frame];
        
        [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:threadString]]];
        [uiWebView setScalesPageToFit:YES];
    
    UIViewController *webViewController = [[UIViewController alloc] init];
    [webViewController.view addSubview:uiWebView];
    [self.navigationController pushViewController:webViewController animated:YES];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.toolbarHidden = YES;
    
    
}
- (void)handleRefresh:(id)sender
{
   
    
    [self runParsers];
   // [self.tableView reloadData];
    [mainTableView reloadData];
    [refreshControl endRefreshing];
    
}
-(void)handleRefresher{
    
    [self runParsers];
    // [self.tableView reloadData];
    [mainTableView reloadData];
    
}
-(void)runParsers{
    universalFeeds = [[NSMutableArray alloc] init];
    NSURL *newsurl = [NSURL URLWithString:@"http://www.chiefdelphi.com/forums/cdspy.php?do=xml"];//
    
    
    // construct path within our documents directory
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *storePath = [applicationDocumentsDir stringByAppendingPathComponent:@"cdspy.xml"];
    NSString *storePath2 = [applicationDocumentsDir stringByAppendingPathComponent:@"cdspy2.xml"];
    
    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:storePath];
    if (myHandle == nil)
        NSLog(@"Failed to open file");
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:storePath];
    
    if(fileExists){
        
        NSData *originalData = [NSData dataWithContentsOfFile:storePath];  // Load XML data from web
        
        NSData *data = [NSData dataWithContentsOfURL:newsurl];  // Load XML data from web
        [data writeToFile:storePath atomically:YES];
        
       [originalData writeToFile:storePath2 atomically:TRUE];
        
        NSLog(@"done");
        
    }else{
        
        NSData *data = [NSData dataWithContentsOfURL:newsurl];  // Load XML data from web
        [data writeToFile:storePath atomically:TRUE];
    }
    [myHandle closeFile];
    // write to file atomically (using temp file)
    
    parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:storePath]];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    
   /* parser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:storePath2]];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];*/
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CDSpyHubCell *spyCell = (CDSpyHubCell *)[tableView dequeueReusableCellWithIdentifier:@"CDSpyHubCell"];
    if (spyCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CDSpyHubCell"owner:self options:nil];
        spyCell = (CDSpyHubCell *)[nib objectAtIndex:0];
        
    }
    
    spyCell.titleText.text = [[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"title"];
    
    spyCell.titleText.font = [UIFont fontWithName:@"Arial-BOLDMT" size:14];
    //spyCell.titleText.textAlignment = NSTextAlignmentCenter;
    
    spyCell.timeText.text = [[universalFeeds objectAtIndex:indexPath.row] objectForKey:@"when"];
    spyCell.timeText.font = [UIFont fontWithName:@"Arial" size:11];
    spyCell.timeText.textAlignment = NSTextAlignmentRight;
    [[spyCell timeText] setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    
    spyCell.previewText.text = [[universalFeeds objectAtIndex:indexPath.row] objectForKey:@"preview"];
    spyCell.previewText.font = [UIFont fontWithName:@"Arial" size:12];
    
    height = spyCell.previewText.text.length;
    //NSLog(@"%d %@", height, spyCell.previewText.text);
    //spyCell.previewText.textAlignment = NSTextAlignmentJustified;
    
    spyCell.handle.text = [[universalFeeds objectAtIndex:indexPath.row] objectForKey:@"poster"];
    spyCell.handle.font = [UIFont fontWithName:@"Arial" size:11];
    [[spyCell handle] setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    spyCell.handle.textAlignment = NSTextAlignmentLeft;
    
    //UISwipeGestureRecognizer *g = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasSwiped:)];
    //[spyCell addGestureRecognizer:g];
    
    UIView *backCol = [[UIView alloc] init];
    [backCol setBackgroundColor:[UIColor clearColor]];
    
    [spyCell setSelectedBackgroundView:backCol];
    
    NSString *profileURL = [@"http://www.chiefdelphi.com/forums/image.php?u=" stringByAppendingString:[[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"userid"]];
    profileURL = [profileURL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:profileURL];
     //NSLog(@"%d", [data length]);
    NSString *puf =[[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"puf"];
    //NSLog(@"%@", puf);
    if([puf  isEqual: @"0"]){
        [spyCell.profileImage setImageWithURL:@"none" placeholderImage:[UIImage imageNamed:@"placeholder-user-anon.png"]];
    }else{
        [spyCell.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder-user-anon.png"]];
    }
    
    /*
     
    if([data length] == 43){
        [spyCell.profileImage setImageWithURL:@"none" placeholderImage:[UIImage imageNamed:@"placeholder-user-anon.png"]];
    }else{
        [spyCell.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder-user-anon.png"]];
    }
     */
    
    //[spyCell.profileImage setImageWithURL:profURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return spyCell;
    
    
    /*
     NSMutableString *profString = [NSMutableString stringWithString: @"http://www.chiefdelphi.com/forums/image.php?u="];
     NSString *user = [[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"userid"];
     [profString appendString:user];
     NSURL *profURL = [NSURL URLWithString:profString];
     */
    
}
- (void)cellWasSwiped:(id)sender
{
    NSLog(@"Swiped");
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [tableData count];
    NSLog(@"%d", (int)[universalFeeds count]);
    return [universalFeeds count];
    //return [universalFeeds count];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return [self calculateRowHeighForIndexPath:indexPath];
    return 150;
    
}
- (CGFloat)calculateRowHeighForIndexPath:(NSIndexPath *)indexPath
{
    
    double row_height = 120.0 + [[[universalFeeds objectAtIndex:indexPath.row] objectForKey:@"when"] length];
    return row_height;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"event"]) {
        count++;
        items= [[NSMutableDictionary alloc] init];
        firstID = [[NSMutableString alloc] init];
        what = [[NSMutableString alloc] init];
        when = [[NSMutableString alloc] init];
        title = [[NSMutableString alloc] init];
        preview = [[NSMutableString alloc] init];
        poster = [[NSMutableString alloc] init];
        threadid = [[NSMutableString alloc] init];
        postid = [[NSMutableString alloc] init];
        lastpost = [[NSMutableString alloc] init];
        userid = [[NSMutableString alloc] init];
        forumid = [[NSMutableString alloc] init];
        forumname = [[NSMutableString alloc] init];
        views = [[NSMutableString alloc] init];
        replies = [[NSMutableString alloc] init];
        profileURLFast = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"event"]) {
        [items setObject:firstID forKey:@"id"];
        [items setObject:what forKey:@"what"];
        [items setObject:when forKey:@"when"];
        [items setObject:title forKey:@"title"];
        [items setObject:preview forKey:@"preview"];
        [items setObject:poster forKey:@"poster"];
        [items setObject:threadid forKey:@"threadid"];
        [items setObject:postid forKey:@"postid"];
        [items setObject:lastpost forKey:@"lastpost"];
        [items setObject:userid forKey:@"userid"];
        [items setObject:forumid forKey:@"forumid"];
        [items setObject:forumname forKey:@"forumname"];
        [items setObject:views forKey:@"views"];
        [items setObject:replies forKey:@"replies"];
        [items setObject:profileURLFast forKey:@"puf"];
        [universalFeeds addObject:[items copy]];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
   if([element isEqualToString:@"id"]){
        [firstID appendString:string];
   }else  if ([element isEqualToString:@"what"]) {
       [what appendString:string];
   }else  if ([element isEqualToString:@"when"]) {
       [when appendString:string];
   }else  if ([element isEqualToString:@"title"]) {
       [title appendString:string];
   }else  if ([element isEqualToString:@"preview"]) {
       [preview appendString:string];
   }else  if ([element isEqualToString:@"poster"]) {
       [poster appendString:string];
   }else  if ([element isEqualToString:@"threadid"]) {
       [threadid appendString:string];
   }else  if ([element isEqualToString:@"postid"]) {
       [postid appendString:string];
   }else  if ([element isEqualToString:@"lastpost"]) {
       [lastpost appendString:string];
   }else  if ([element isEqualToString:@"userid"]) {
       
       //NSMutableString *temp = [NSMutableString stringWithString:@"http://www.chiefdelphi.com/forums/image.php?u="];
       //[temp appendString:string];
       NSMutableString *tempS = [[NSMutableString alloc] initWithString:@"http://www.chiefdelphi.com/forums/image.php?u="];
       [tempS  appendString:string];
       //[profileURLFast setString:[profileURLFast stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
       
       NSURL *url = [NSURL URLWithString:tempS];
       NSData *data = [[NSData alloc] initWithContentsOfURL:url];
       if([data length] == 43){
           [profileURLFast setString:@"0"];
       }
       [userid appendString:string];
       //NSLog(userid);
   }else  if ([element isEqualToString:@"forumid"]) {
       [forumid appendString:string];
   }else  if ([element isEqualToString:@"forumname"]) {
       [forumname appendString:string];
   }else  if ([element isEqualToString:@"views"]) {
       [views appendString:string];
   }else  if ([element isEqualToString:@"replies"]) {
       [replies appendString:string];
   }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
}
@end