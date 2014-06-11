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

@synthesize categoryNames;
@synthesize categoryIDs;
@synthesize locationManager;
@synthesize location;

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.navigationController.navigationBar.topItem.title = @"Travel guide";
    NSLog(@"viewDidLoad");
    
      categoryNames=[[NSArray alloc]initWithObjects:@"Arts and entertainment",@"Food and drink",@"Nightlife",@"Outdoors and recreation",@"Shops and services", @"Travel and transport", nil];
    
     categoryIDs=[[NSArray alloc]initWithObjects:@"4d4b7104d754a06370d81259",@"4d4b7105d754a06374d81259",@"4d4b7105d754a06376d81259",@"4d4b7105d754a06377d81259",@"4d4b7105d754a06378d81259", @"4d4b7105d754a06379d81259", nil];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100.0f;
    [locationManager startUpdatingLocation];
    
     //set default location in prefs
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
        dictionary[@"lat"]= @"42.0000";
        dictionary[@"lng"]= @"21.4333";
        [prefs setObject:dictionary forKey:@"latitudeLongitudePrefs"];
    
   

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
    return [categoryNames count];
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
    cell.categoryNameLabel.text = [categoryNames
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
        if (location == nil){
            lat=@"42.0000";
            lng=@"21.4333";
        }else{
            lat=[NSString stringWithFormat:@"%f", location.coordinate.latitude];
            lng=[NSString stringWithFormat:@"%f", location.coordinate.longitude];
        }
        
        detailViewController.categoryDetailModel = [[NSArray alloc]
                                               initWithObjects:
                                                    [categoryIDs objectAtIndex:[myIndexPath row]],
                                                    [categoryNames objectAtIndex:[myIndexPath row]],
                                                   lat,
                                                    lng,
                                               nil];
    }
}


#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations");
    location = [locations lastObject];
    
    NSString *latitudeString = [NSString stringWithFormat:@"%f",
                                location.coordinate.latitude];
    NSLog(@"lat:   %@",latitudeString);
    
    NSString *longitudeString = [NSString stringWithFormat:@"%f",
                                 location.coordinate.longitude];
    NSLog(@"long:   %@",longitudeString);
    
   // [_locationManager stopUpdatingLocation];
    
    //set new detected location to prefs
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
    dictionary[@"lat"]= latitudeString;
    dictionary[@"lng"]=longitudeString;
    [prefs setObject:dictionary forKey:@"latitudeLongitudePrefs"];
    
    
    NSMutableArray *favouritesArray=[[NSMutableArray alloc] init];
    
    //read user data:
    favouritesArray = [prefs mutableArrayValueForKey:@"favouritesArray"];
    
    //exists = true if there is a place that is at most 200m far from user location
    bool exists=false;
    NSString *nearPlaceName;
    NSInteger *nearPlaceDistance;
    for (NSMutableDictionary *dict in favouritesArray) {
     
        CLLocation *favouriteLocation = [[CLLocation alloc] initWithLatitude: [dict[@"lat"] doubleValue] longitude: [dict[@"lng"] doubleValue] ];
        CLLocationDistance distance = [location distanceFromLocation:favouriteLocation];
        
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
    location=nil;
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
    [super viewWillAppear:animated];

  [self.navigationController setNavigationBarHidden:YES animated:animated];
    //navigation bar style (transparent navigation bar)
     /*
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
   
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:((float) 21 / 255.0f)
                                                                              green:((float) 160 / 255.0f)
                                                                               blue:((float) 132/ 255.0f)
                                                                              alpha:0.8f];
       //set white title of view
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor  whiteColor] forKey:NSForegroundColorAttributeName];
   //    self.title=@"Travel guide";
    self.navigationController.navigationBar.topItem.title = @"Travel guide";
     */

  }

- (void)viewWillDisappear:(BOOL)animated {
     self.navigationController.navigationBar.topItem.title = @"";
 //   [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}


@end
