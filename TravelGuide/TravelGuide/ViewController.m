//
//  ViewController.m
//  TravelGuide
//
//  Created by Goran Kopevski on 6/1/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import "ViewController.h"
#import "CategoryTableViewCell.h"
#import "CategoryDetailsViewController.h"
#include <stdlib.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize backgroundImages=_backgroundImages;
@synthesize categoryNames=_categoryNames;
@synthesize categoryIDs=_categoryIDs;
@synthesize locationManager=_locationManager;
@synthesize location=_location;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
	// Do any additional setup after loading the view, typically from a nib.
    
    self.categoryNames=[[NSArray alloc]initWithObjects:@"Arts and entertainment",@"Food and drink",@"Nightlife",@"Outdoors and recreation",@"Shop and services", @"Travel & Transport", nil];
    
    self.backgroundImages=[[NSArray alloc]initWithObjects:@"background1.jpg",@"background2.jpg",@"background3.jpg",@"background4.jpg",@"background5.jpg",@"background6.jpg",@"background7.jpg",@"background8.jpg",@"background9.jpg",@"background10.jpg", nil];
    
    self.categoryIDs=[[NSArray alloc]initWithObjects:@"4d4b7104d754a06370d81259",@"4d4b7105d754a06374d81259",@"4d4b7105d754a06376d81259",@"4d4b7105d754a06377d81259",@"4d4b7105d754a06378d81259", @"4d4b7105d754a06379d81259", nil];
    
  //  int num=rand()%[self.backgroundImages count];
    int num = arc4random() % [self.backgroundImages count];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.backgroundImages
                                                                                         objectAtIndex: num]]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 100.0f;
    [_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.categoryNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"categoryTableCell";
    
    CategoryTableViewCell *cell = [tableView
                              dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CategoryTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.categoryNameLabel.text = [self.categoryNames
                           objectAtIndex: [indexPath row]];
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowCategoryDetails"])
    {
        CategoryDetailsViewController *detailViewController =  [segue destinationViewController] ;
        
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        NSString *lat;
        NSString *lng;
        if (_location == nil){
            lat=@"42.0000";
            lng=@"21.4333";
        }else{
            lat=[NSString stringWithFormat:@"%f", _location.coordinate.latitude];
            lng=[NSString stringWithFormat:@"%f", _location.coordinate.longitude];
        }
        
        detailViewController.categoryDetailModel = [[NSArray alloc]
                                               initWithObjects:
                                                    [self.categoryIDs objectAtIndex:[myIndexPath row]],
                                                    [self.categoryNames objectAtIndex:[myIndexPath row]],
                                                   lat,
                                                    lng,
                                               nil];
    }
}


#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    _location = [locations lastObject];
    
    NSString *latitudeString = [NSString stringWithFormat:@"%f",
                                _location.coordinate.latitude];
    NSLog(@"lat:   %@",latitudeString);
    
    NSString *longitudeString = [NSString stringWithFormat:@"%f",
                                 _location.coordinate.longitude];
    NSLog(@"long:   %@",longitudeString);
    
   // [_locationManager stopUpdatingLocation];
    
    
    NSMutableArray *favouritesArray=[[NSMutableArray alloc] init];
    
    //read user data:
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    favouritesArray = [prefs mutableArrayValueForKey:@"favouritesArray"];
    
    //exists = true if there is a place that is at most 200m far from user location
    bool exists=false;
    NSString *nearPlaceName;
    NSInteger *nearPlaceDistance;
    for (NSMutableDictionary *dict in favouritesArray) {
     
        CLLocation *favouriteLocation = [[CLLocation alloc] initWithLatitude: [dict[@"lat"] doubleValue] longitude: [dict[@"lng"] doubleValue] ];
        CLLocationDistance distance = [_location distanceFromLocation:favouriteLocation];
        
        NSString *distanceString = [NSString stringWithFormat: @"%f", distance];
        NSLog(distanceString);
        
        NSMutableArray *locationsArray=[[NSMutableArray alloc]init];
        
        if([distanceString doubleValue]<=200){
            exists=true;
            NSLog(@"dist:   %@",distanceString);
            NSLog(@"name:   %@",dict[@"name"]);
            nearPlaceName= dict[@"name"];
            nearPlaceDistance=[distanceString intValue];
            break;
        }
    }
    if(exists){
        //there is a favourite place near the user
        //local notification
        NSString *message = [NSString stringWithFormat: @"Your favourite place %@ is %d m from here. Why don't you visit it?",nearPlaceName, nearPlaceDistance];
        NSLog(message);
        
        NSDate *date = [NSDate date];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        //show notification after 60s
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];;
        localNotification.alertBody = message;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
      //   localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        localNotification.applicationIconBadgeNumber = 0;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }

    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    _location=nil;
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"User has denied to use current Location " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown network error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}



@end
