//
//  CDRankingsViewController.m
//  Chief Delphi
//
//  Created by George on 1/24/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import "CDTeamViewController.h"

@interface CDTeamViewController (){
    NSArray *tableData;
    
    NSXMLParser *parser;
    
    NSMutableArray *universalFeeds, *team_names;
    
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
    NSString *teams_names_from_file;
    NSArray *team_array, *teams_names_array;
}

@end

@implementation CDTeamViewController

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
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    
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
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView reloadData];
    self.view = mainTableView;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

-(void)runParsers{
    //load team name switcher data
    
    universalFeeds = [[NSMutableArray alloc] init];
    NSString *parsed_url;
    if([code_from_file isEqualToString:@"2014"]){
        parsed_url = @"http://georgemavroidis.com/cd/Parse/PHP/regionals/";
    }else{
        parsed_url = @"http://georgemavroidis.com/cd/Parse/PHP/regionals/2013/";
    }
    parsed_url = [parsed_url stringByAppendingString:code_from_file];
    parsed_url = [parsed_url stringByAppendingString:@".txt"];
    NSURL *newsurl = [NSURL URLWithString:parsed_url];
    
    NSString *teams_at_regional = [NSString stringWithContentsOfURL:newsurl];
    
    team_array = [teams_at_regional componentsSeparatedByString:@","];
    team_array = [team_array sortedArrayUsingComparator:^(NSString *str1, NSString *str2) {
        return [str1 compare:str2 options:NSNumericSearch];
    }];
    
   
    
}
-(void)loadData{
    NSString *team_name;
    team_names = [[NSMutableArray alloc] init];
    
    /*for (NSString* t in team_array) {
        team_name = @"http://georgemavroidis.com/cd/Parse/PHP/get_names.php?team=";
        team_name = [team_name stringByAppendingString:t];
        
        NSURL *newsurl = [NSURL URLWithString:team_name];//
        
        NSString *team_from_url = [NSString stringWithContentsOfURL:newsurl];
        NSLog(@"test = %@", team_from_url);
        [team_names addObject:team_from_url];
    }*/
    
    NSString *documentsDirectory = [NSHomeDirectory()
                                    stringByAppendingPathComponent:@"Documents"];
    NSString *team_path = [documentsDirectory
                           stringByAppendingPathComponent:@"team_names.txt"];
    teams_names_from_file = [NSString stringWithContentsOfFile:team_path
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    teams_names_array = [teams_names_from_file componentsSeparatedByString:@","];
   
    

}
- (void)handleRefresh:(id)sender
{
    
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
    
    //NSLog(@"%d", (int)[universalFeeds count]);
    //NSLog(@"test");
    return [team_array count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rankingsTable"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"rankingsTable"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }    // Configure the cell...
    cell.textLabel.text = team_array[indexPath.row];
    //cell.textLabel.text = @"test";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
}



@end
