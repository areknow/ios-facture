//
//  NewEventTableControl.m
//  billreminder
//
//  Created by Arnaud Crowther on 12/21/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//

#import "NewEventTableControl.h"
#import "MainViewControl.h"

@interface NewEventTableControl ()

@end

@implementation NewEventTableControl

#pragma mark - LOAD

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    calIsFinished = NO;
    payIsFinished = NO;
    aTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(counter)
                                            userInfo:nil
                                             repeats:YES];
    if (edit == YES) {
        self.navigationItem.title = glblAccounts[editIndex];
        txtName.text = glblAccounts[editIndex];
        txtAmount.text = glblAmounts[editIndex];
        tvwNotes.text = glblNotes[editIndex];
        txtURL.text = glblURL[editIndex];
        [btnCollection[[glblDay[editIndex] intValue] -1] setSelected:YES];
        lblReminderDays.text = [self remindLabel:[glblRemind[editIndex] integerValue]];
        if ([glblPayed[editIndex] isEqualToString:@"YES"]) {
            [segPayed setSelectedSegmentIndex:1];
            [stprRemind setEnabled:NO];
            [stprRemind setTintColor:[UIColor colorWithRed:210.0/255.0 green:127.0/255.0 blue:254.0/255.0 alpha:1]];
            [lblReminderDays setTextColor:[UIColor lightGrayColor]];
            [swtMonthly setEnabled:NO];
            [lblMonthly setTextColor:[UIColor lightGrayColor]];
        }
        if ([glblPayed[editIndex] isEqualToString:@"NO"]) {
            [segPayed setSelectedSegmentIndex:0];
            [stprRemind setEnabled:YES];
            [stprRemind setTintColor:[UIColor colorWithRed:166.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1]];
            [lblReminderDays setTextColor:[UIColor blackColor]];
            [swtMonthly setEnabled:YES];
            [lblMonthly setTextColor:[UIColor blackColor]];
        }
    }
    
}

#pragma mark - UNLOAD

- (void)viewWillDisappear:(BOOL)animated {
    [aTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBACTION

- (IBAction)doneButton:(id)sender {
    NSString *tmpName = txtName.text;
    NSString *tmpAmount = txtAmount.text;
    NSString *tmpNotes = tvwNotes.text;
    NSString *tmpURL = txtURL.text;
    if (edit == NO) {
        [glblAccounts addObject:tmpName];
        [glblAmounts addObject:tmpAmount];
        [glblNotes addObject:tmpNotes];
        [glblRemind addObject:@"1"];
        [glblPriority addObject:@"HIGH"];
        [glblURL addObject:tmpURL];
        if (calIsFinished == NO) {
            [glblDay addObject:@"1"];
        }
        if (payIsFinished == NO) {
            [glblPayed addObject:@"NO"];
        }
        [self NotifierWithDay:[glblDay[[glblAccounts count] -1] integerValue]];
    }
    else if (edit == YES) {
        [glblAccounts replaceObjectAtIndex:editIndex withObject:tmpName];
        [glblAmounts replaceObjectAtIndex:editIndex withObject:tmpAmount];
        [glblNotes replaceObjectAtIndex:editIndex withObject:tmpNotes];
        [glblPriority replaceObjectAtIndex:editIndex withObject:@"HIGH"];
        [glblURL replaceObjectAtIndex:editIndex withObject:tmpURL];
        if (segPayed.selectedSegmentIndex == 0) {
            [glblPayed replaceObjectAtIndex:editIndex withObject:@"NO"];
        }
        else if (segPayed.selectedSegmentIndex == 1) {
            [glblPayed replaceObjectAtIndex:editIndex withObject:@"YES"];
        }
        [self NotifierWithDay:[glblDay[editIndex]integerValue]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)stprRemDays:(id)sender {
    UIStepper *step = sender;
    int val = step.value;
    lblReminderDays.text = [self remindLabel:val];
    if (edit == NO) {
        [glblRemind addObject:[NSString stringWithFormat:@"%d",val]];
    }
    else if (edit == YES) {
        [glblRemind replaceObjectAtIndex:editIndex withObject:[NSString stringWithFormat:@"%d",val]];
    }
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)calButtons:(id)sender {
    int tag = [sender tag];
    NSString *tmpDay = [NSString stringWithFormat:@"%d",tag];
    if (edit == YES) {
        [glblDay replaceObjectAtIndex:editIndex withObject:tmpDay];
    }
    else if (edit == NO) {
        if (calIsFinished == NO) {
            [glblDay addObject:tmpDay];
            calIsFinished = YES;
            lengthCal = [glblDay count] - 1;
        }
        else if (calIsFinished == YES) {
            [glblDay replaceObjectAtIndex:lengthCal withObject:tmpDay];
        }
    }
    for (UIButton *button in btnCollection) {
        button.selected = NO;
    }
    [sender setSelected:YES];
}

- (IBAction)segmPayed:(id)sender {
    UISegmentedControl *seg = sender;
    if (seg.selectedSegmentIndex == 0) {
        [stprRemind setEnabled:YES];
        [stprRemind setTintColor:[UIColor colorWithRed:166.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1]];
        [lblReminderDays setTextColor:[UIColor blackColor]];
        [swtMonthly setEnabled:YES];
        [lblMonthly setTextColor:[UIColor blackColor]];
    }
    else if (seg.selectedSegmentIndex == 1) {
        [stprRemind setEnabled:NO];
        [stprRemind setTintColor:[UIColor colorWithRed:210.0/255.0 green:127.0/255.0 blue:254.0/255.0 alpha:1]];
        [lblReminderDays setTextColor:[UIColor lightGrayColor]];
        [swtMonthly setEnabled:NO];
        [lblMonthly setTextColor:[UIColor lightGrayColor]];
    }
}

- (IBAction)segmPriority:(id)sender {
}

- (IBAction)btnGoURL:(id)sender {
    if ([btnGo.titleLabel.text isEqualToString:@"Save"]) {
        [btnGo setTitle:@"Go" forState:UIControlStateNormal];
        [txtURL resignFirstResponder];
    }
    else if ([btnGo.titleLabel.text isEqualToString:@"Go"]) {
        NSString *tmpURL = txtURL.text;
        NSRange range = [tmpURL rangeOfString:@"http://www."];
        if (range.location == NSNotFound) {
            txtURL.text = [NSString stringWithFormat:@"http://www.%@",tmpURL];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:txtURL.text]];
    }
}

- (IBAction)URLEditBegin:(id)sender {
    [btnGo setTitle: @"Save" forState:UIControlStateNormal];
}

#pragma mark - CUSTOM

- (void)NotifierWithDay:(int)day {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *liveComponents = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit) fromDate:today];
    NSDateComponents *userComponents = [[NSDateComponents alloc] init];
    [userComponents setDay:day];
    [userComponents setYear:[liveComponents year]];
    [userComponents setHour:8];
    [userComponents setMinute:00];
    NSString *month;
    NSString *sufix = [self dateSufix:day];
    NSString *account;
    if (edit == YES) {
        account = glblAccounts[editIndex];
    }
    else if (edit == NO) {
        account = glblAccounts[[glblAccounts count]-1];
    }
    if ([userComponents day] <= [liveComponents day]) {
        [userComponents setMonth:[liveComponents month]+1];
        month = @"next month";
    }
    else if ([userComponents day] > [liveComponents day]) {
        [userComponents setMonth:[liveComponents month]];
        month = @"this month";
    }
    NSDate *itemDate = [gregorian dateFromComponents:userComponents];
    UILocalNotification *localNotifier = [[UILocalNotification alloc] init];
    if (localNotifier == nil)
        return;
    localNotifier.fireDate = itemDate;
    localNotifier.timeZone = [NSTimeZone defaultTimeZone];
    localNotifier.alertBody = [NSString stringWithFormat:@"%@ is due tomorrow!",glblAccounts[editIndex]];
    localNotifier.alertAction = @"View";
    localNotifier.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"FactureAppLocalNotification" forKey:account];
    localNotifier.userInfo = infoDict;
    //[[UIApplication sharedApplication] scheduleLocalNotification:localNotifier];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification Scheduled"
                                                    message:[NSString stringWithFormat:
                                                             @"Your %@ reminder is set for the %d%@ of %@.",
                                                             account,day,sufix,month]
                                                   delegate:nil
                                          cancelButtonTitle:@"Done"
                                          otherButtonTitles:nil];
    [alert show];
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    NSLog(@"%@",eventArray);
}

- (void)counter {
    if (![txtName.text isEqualToString:@""] || ![txtAmount.text isEqualToString:@""]) {
        [btnDone setEnabled:YES];
    }
    if ([txtName.text isEqualToString:@""] || [txtAmount.text isEqualToString:@""]) {
        [btnDone setEnabled:NO];
    }
    if (![txtURL.text isEqualToString:@""]) {
        [btnGo setEnabled:YES];
    }
    if ([txtURL.text isEqualToString:@""]) {
        [btnGo setEnabled:NO];
    }
}

- (NSString *)remindLabel:(int)val {
    NSString *string;
    switch (val) {
        case 1: string = @"1 Day In Advance"; break;
        case 2: string = @"2 Days In Advance"; break;
        case 3: string = @"3 Days In Advance"; break;
        case 4: string = @"4 Days In Advance"; break;
        case 5: string = @"5 Days In Advance"; break;
    }
    return string;
}

- (NSString *)dateSufix:(NSInteger)onDay {
    NSString *string;
    switch (onDay) {
        case 1: string = @"st"; break;
        case 2: string = @"nd"; break;
        case 3: string = @"rd"; break;
        case 21: string = @"st"; break;
        case 22: string = @"nd"; break;
        case 23: string = @"rd"; break;
        case 31: string = @"st"; break;
        default: string = @"th"; break;
    }
    return string;
}

@end
