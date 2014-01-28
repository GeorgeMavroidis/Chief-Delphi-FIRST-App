//
//  CDMainViewController.m
//  chiefDelphi
//
//  Created by George on 11/5/2013.
//  Copyright (c) 2013 George. All rights reserved.
//

#import "CDMainViewController.h"
#import "CDSpyTableView.h"

@implementation CDMainViewController{
    NSArray *tableData;
    NSXMLParser *parser;
    NSMutableArray *universalFeeds;
    NSMutableDictionary *items;
    UIRefreshControl *refreshControl;
    CDSpyTableView *mainTableView;
    NSString *element;
}
@synthesize mainScrollView;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end