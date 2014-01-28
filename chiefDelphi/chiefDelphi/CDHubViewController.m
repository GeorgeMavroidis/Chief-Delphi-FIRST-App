//
//  CDHubViewController.m
//  chiefDelphi
//
//  Created by George on 1/3/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import "CDHubViewController.h"
#import "CDFirstBlog.h"
#import "CDSpyTableView.h"
#import "CDSpyHubCell.h"
#import "CDForumViewController.h"
#import "UIImageView+WebCache.h"
#import "CDHubViewController.h"
#import "CDFranksCell.h"
#import "CDHubInstagramCell.h"
#import "CDHubTwitterCell.h"
#import "CDCompetitionViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface CDHubViewController (){
    
    NSArray *tableData;
    
    NSXMLParser *instaparser, *twitparser;
    NSXMLParser *parser;
    
    NSMutableArray *universalFeeds;
    NSMutableArray *instafeeds, *twitfeeds;
    
    NSMutableDictionary *items;
    NSMutableDictionary *instaItem, *twititem;
    
    NSMutableString *instaImage, *instaHandle, *instaCaption, *likes;
    NSMutableString *twitimage, *twithandle, *twittext, *twitdate;
    
    UIRefreshControl *refreshControl;
    NSString *element;
    
    UITableView *mainTableView;
    
}

@end

@implementation CDHubViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.handleRefresher;
    self.navigationItem.hidesBackButton = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self populateToolbar];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self runParsers];
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView reloadData];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [mainTableView addSubview:refreshControl];
    self.view = mainTableView;
    self.navigationController.toolbarHidden = NO;    
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
}
-(void)worldTapped{
    // CDHubViewController *hub = [[CDHubViewController alloc] init];
    // [self.navigationController pushViewController:hub animated:NO];
}
-(void)homeTapped{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)regionalTapped{
    CDCompetitionViewController *cdcvc = [[CDCompetitionViewController alloc] init];
    //firstBlog.superNavController = self.navigationController;
    [self.navigationController pushViewController:cdcvc animated:NO];

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   /* UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    
    NSString *threadString = [[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"link"];
    for (int i = 0; i < 1; i++) {
        CGRect frame;
        frame.origin.x = scrollview.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = scrollview.frame.size;
        UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: frame];
        
        [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:threadString]]];
        [uiWebView setScalesPageToFit:YES];
        
        [scrollview addSubview:uiWebView];
    }
    
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width * 5, scrollview.frame.size.height);
    scrollview.pagingEnabled = YES;
    
    scrollview.bounces = NO;
    
    UIViewController *webViewController = [[UIViewController alloc] init];
    [webViewController.view addSubview:scrollview];
    [self.navigationController pushViewController:webViewController animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.toolbarHidden = YES;
    */
}

-(void)runParsers{
    
    universalFeeds = [[NSMutableArray alloc] init];
    
    instafeeds = [[NSMutableArray alloc] init];
    NSURL *instaurl = [NSURL URLWithString:@"http://georgemavroidis.com/cd/instagram/instagram.xml"];    // construct path within our documents directory
    NSString *applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *instaPath = [applicationDocumentsDir stringByAppendingPathComponent:@"insta.xml"];
    
    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:instaPath];
    if (myHandle == nil)
        NSLog(@"Failed to open file");
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:instaPath];
    
    if(fileExists){
        
        NSData *data = [NSData dataWithContentsOfURL:instaurl];  // Load XML data from web
        [data writeToFile:instaPath atomically:YES];
    }else{
        
        NSData *data = [NSData dataWithContentsOfURL:instaurl];  // Load XML data from web
        [data writeToFile:instaPath atomically:TRUE];
    }
    instaparser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:instaPath]];
    [instaparser setDelegate:self];
    [instaparser setShouldResolveExternalEntities:NO];
    
    [instaparser parse];
    
    twitfeeds = [[NSMutableArray alloc] init];
    NSURL *twiturl = [NSURL URLWithString:@"http://georgemavroidis.com/cd/tweets.xml"];
    
    applicationDocumentsDir =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *twitPath = [applicationDocumentsDir stringByAppendingPathComponent:@"twit.xml"];
    
    myHandle = [NSFileHandle fileHandleForWritingAtPath:twitPath];
    if (myHandle == nil)
        NSLog(@"Failed to open file");
    
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:instaPath];
    
    if(fileExists){
        
        NSData *data = [NSData dataWithContentsOfURL:twiturl];  // Load XML data from web
        [data writeToFile:twitPath atomically:YES];
    }else{
        
        NSData *data = [NSData dataWithContentsOfURL:twiturl];  // Load XML data from web
        [data writeToFile:twitPath atomically:TRUE];
    }
    twitparser = [[NSXMLParser alloc] initWithData:[NSData dataWithContentsOfFile:twitPath]];
    [twitparser setDelegate:self];
    [twitparser setShouldResolveExternalEntities:NO];
    
    [twitparser parse];
    
}
- (void)handleRefresh:(id)sender
{
    
    NSURL *url = [NSURL URLWithString:@"http://georgemavroidis.com/cd/time.php"];//prints txt file
    NSString *webData= [NSString stringWithContentsOfURL:url];
    int txt = [webData intValue];
    
    url = [NSURL URLWithString:@"http://georgemavroidis.com/cd/currentTime.php"];//gets current time
    webData= [NSString stringWithContentsOfURL:url];
    int time= [webData intValue];
    
    if((time-txt) > 100){
        
        url = [NSURL URLWithString:@"http://georgemavroidis.com/cd/putTime.php"];//puts to txt file
        webData= [NSString stringWithContentsOfURL:url];
        
        url = [NSURL URLWithString:@"http://georgemavroidis.com/cd/instagram/instagram_feed.php"];
        NSData *data=[NSData dataWithContentsOfURL:url];
        url = [NSURL URLWithString:@"http://georgemavroidis.com/cd/twitter_hashtag.php"];
        data=[NSData dataWithContentsOfURL:url];
        
        [self runParsers];
        
    }
   
    [mainTableView reloadData];
    [refreshControl endRefreshing];
    
}
-(void)handleRefresher{
    NSURL *url = [NSURL URLWithString:@"http://georgemavroidis.com/cd/time.php"];//prints txt file
    NSString *webData= [NSString stringWithContentsOfURL:url];
    int txt = [webData intValue];
    
    url = [NSURL URLWithString:@"http://georgemavroidis.com/cd/currentTime.php"];//gets current time
    webData= [NSString stringWithContentsOfURL:url];
    int time= [webData intValue];
    
    if((time-txt) > 100){
        
        url = [NSURL URLWithString:@"http://georgemavroidis.com/cd/putTime.php"];//puts to txt file
        webData= [NSString stringWithContentsOfURL:url];
        
        url = [NSURL URLWithString:@"http://georgemavroidis.com/cd/instagram/instagram_feed.php"];
        NSData *data=[NSData dataWithContentsOfURL:url];
        url = [NSURL URLWithString:@"http://georgemavroidis.com/cd/twitter_hashtag.php"];
        data=[NSData dataWithContentsOfURL:url];
        
        [self runParsers];
        
    }
    
    [mainTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSLog(@"%d", (int)[universalFeeds count]);
   // NSLog(@"number of instas");
    return instafeeds.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row %4 == 0){
        CDHubInstagramCell *instaCell = (CDHubInstagramCell *)[tableView dequeueReusableCellWithIdentifier:@"CDHubInstagramCell"];
        if (instaCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CDHubInstagramCell"owner:self options:nil];
            instaCell = (CDHubInstagramCell *)[nib objectAtIndex:0];
            instaCell.instaHandle.text = [[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"instaHandle"];
            instaCell.instaHeart.image = [UIImage imageNamed:@"instagram_heart.png"];
            instaCell.instaLikeCount.text =[[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"likes"];
            instaCell.instaText.text = [[universalFeeds objectAtIndex:indexPath.row] objectForKey:@"instaCaption"];
            [instaCell.instagramImage setImageWithURL:[NSURL URLWithString:[[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"instaImage"]]
                                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            
            //  NSLog([[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"instaImage"]);
            
        }
        return instaCell;
    }else{
        NSUInteger path = (indexPath.row)+instafeeds.count;
        CDHubTwitterCell *twitCell = (CDHubTwitterCell *)[tableView dequeueReusableCellWithIdentifier:@"CDHubTwitterCell"];
        if (twitCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CDHubTwitterCell"owner:self options:nil];
            twitCell = (CDHubTwitterCell *)[nib objectAtIndex:0];
            [[twitCell twitterContent] setFont:[UIFont fontWithName:@"Arial" size:11.0]];
            twitCell.twitHandle.textColor = [UIColor grayColor];
            twitCell.twitterContent.text = [[universalFeeds objectAtIndex:path] objectForKey: @"twittext"];
            twitCell.twitHandle.text = [[universalFeeds objectAtIndex:path] objectForKey: @"twithandle"];
            //cell.twitterProfileImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"twitprofileImage"]]]];
            [twitCell.twitImage setImageWithURL:[NSURL URLWithString:[[universalFeeds objectAtIndex:path] objectForKey: @"twitprofileImage"]]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        }
        return twitCell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row %4 == 0){
        return 400;
    }else
        return 120;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    [element stringByAppendingString:elementName];
    if ([element isEqualToString:@"instagram"]) {
        instaItem = [[NSMutableDictionary alloc] init];
        instaImage    = [[NSMutableString alloc] init];
        instaHandle = [[NSMutableString alloc] init];
        likes = [[NSMutableString alloc] init];
        instaCaption = [[NSMutableString alloc] init];
        
    }
    if ([element isEqualToString:@"twitter"]) {
        twititem    = [[NSMutableDictionary alloc] init];
        twithandle   = [[NSMutableString alloc] init];
        twitimage    = [[NSMutableString alloc] init];
        twitdate = [[NSMutableString alloc] init];
        twittext = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"instagram"]) {
        [instaItem setObject:instaImage forKey:@"instaImage"];
        [instaItem setObject:instaHandle forKey:@"instaHandle"];
        [instaItem setObject:likes forKey:@"likes"];
        [instaItem setObject:instaCaption forKey:@"instaCaption"];
        [instafeeds addObject:[instaItem copy]];
        [universalFeeds addObject:[instaItem copy]];
    }
    if ([elementName isEqualToString:@"twitter"]) {
        [twititem setObject:twithandle forKey:@"twithandle"];
        [twititem setObject:twitimage forKey:@"twitprofileImage"];
        [twititem setObject:twittext forKey:@"twittext"];
        [twititem setObject:twitdate forKey:@"twitdate"];
        [twitfeeds addObject:[twititem copy]];
        [universalFeeds addObject:[twititem copy]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([element isEqualToString:@"twithandle"]) {
        [twithandle appendString:@"@"];
        [twithandle appendString:string];
    } else if ([element isEqualToString:@"twitprofileImage"]) {
        [twitimage appendString:string];
    }else if ([element isEqualToString:@"twittext"]) {
        [twittext appendString:string];
    }else if([element isEqualToString:@"twitdate"]){
        [twitdate appendString:string];
    }else if([element isEqualToString:@"instaImage"]){
        [instaImage appendString:string];
    }else if([element isEqualToString:@"likes"]){
        [likes appendString:string];
    }else if([element isEqualToString:@"instaCaption"]){
        [instaCaption appendString:string];
    }else  if ([element isEqualToString:@"instaHandle"]) {
        [instaHandle appendString:@"@"];
        [instaHandle appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
}




@end
