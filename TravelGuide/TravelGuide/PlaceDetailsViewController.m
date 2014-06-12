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

@synthesize placeDetailModel;
@synthesize nameLabel;
@synthesize  categoryLabel;
@synthesize tipsLabel;
@synthesize name;
@synthesize distance;
@synthesize category;
@synthesize address;
@synthesize country;
@synthesize lat;
@synthesize lng;
@synthesize placeId;
@synthesize likes;
@synthesize rating;
@synthesize tips;
@synthesize tipsView;

@synthesize mapView;
@synthesize locationManager;
@synthesize compassImage;
@synthesize imageViewFavourites;

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
    name=[placeDetailModel objectAtIndex:0];
    distance=[placeDetailModel objectAtIndex:1];
    category=[placeDetailModel objectAtIndex:2];
    address=[placeDetailModel objectAtIndex:3];
    country=[placeDetailModel objectAtIndex:4];
    lat=[placeDetailModel objectAtIndex:5];
    lng=[placeDetailModel objectAtIndex:6];
    placeId=[placeDetailModel objectAtIndex:7];
    likes=[placeDetailModel objectAtIndex:8];
    rating=[placeDetailModel objectAtIndex:9];
     tips=[placeDetailModel objectAtIndex:10];
    
    nameLabel.text = name;
    categoryLabel.text = category;
    tipsLabel.text=tips;
    
    //transparent navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor] ;
    self.navigationController.view.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"";
    
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude = [lat doubleValue];
    centerCoordinate.longitude = [lng doubleValue];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {centerCoordinate, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:centerCoordinate];
    [annotation setTitle: [NSString stringWithFormat:@"%@",address]];
    [annotation setSubtitle:[NSString stringWithFormat:@"%@",country]];
    
    [mapView setRegion:region];
    [mapView addAnnotation:annotation];
   
    
    locationManager=[[CLLocationManager alloc] init];
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.headingFilter = 1;
	locationManager.delegate=self;
    if (locationManager.headingAvailable && locationManager.locationServicesEnabled)
    {
        locationManager.headingFilter = kCLHeadingFilterNone;
        [locationManager startUpdatingHeading];
    }else NSLog(@"Can't startUpdatingHeading!");
    
    //read user data:
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   NSMutableArray *favouritesArray = [prefs mutableArrayValueForKey:@"favouritesArray"];
    
    bool exists=false;
    for (NSMutableDictionary *dict in favouritesArray) {
        if([dict[@"placeId"] isEqualToString: placeId]){
            exists=true;
            break;
        }
    }
    if(exists)
        imageViewFavourites.alpha=0.2;
    //show current location on map
   // mapView.showsUserLocation = YES;

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

- (IBAction)btnShowTipsClick:(id)sender {
    if(![tips isEqualToString:@""]){
    [UIView transitionWithView:tipsView
                  duration:0.4
                   options:UIViewAnimationOptionTransitionCrossDissolve
                animations:NULL
                completion:NULL];
    tipsView.hidden = !tipsView.hidden;
    }
}

- (IBAction)btnAddToFavouritesClick:(id)sender {
    NSMutableArray *favouritesArray=[[NSMutableArray alloc] init];
    
    //read user data:
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    favouritesArray = [prefs mutableArrayValueForKey:@"favouritesArray"];
    
    bool exists=false;
    for (NSMutableDictionary *dict in favouritesArray) {
        if([dict[@"placeId"] isEqualToString: placeId]){
            exists=true;
            break;
        }
    }
    if(!exists)
    {
        NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];
        dictionary[@"name"]= name;
        dictionary[@"distance"]= distance;
        dictionary[@"category"]= category;
        dictionary[@"address"]= address;
        dictionary[@"country"]= country;
        dictionary[@"lat"]= lat;
        dictionary[@"lng"]= lng;
        dictionary[@"placeId"]= placeId;
        dictionary[@"likes"]= likes;
        dictionary[@"rating"]= rating;
        dictionary[@"tips"]= tips;
        
        [favouritesArray addObject: dictionary];
        
        //save user data
        [prefs setObject:favouritesArray forKey:@"favouritesArray"];
        
        imageViewFavourites.alpha=0.2;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Place is added to favourites!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This place is already in your favourites list!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{
	// Convert Degree to Radian and move the needle
    NSLog(@"newHeading");
	float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
	float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
	CABasicAnimation *theAnimation;
	theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
	theAnimation.toValue=[NSNumber numberWithFloat:newRad];
	theAnimation.duration = 0.5f;
	[compassImage.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
	compassImage.transform = CGAffineTransformMakeRotation(newRad);
	NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
}

- (IBAction)btnShare:(id)sender
{
    NSString *text = [NSString stringWithFormat:@"You can't miss %@! Check out this app to find out the best places arround you!@",name];
 //   NSURL *url = [NSURL URLWithString:@"http://roadfiresoftware.com/2014/02/how-to-add-facebook-and-twitter-sharing-to-an-ios-app/"];
    UIImage *image = [UIImage imageNamed:@"launcher_icon_travel_guide"];
    
    UIActivityViewController *controller =
    [[UIActivityViewController alloc]
     initWithActivityItems:@[text, image]
     applicationActivities:nil];
    
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToFacebook,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
    
    [self presentViewController:controller animated:YES completion:nil];
}
@end
