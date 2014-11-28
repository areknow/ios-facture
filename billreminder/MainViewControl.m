//
//  MainViewControl.m
//  billreminder
//
//  Created by Arnaud Crowther on 12/21/13.
//  Copyright (c) 2013 Arnaud Crowther. All rights reserved.
//
/**
 - Dont forget to rename all NSUserDefault variables!
 - Blank row being added on plus
 - Make notification work ALMOST THERE WOOOOOO
 - Add URL and payed arrays
 - Add priority array
**/

#import "MainViewControl.h"
#import <CoreMotion/CoreMotion.h>

@interface MainViewControl ()

@end

@implementation MainViewControl

NSMutableArray *glblAccounts;
NSMutableArray *glblAmounts;
NSMutableArray *glblNotes;
NSMutableArray *glblDay;
NSMutableArray *glblRemind;
NSMutableArray *glblPriority;
NSMutableArray *glblPayed;
NSMutableArray *glblURL;
BOOL edit = NO;
NSInteger editIndex;

#pragma mark - LOAD

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bgGrow];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(enterBGmode)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(exitBGmode)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:@"accountxxxxxx"]) {
        [self loadArrays];
    }
    else if (![defaults valueForKey:@"accountxxxxxx"]) {
        glblAccounts  = [[NSMutableArray alloc] init];
        glblAmounts = [[NSMutableArray alloc] init];
        glblNotes = [[NSMutableArray alloc] init];
        glblDay = [[NSMutableArray alloc] init];
        glblRemind = [[NSMutableArray alloc] init];
        glblPriority = [[NSMutableArray alloc] init];
        glblPayed = [[NSMutableArray alloc] init];
        glblURL = [[NSMutableArray alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    aTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(counter)
                                            userInfo:nil
                                             repeats:YES];
    edit = NO;
    [tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [aTimer invalidate];
    [self saveArrays];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TABLE

- (NSInteger)tableView:(UITableView *)tableViewa numberOfRowsInSection:(NSInteger)section {
    return glblAccounts.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView2 dequeueReusableCellWithIdentifier:CellIdentifer];
    NSUInteger row = [indexPath row];
    NSInteger sufixInt = [glblDay[indexPath.row] integerValue];
    NSString *sufix = [self dateSufix:sufixInt];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifer];
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:.3]];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    //Main label
    cell.textLabel.text = [glblAccounts objectAtIndex:row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28];
    //Detain Label
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Due on the %@%@",glblDay[indexPath.row],sufix];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    //Side label
    UILabel *sideLabel = [[UILabel alloc] initWithFrame:CGRectMake(240.0, 24.0, 220.0, 15.0)] ;
    sideLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18];
    NSString *tmpAmount = [glblAmounts objectAtIndex:row];
    NSRange range = [tmpAmount rangeOfString:@"."];
    if (range.location == NSNotFound) {
        NSString *tmp = [NSString stringWithFormat:@"%@.00",tmpAmount];//Add .00
        [glblAmounts replaceObjectAtIndex:row withObject:tmp];
    }
    sideLabel.text = [NSString stringWithFormat:@"$ %@",[glblAmounts objectAtIndex:row]];
    sideLabel.textColor = [UIColor whiteColor];
    //Cell Appearance
    cell.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:sideLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView3 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    edit = YES;
    editIndex = [indexPath row];
    [self performSegueWithIdentifier:@"newORedit" sender:self];
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.editing == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [glblAccounts removeObjectAtIndex:indexPath.row];
        [glblAmounts removeObjectAtIndex:indexPath.row];
        [glblNotes removeObjectAtIndex:indexPath.row];
        [glblDay removeObjectAtIndex:indexPath.row];
        [glblRemind removeObjectAtIndex:indexPath.row];
        [glblPriority removeObjectAtIndex:indexPath.row];
        [glblPayed removeObjectAtIndex:indexPath.row];
        [glblURL removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    }
}

#pragma mark - NSDATA

- (void)saveArrays {
    NSData *accounts = [NSKeyedArchiver archivedDataWithRootObject:glblAccounts];
    [[NSUserDefaults standardUserDefaults] setObject:accounts forKey:@"accountxxxxxx"];
    NSData *amounts = [NSKeyedArchiver archivedDataWithRootObject:glblAmounts];
    [[NSUserDefaults standardUserDefaults] setObject:amounts forKey:@"amountxxxxxx"];
    NSData *notes = [NSKeyedArchiver archivedDataWithRootObject:glblNotes];
    [[NSUserDefaults standardUserDefaults] setObject:notes forKey:@"notexxxxxx"];
    NSData *day = [NSKeyedArchiver archivedDataWithRootObject:glblDay];
    [[NSUserDefaults standardUserDefaults] setObject:day forKey:@"dayxxxxxx"];
    NSData *rem = [NSKeyedArchiver archivedDataWithRootObject:glblRemind];
    [[NSUserDefaults standardUserDefaults] setObject:rem forKey:@"remxxxxxx"];
    
    NSData *prior = [NSKeyedArchiver archivedDataWithRootObject:glblPriority];
    [[NSUserDefaults standardUserDefaults] setObject:prior forKey:@"priorxxxxxx"];
    NSData *payed = [NSKeyedArchiver archivedDataWithRootObject:glblPayed];
    [[NSUserDefaults standardUserDefaults] setObject:payed forKey:@"payedxxxxxx"];
    NSData *url = [NSKeyedArchiver archivedDataWithRootObject:glblURL];
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"urlxxxxxx"];
}

- (void)loadArrays {
    NSData *accounts = [[NSUserDefaults standardUserDefaults] objectForKey:@"accountxxxxxx"];
    glblAccounts = [NSKeyedUnarchiver unarchiveObjectWithData:accounts];
    NSData *amounts = [[NSUserDefaults standardUserDefaults] objectForKey:@"amountxxxxxx"];
    glblAmounts = [NSKeyedUnarchiver unarchiveObjectWithData:amounts];
    NSData *notes = [[NSUserDefaults standardUserDefaults] objectForKey:@"notexxxxxx"];
    glblNotes = [NSKeyedUnarchiver unarchiveObjectWithData:notes];
    NSData *day = [[NSUserDefaults standardUserDefaults] objectForKey:@"dayxxxxxx"];
    glblDay = [NSKeyedUnarchiver unarchiveObjectWithData:day];
    NSData *rem = [[NSUserDefaults standardUserDefaults] objectForKey:@"remxxxxxx"];
    glblRemind = [NSKeyedUnarchiver unarchiveObjectWithData:rem];
    
    NSData *prior = [[NSUserDefaults standardUserDefaults] objectForKey:@"priorxxxxxx"];
    glblPriority = [NSKeyedUnarchiver unarchiveObjectWithData:prior];
    NSData *payed = [[NSUserDefaults standardUserDefaults] objectForKey:@"payedxxxxxx"];
    glblPayed = [NSKeyedUnarchiver unarchiveObjectWithData:payed];
    NSData *url = [[NSUserDefaults standardUserDefaults] objectForKey:@"urlxxxxxx"];
    glblURL = [NSKeyedUnarchiver unarchiveObjectWithData:url];
}

#pragma mark - ANIMATIONS

- (void)bgGrow {
    [UIView animateWithDuration:13 animations:^() {
        imgView.transform = CGAffineTransformMakeScale(3, 3);
    }
                     completion:^(BOOL finished) {
                         [self bgShrink];
                     }];
}

- (void)bgShrink {
    [UIView animateWithDuration:13 animations:^() {
        imgView.transform = CGAffineTransformMakeScale(1, 1);
    }
                     completion:^(BOOL finished) {
                         [self bgGrow];
                     }];
}

#pragma mark - CUSTOM

- (void)enterBGmode {
    [self saveArrays];
}

- (void)exitBGmode {
}

- (void)counter {
    [UIApplication sharedApplication].applicationIconBadgeNumber = [glblAccounts count];
}


- (IBAction)editTable:(id)sender {
    UIBarButtonItem * button = ((UIBarButtonItem*)sender);
    if (!tableView.editing) {
        [tableView setEditing:YES animated:YES];
        [button setTitle:@"Done"];
    }
    else {
        [tableView setEditing:NO animated:YES];
        [button setTitle:@"Edit"];
    }
}

- (IBAction)longpress:(UIGestureRecognizer*)gesture {
    CGPoint p = [gesture locationInView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        [self performSegueWithIdentifier:@"newORedit" sender:self];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
