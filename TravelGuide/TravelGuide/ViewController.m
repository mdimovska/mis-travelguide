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

@interface ViewController ()

@end

@implementation ViewController

@synthesize categoryImages=_categoryImages;
@synthesize categoryNames=_categoryNames;
@synthesize categoryIDs=_categoryIDs;
@synthesize locationManager=_locationManager;
@synthesize location=_location;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.categoryNames=[[NSArray alloc]initWithObjects:@"Arts and entertainment",@"Food and drink",@"Nightlife",@"Outdoors and recreation",@"Shop and services", nil];
    
    self.categoryImages=[[NSArray alloc]initWithObjects:@"art1.jpg",@"food1.jpg",@"nightlife1.jpg",@"outdoors1.jpg",@"shops1.jpg", nil];
    
    self.categoryIDs=[[NSArray alloc]initWithObjects:@"4d4b7104d754a06370d81259",@"4d4b7105d754a06374d81259",@"4d4b7105d754a06376d81259",@"4d4b7105d754a06377d81259",@"4d4b7105d754a06378d81259", nil];
    
    self.locationManager = [[CLLocationManager alloc] init]; _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest; [_locationManager startUpdatingLocation];
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
    
    UIImage *categoryPhoto = [UIImage imageNamed:
                         [self.categoryImages objectAtIndex: [indexPath row]]];
    
    cell.categoryImage.image = categoryPhoto;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowCategoryDetails"])
    {
        
        CategoryDetailsViewController *detailViewController =
        [segue destinationViewController];
    
        
      //  UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
       // CategoryDetailsViewController *detailViewController = [navController topViewController];
        
        //UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
   //   CategoryDetailsViewController *detailViewController = (CategoryDetailsViewController *)[navController topViewController];

        
        
        
    //    CategoryDetailsViewController *detailViewController = (CategoryDetailsViewController *)[[segue destinationViewController] topViewController];
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
                                               initWithObjects: [self.categoryIDs
                                                                 objectAtIndex:[myIndexPath row]],
                                               [self.categoryNames objectAtIndex:[myIndexPath row]],
                                                    [self.categoryImages objectAtIndex:[myIndexPath row]],
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
    [_locationManager stopUpdatingLocation];
    
    /*
    if (_startPoint == nil) {
        self.startPoint = newLocation;
        self.distanceFromStart = 0;
    } else {
        self.distanceFromStart = [newLocation
                                  distanceFromLocation:_startPoint];
    }
    NSString *distanceString = [NSString stringWithFormat:@"%gm", _distanceFromStart];
    _distanceTraveledLabel.text = distanceString;
     */
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    /*
    NSString *errorType = (error.code == kCLErrorDenied) ?
    @"Access Denied" : @"Unknown Error";
    UIAlertView *alert1 = [[UIAlertView alloc]
                          initWithTitle:@"Error getting Location"
                          message:errorType
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert1 show];
    */
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

@end
