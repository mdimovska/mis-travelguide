//
//  ViewController.h
//  TravelGuide
//
//  Created by Goran Kopevski on 6/1/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UITableViewController  <CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *categoryImages;
@property (nonatomic, strong) NSArray *categoryNames;
@property (nonatomic, strong) NSArray *categoryIDs;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startPoint;
@property (strong, nonatomic) CLLocation *location;

@end