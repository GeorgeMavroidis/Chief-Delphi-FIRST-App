//
//  CDCompetitionViewController.m
//  Chief Delphi
//
//  Created by George on 1/23/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import "CDCompetitionViewController.h"
#import "CDFirstBlog.h"
#import "CDHubViewController.h"
#import "CDRegionalViewController.h"

@interface CDCompetitionViewController ()

@end
@implementation CDCompetitionViewController{
    NSArray *tableData;
    
    NSXMLParser *parser;
    
    NSMutableArray *universalFeeds, *event_array, *index_array;
    
    NSMutableDictionary *items;
    
    UIRefreshControl *refreshControl;
    
    UISearchBar *search;
    
    NSMutableString *event, *when, *where, *team, *code;
    
    int count;
    NSUInteger height;
    NSString *element, *year;
    UISegmentedControl *segControl;
}
//@synthesize searchBar;
@synthesize searchResults, yearSwitcher, mainTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect viewFrame = self.view.frame;
        viewFrame.size.height = self.view.frame.size.height-40;
        self.view.frame = viewFrame;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateToolbar];
    count = 0;
    //self.view = mainTableView;
    [self runParsers];
    
    [mainTableView setTableHeaderView:yearSwitcher];
    searchResults = [NSMutableArray arrayWithCapacity: [event_array count]];
    index_array = [NSMutableArray arrayWithCapacity: [event_array count]];
    
    segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"2014", @"2013", nil]];
    segControl.frame = CGRectMake(0, 0, 250, 40);
    segControl.selectedSegmentIndex = 0;
    
    [mainTableView setTableHeaderView:segControl];
    
    [[UISegmentedControl appearance] setTintColor:[UIColor orangeColor]];
    [segControl addTarget:self
                         action:@selector(pickOne:)
               forControlEvents:UIControlEventValueChanged];
    year = @"2014";
    // Do any additional setup after loading the view from its nib.
}
-(void) pickOne:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    year = [segControl titleForSegmentAtIndex: [segmentedControl selectedSegmentIndex]];
    NSLog(year);
    if([year isEqualToString:@"2014"]){
        [self runParsers];
        
    }else{
        [self runParsers2013];
    }
    
    [mainTableView reloadData];
    [mainTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [super viewDidAppear:animated];
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [searchResults removeAllObjects];
    [index_array removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    searchResults = [NSMutableArray arrayWithArray: [event_array filteredArrayUsingPredicate:resultPredicate]];
    
    for (int i = 0; i < searchResults.count; i++){
        for(int j = 0; j < universalFeeds.count; j++){
            if ([searchResults[i] isEqualToString:[[universalFeeds objectAtIndex:j]  objectForKey:@"event"]]) {
                [index_array addObject:[[universalFeeds objectAtIndex:j]  objectForKey:@"code"]];
            }
        }
    }
    
    //NSLog(event_array[0]);
    
    //NSLog(@"%d", searchResults.count);
    //NSLog(searchResults[0]);
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        CDRegionalViewController *regionalView = [[CDRegionalViewController alloc] init];
        [self.navigationController pushViewController:regionalView animated:YES];
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
        [regionalView.navigationItem setTitle:[self.searchResults objectAtIndex:indexPath.row]];
        regionalView.year = year;
        regionalView.code = [index_array objectAtIndex:indexPath.row];
    }
    else
    {
        CDRegionalViewController *regionalView = [[CDRegionalViewController alloc] init];
        [self.navigationController pushViewController:regionalView animated:YES];
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
        [regionalView.navigationItem setTitle:[[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"event"]];
        regionalView.year = year;
        
        regionalView.code = [[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"code"];
        
    }
}
-(void)runParsers{
    universalFeeds = [[NSMutableArray alloc] init];
    event_array = [[NSMutableArray alloc] init];
    
   // NSURL *newsurl = [NSURL URLWithString:@"http://georgemavroidis.com/cd/Parse/PHP/list.xml"];//
    
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"list" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    parser = [[NSXMLParser alloc] initWithData:xmlData];
    //parser = [[NSXMLParser alloc] initWithData:[NSData alloc] init @"list.xml"];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    //NSLog(@"i");
}
-(void)runParsers2013{
    universalFeeds = [[NSMutableArray alloc] init];
    event_array = [[NSMutableArray alloc] init];
    
    // NSURL *newsurl = [NSURL URLWithString:@"http://georgemavroidis.com/cd/Parse/PHP/list.xml"];//
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"2013list" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    parser = [[NSXMLParser alloc] initWithData:xmlData];
    //parser = [[NSXMLParser alloc] initWithData:[NSData alloc] init @"list.xml"];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"team" ascending:YES];
    universalFeeds = [universalFeeds sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    //NSLog(@"i");
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regionalTable"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"regionalTable"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"event"];
        
    }
    tableView.delegate = self;
    return cell;
    
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    else
    {
        NSLog(@"%d", (int)[universalFeeds count]);
        return [universalFeeds count];
    }
    //return [universalFeeds count];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"regional"]) {
        count++;
        items= [[NSMutableDictionary alloc] init];
        event = [[NSMutableString alloc] init];
        when = [[NSMutableString alloc] init];
        where = [[NSMutableString alloc] init];
        team = [[NSMutableString alloc] init];
        code = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"regional"]) {
        [items setObject:event forKey:@"event"];
        [event_array addObject:event];
        [items setObject:when forKey:@"when"];
        [items setObject:where forKey:@"where"];
        [items setObject:team forKey:@"team"];
        [items setObject:code forKey:@"code"];
        [universalFeeds addObject:[items copy]];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if([element isEqualToString:@"event"]){
        [event appendString:string];
    }else  if ([element isEqualToString:@"when"]) {
        [when appendString:string];
    }else  if ([element isEqualToString:@"where"]) {
        [where appendString:string];
    }else  if ([element isEqualToString:@"team"]) {
        [team appendString:string];
    }else  if ([element isEqualToString:@"code"]) {
        [code appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //This is where your search button action fires. You can implement what you want to do after search button click in here.
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    //This fires whenever you change text in your search bar. For an example if you want to show search suggestions when a new letter is typed you can implement that in here.
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
    CDHubViewController *hub = [[CDHubViewController alloc] init];
    [self.navigationController pushViewController:hub animated:NO];
}
-(void)homeTapped{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(void)regionalTapped{
    //CDCompetitionViewController *cdcvc = [[CDCompetitionViewController alloc] init];
    //firstBlog.superNavController = self.navigationController;
    //[self.navigationController pushViewController:cdcvc animated:NO];
    
}
@end
