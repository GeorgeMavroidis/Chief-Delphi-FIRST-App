//
//  CDFranksViewController.m
//  chiefDelphi
//
//  Created by George on 1/2/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import "CDFranksViewController.h"
#import "CDFirstBlog.h"
#import "CDFranksCell.h"

@interface CDFranksViewController ()

@end


@implementation CDFranksViewController{

    NSArray *tableData;
    
    NSXMLParser *parser;
    
    NSMutableArray *universalFeeds;
    
    NSMutableDictionary *items;
    
    UIRefreshControl *refreshControl;
    
    UITableView *mainTableView;
        
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *pubdate;
    int count;
    NSString *element;
    
}
@synthesize superNavController;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self runParsers];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView reloadData];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [mainTableView addSubview:refreshControl];
    count = 0;
    self.view = mainTableView;
    
    
    UISwipeGestureRecognizer *swipeRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(frankTapped)];
    swipeRecognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
    swipeRecognizerUp.delegate = self;
    [mainTableView addGestureRecognizer:swipeRecognizerUp];
    
    
    UISwipeGestureRecognizer *swipeRecognizerD = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(frankTappedD)];
    swipeRecognizerD.direction = UISwipeGestureRecognizerDirectionDown;
    swipeRecognizerD.delegate = self;
    [mainTableView addGestureRecognizer:swipeRecognizerD];
    
    [self runParsers];
    
}
-(void)frankTapped{
   NSLog(@"hi");
    CGRect frame = mainTableView.frame;
    frame.origin.y = 15;
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         mainTableView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         // whatever you need to do when animations are complete
                     }];
    
    
    
   // [[self superNavController] setNavigationBarHidden:YES animated:YES];
    
   // [[self superNavController] setToolbarHidden:NO animated:YES];

    
}

-(void)frankTappedD{
    NSLog(@"Down");
    CGRect frame = mainTableView.frame;
    frame.origin.y = 155;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         mainTableView.frame = frame;
                     }
                     completion:^(BOOL finished){
                         // whatever you need to do when animations are complete
                     }];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[self navigationController] setToolbarHidden:YES animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect subViewBounds = mainTableView.bounds;
    
    NSString *threadString = [[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"link"];
    threadString = [threadString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    NSURL *url = [NSURL URLWithString:threadString];//prints txt file
    NSString *webData= [NSString stringWithContentsOfURL:url];
    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame: subViewBounds];
    
    [uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:threadString]]];
    [uiWebView setScalesPageToFit:YES];
    
    
    [self.view addSubview:uiWebView];

}

-(void)runParsers{
    universalFeeds = [[NSMutableArray alloc] init];
    NSURL *newsurl = [NSURL URLWithString:@"http://www.usfirst.org/roboticsprograms/frc/blog.xml"];//
    parser = [[NSXMLParser alloc] initWithContentsOfURL:newsurl];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
}
- (void)handleRefresh:(id)sender
{
    for(UIWebView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    self.viewDidLoad;
    [self runParsers];
    [mainTableView reloadData];
    [refreshControl endRefreshing];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [universalFeeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDFranksCell *cell = (CDFranksCell *)[tableView dequeueReusableCellWithIdentifier:@"CDFranksCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CDFranksCell"owner:self options:nil];
        cell = (CDFranksCell *)[nib objectAtIndex:0];
        
    }
    cell.blogTitle.text = [[universalFeeds objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.blogTitle.font = [UIFont boldSystemFontOfSize:16.0f];
    
    // Configure the cell...
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"item"]) {
        count++;
        items= [[NSMutableDictionary alloc] init];
        title= [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
        pubdate = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [items setObject:title forKey:@"title"];
        [items setObject:link forKey:@"link"];
        [items setObject:pubdate forKey:@"pubdate"];
        [universalFeeds addObject:[items copy]];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if([element isEqualToString:@"title"]){
        [title appendString:string];
    }else  if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }else  if ([element isEqualToString:@"pubdate"]) {
        [pubdate appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
}




@end
