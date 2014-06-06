//
//  PlaceDetailsViewController.h
//  TravelGuide
//
//  Created by Goran Kopevski on 6/4/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PlaceDetailsViewController : UIViewController
- (IBAction)btnAddToFavouritesClick:(id)sender;

@property (strong, nonatomic) NSArray *placeDetailModel;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;

@property (strong, atomic) NSString *name;
@property (strong, atomic) NSString *distance;
@property (strong, atomic) NSString *category;
@property (strong, atomic) NSString *address;
@property (strong, atomic) NSString *country;
@property (strong, atomic) NSString *lat;
@property (strong, atomic) NSString *lng;
@property (strong, atomic) NSString *placeId;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
