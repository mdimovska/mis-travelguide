//
//  PlaceDetailsViewController.m
//  TravelGuide
//
//  Created by Goran Kopevski on 6/4/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import "PlaceDetailsViewController.h"

@interface PlaceDetailsViewController ()

@end

@implementation PlaceDetailsViewController

@synthesize placeDetailModel=_placeDetailModel;
@synthesize nameLabel=_nameLabel;
@synthesize distanceLabel=_distanceLabel;
@synthesize  categoryLabel=_categoryLabel;
@synthesize addressLabel=_addressLabel;
@synthesize  countryLabel=_countryLabel;

@synthesize mapView=_mapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nameLabel.text = [self.placeDetailModel objectAtIndex:0];
    self.distanceLabel.text = [self.placeDetailModel objectAtIndex:1];
    self.categoryLabel.text = [self.placeDetailModel objectAtIndex:2];
     self.addressLabel.text = [self.placeDetailModel objectAtIndex:3];
     self.countryLabel.text = [self.placeDetailModel objectAtIndex:4];
    
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude = [[self.placeDetailModel objectAtIndex:5] doubleValue];
    centerCoordinate.longitude = [[self.placeDetailModel objectAtIndex:6] doubleValue];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {centerCoordinate, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:centerCoordinate];
     [annotation setTitle:[self.placeDetailModel objectAtIndex:0] ];
    
    [self.mapView setRegion:region];
    [self.mapView addAnnotation:annotation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
