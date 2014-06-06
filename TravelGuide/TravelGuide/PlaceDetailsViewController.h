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
@property (weak, nonatomic) IBOutlet UIView *tipsView;
- (IBAction)btnAddToFavouritesClick:(id)sender;

@property (strong, nonatomic) NSArray *placeDetailModel;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;

@property (weak, atomic) NSString *name;
@property (weak, atomic) NSString *distance;
@property (weak, atomic) NSString *category;
@property (weak, atomic) NSString *address;
@property (weak, atomic) NSString *country;
@property (weak, atomic) NSString *lat;
@property (weak, atomic) NSString *lng;
@property (weak, atomic) NSString *placeId;
@property (weak, atomic) NSString *likes;
@property (weak, atomic) NSString *rating;
@property (weak, atomic) NSString *tips;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
