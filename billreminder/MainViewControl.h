//
//  MainViewControl.h
//  billreminder
//
//  Created by Arnaud Crowther on 12/21/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>

extern NSMutableArray *glblAccounts;
extern NSMutableArray *glblAmounts;
extern NSMutableArray *glblNotes;
extern NSMutableArray *glblDay;
extern NSMutableArray *glblRemind;
extern NSMutableArray *glblPriority;
extern NSMutableArray *glblPayed;
extern NSMutableArray *glblURL;

extern BOOL edit;
extern NSInteger editIndex;

NSTimer *aTimer;

@interface MainViewControl : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableView;
    IBOutlet UIImageView *imgView;
}
- (IBAction)editTable:(id)sender;
- (IBAction)longpress:(id)sender;


@end
