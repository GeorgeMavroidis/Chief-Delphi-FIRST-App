//
//  CDRegionalViewController.h
//  Chief Delphi
//
//  Created by George on 1/24/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDRankingsViewController.h"
#import "CDTeamViewController.h"

@interface CDRegionalViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSString *year, *code;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *contextSwitcher;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) IBOutlet CDRankingsViewController *rankings;
@property (strong, nonatomic) IBOutlet CDTeamViewController *team_view;
- (IBAction)changePage;
@end
