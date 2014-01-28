//
//  CDRankingsViewController.m
//  Chief Delphi
//
//  Created by George on 1/24/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import "CDRankingsViewController.h"

@interface CDRankingsViewController (){
    NSArray *tableData;
    
    NSXMLParser *parser;
    
    NSMutableArray *universalFeeds, *teamNames, *team_numbers;
    
    NSMutableDictionary *items;
    
    UIRefreshControl *refreshControl;
    //UITableView *mainTableView;
    NSMutableString *rank, *team, *one, *two, *three, *four, *five, *dq, *record, *played;
    int count;
    NSString *element;
    NSString *local;
    UITableView *mainTableView;
    NSString *code_from_file;
    NSString *year_from_file;
    
}

@end

@implementation CDRankingsViewController
@synthesize second_code, second_year;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       // second_code = @"one";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *code_path = [documentsDirectory
                          stringByAppendingPathComponent:@"code.txt"];
    code_from_file = [NSString stringWithContentsOfFile:code_path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSString *year_path = [documentsDirectory
                           stringByAppendingPathComponent:@"year.txt"];
    year_from_file = [NSString stringWithContentsOfFile:year_path
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    
    
    [self runParsers];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //NSLog(@"test");
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView reloadData];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [mainTableView addSubview:refreshControl];
    //[self.view addSubview:mainTableView];
    self.view = mainTableView;
    //NSLog(@"test %@", second_code);
    //NSLog(@"code = %@", second_code);
    //NSLog(@"test");

}
-(void)setCodeValue:(NSString *)codeValue{
    self.second_code = [NSString stringWithString:codeValue];
    local = [NSString stringWithString:codeValue];
    //NSLog(second_code);
}
-(void)downloadTeamNames:(NSString *)team_number{
    
    NSString *parse_url = @"http://georgemavroidis.com/cd/Parse/PHP/get_names.php?team=";
    parse_url = [parse_url stringByAppendingString:team_number];
    
    NSURL *toUrl = [NSURL URLWithString:parse_url];
    NSData *team_name_data = [NSData dataWithContentsOfURL:toUrl];
    
    //NSLog(@"%@", team_name_data);
    
    [teamNames addObject:team_name_data];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(void)runParsers{
    universalFeeds = [[NSMutableArray alloc] init];
    team_numbers = [[NSMutableArray alloc] init];
    
    NSString *parsed_url = @"http://georgemavroidis.com/cd/Parse/PHP/standings/";
    parsed_url = [parsed_url stringByAppendingString:year_from_file];
    parsed_url = [parsed_url stringByAppendingString:@"/"];
    parsed_url = [parsed_url stringByAppendingString:code_from_file];
    parsed_url = [parsed_url stringByAppendingString:@".xml"];
    
    //NSLog(parsed_url);
    NSURL *newsurl = [NSURL URLWithString:parsed_url];//
    parser = [[NSXMLParser alloc] initWithContentsOfURL:newsurl];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    //NSLog(team_numbers[0]);
    
}
- (void)handleRefresh:(id)sender
{
    NSString *parsed_url = @"http://georgemavroidis.com/cd/Parse/PHP/standings.php?code=";
    parsed_url = [parsed_url stringByAppendingString:code_from_file];
    parsed_url = [parsed_url stringByAppendingString:@"&year="];
    parsed_url = [parsed_url stringByAppendingString:year_from_file];
    
    NSURL *newsurl = [NSURL URLWithString:parsed_url];//
    parser = [[NSXMLParser alloc] initWithContentsOfURL:newsurl];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
    [self runParsers];
    
    [mainTableView reloadData];
    [refreshControl endRefreshing];
    
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
    //NSLog(@"test");
    return [universalFeeds count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rankingsTable"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"rankingsTable"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }    // Configure the cell...
    cell.textLabel.text = [[universalFeeds objectAtIndex:indexPath.row] objectForKey: @"team"];
    //NSString *team = [[universalFeeds objectAtIndex:indexPath.row] objectForKey:@"team"];
   // [NSThread detachNewThreadSelector:@selector(downloadTeamNames:) toTarget:self withObject:nil];
   // [self downloadTeamNames:[[universalFeeds objectAtIndex:indexPath.row] objectForKey:@"team"]];
    //cell.textLabel.text = @"test";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"standings"]) {
        count++;
        items= [[NSMutableDictionary alloc] init];
        rank = [[NSMutableString alloc] init];
        team = [[NSMutableString alloc] init];
        one = [[NSMutableString alloc] init];
        two = [[NSMutableString alloc] init];
        three = [[NSMutableString alloc] init];
        four = [[NSMutableString alloc] init];
        five = [[NSMutableString alloc] init];
        dq = [[NSMutableString alloc] init];
        record = [[NSMutableString alloc] init];
        played = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"standings"]) {
        [items setObject:rank forKey:@"rank"];
        [items setObject:team forKey:@"team"];
        [items setObject:one forKey:@"one"];
        [items setObject:two forKey:@"two"];
        [items setObject:three forKey:@"three"];
        [items setObject:four forKey:@"four"];
        [items setObject:five forKey:@"five"];
        [items setObject:dq forKey:@"dq"];
        [items setObject:record forKey:@"record"];
        [items setObject:played forKey:@"played"];
        [universalFeeds addObject:[items copy]];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if([element isEqualToString:@"rank"]){
        [rank appendString:string];
    }else  if ([element isEqualToString:@"team"]) {
        [team appendString:string];
        [team_numbers addObject:string];
    }else  if ([element isEqualToString:@"one"]) {
        [one appendString:string];
    }else  if ([element isEqualToString:@"two"]) {
        [two appendString:string];
    }else  if ([element isEqualToString:@"three"]) {
        [three appendString:string];
    }else  if ([element isEqualToString:@"four"]) {
        [four appendString:string];
    }else  if ([element isEqualToString:@"five"]) {
        [five appendString:string];
    }else  if ([element isEqualToString:@"dq"]) {
        [dq appendString:string];
    }else  if ([element isEqualToString:@"record"]) {
        [record appendString:string];
    }else  if ([element isEqualToString:@"played"]) {
        [played appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    
}



@end
