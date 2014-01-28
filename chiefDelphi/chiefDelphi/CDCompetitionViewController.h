//
//  CDCompetitionViewController.h
//  Chief Delphi
//
//  Created by George on 1/23/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDCompetitionViewController : UIViewController <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *codeResults;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *yearSwitcher;
-(void)populateToolbar;
-(void)runParsers;
-(void)runParsers2013;
@end
