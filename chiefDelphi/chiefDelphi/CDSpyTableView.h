//
//  CDSpyTableView.h
//  chiefDelphi
//
//  Created by George on 11/7/2013.
//  Copyright (c) 2013 George. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDFirstBlog.h"

@interface CDSpyTableView : UIViewController <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
-(void)populateToolbar;
-(void)launchBlog;
-(void)worldTapped;
-(void)handleRefresher;
 @property (assign, nonatomic) CGPoint lastContentOffset;

@end
