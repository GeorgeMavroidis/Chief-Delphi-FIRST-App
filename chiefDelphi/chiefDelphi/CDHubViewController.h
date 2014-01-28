//
//  CDHubViewController.h
//  chiefDelphi
//
//  Created by George on 1/3/2014.
//  Copyright (c) 2014 George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDHubViewController : UIViewController  <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
-(void)populateToolbar;
-(void)handleRefresher;
-(void)runParsers;
@end
