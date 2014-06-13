//
//  PlaceDetailsViewController.m
//  TravelGuide
//
//  Created by Milena Dimovska on 6/4/14.
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
@synthesize venueUrl;

@synthesize mapView;
@synthesize routeDetails;
@synthesize locationManager;
@synthesize compassImage;
@synthesize imageViewFavourites;

NSString * text;

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
    venueUrl=[placeDetailModel objectAtIndex:11];    nameLabel.text = name;
    
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
   
    mapView.delegate = self;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary= [prefs dictionaryForKey:@"latitudeLongitudePrefs"];
    
    NSString * latitude=dictionary[@"lat"];
    NSString * longitude=dictionary[@"lng"];
    double l1 = [[latitude stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] doubleValue];
    double l2 = [[longitude stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] doubleValue];
    
    
    MKPlacemark *source = [[MKPlacemark   alloc]initWithCoordinate:CLLocationCoordinate2DMake(l1,l2)   addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:centerCoordinate addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error)
        {
            NSLog(@"Error %@", error.description);
        }
        else
        {
            NSLog(@"response = %@",response);
            routeDetails = response.routes.lastObject;
            [self.mapView addOverlay:routeDetails.polyline];
            
        }
    }];

    
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
   mapView.showsUserLocation = YES;
    
   text = [NSString stringWithFormat:@"Check out this place - %@ (%@) via TravelGuide", name, country];

}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}


-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer  * routeLineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:routeDetails.polyline];
    routeLineRenderer.strokeColor = [UIColor  colorWithRed:((float) 21 / 255.0f)
                                                     green:((float) 160 / 255.0f)
                                                      blue:((float) 132/ 255.0f)
                                                     alpha:0.7];
    routeLineRenderer.lineWidth = 5;
    return routeLineRenderer;
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
        dictionary[@"venueUrl"]= venueUrl;
        
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self shareToTwitter];
    } else if (buttonIndex == 1){
        [self shareToFacebook];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    //[[actionSheet layer] setBackgroundColor:[UIColor grayColor].CGColor];
    
    [actionSheet.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(102/255.0) blue:(85/255.0) alpha:1];
        }
    }];
}

- (void) shareToTwitter{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:text];
        [tweetSheet addImage:[UIImage imageNamed:@"Icon-76.png"]];
        if (venueUrl != NULL)
            [tweetSheet addURL:[NSURL URLWithString:venueUrl]];
        
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Post Canceled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Sucessful";
                    break;
                default:
                    break;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Complition Message"
                                                            message:output
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure                                   your device has an internet connection and you have                                   at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) shareToFacebook{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller addImage:[UIImage imageNamed:@"Icon-76.png"]];
        
        if (venueUrl != NULL)
            [controller addURL:[NSURL URLWithString:venueUrl]];
        
        [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Post Canceled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Post Sucessful";
                    break;
                default:
                    break;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Complition Message"
                                                            message:output
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
        [controller setInitialText:text];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't post right now, make sure                                   your device has an internet connection and you have                                   at least one Facebook account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


@end
