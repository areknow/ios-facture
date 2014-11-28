//
//  NewEventTableControl.h
//  billreminder
//
//  Created by Arnaud Crowther on 12/21/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEventTableControl : UITableViewController
{
    NSTimer *aTimer;
    BOOL calIsFinished;
    BOOL payIsFinished;
    int lengthCal;
    int lengthPay;
    IBOutlet UITextField *txtName;
    IBOutlet UITextField *txtAmount;
    IBOutlet UITextField *txtURL;
    IBOutlet UILabel *lblReminderDays;
    IBOutlet UILabel *lblMonthly;
    IBOutlet UITextView *tvwNotes;
    IBOutlet UIStepper *stprRemind;
    IBOutlet UIBarButtonItem *btnDone;
    IBOutlet UIButton *btnGo;
    IBOutlet UISwitch *swtMonthly;
    IBOutlet UISegmentedControl *segPayed;
    IBOutlet UISegmentedControl *segPriority;
    IBOutletCollection(UIButton) NSArray *btnCollection;
}

- (IBAction)doneButton:(id)sender;
- (IBAction)stprRemDays:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)calButtons:(id)sender;
- (IBAction)segmPayed:(id)sender;
- (IBAction)segmPriority:(id)sender;
- (IBAction)btnGoURL:(id)sender;

- (IBAction)URLEditBegin:(id)sender;

@end
