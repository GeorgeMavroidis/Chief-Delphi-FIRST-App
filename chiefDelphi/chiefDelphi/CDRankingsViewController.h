//
//  CDRankingsViewController.h
//  Chief Delphi
//
//  Created by George on 1/24/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDRankingsViewController : UIViewController <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
//@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (nonatomic, strong) NSString *second_year, *second_code;
-(void)setCodeValue:(NSString *) codeValue;
-(void)downloadTeamNames:(NSString *) team_number;
@end
