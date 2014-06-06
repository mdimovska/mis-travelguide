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
@synthesize nameLabel;
@synthesize distanceLabel;
@synthesize  categoryLabel;
@synthesize addressLabel;
@synthesize  countryLabel;
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
    name=[self.placeDetailModel objectAtIndex:0];
    distance=[self.placeDetailModel objectAtIndex:1];
    category=[self.placeDetailModel objectAtIndex:2];
    address=[self.placeDetailModel objectAtIndex:3];
    country=[self.placeDetailModel objectAtIndex:4];
    lat=[self.placeDetailModel objectAtIndex:5];
    lng=[self.placeDetailModel objectAtIndex:6];
    placeId=[self.placeDetailModel objectAtIndex:7];
    likes=[self.placeDetailModel objectAtIndex:8];
    rating=[self.placeDetailModel objectAtIndex:9];
     tips=[self.placeDetailModel objectAtIndex:10];
    
    nameLabel.text = name;
    distanceLabel.text = distance;
    categoryLabel.text = category;
    //self.addressLabel.text = address;
   // self.countryLabel.text = country;
    addressLabel.text = rating;
    countryLabel.text = likes;
    tipsLabel.text=tips;
    
    //transparent navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.view.tintColor=[UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"";
    
    // [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    /*
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"";
    backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backButton;
    
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    */
    
    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude = [lat doubleValue];
    centerCoordinate.longitude = [lng doubleValue];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {centerCoordinate, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:centerCoordinate];
     [annotation setTitle: [NSString stringWithFormat:@"%@",address]];
    [annotation setSubtitle:[NSString stringWithFormat:@"%@",country]];

    
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
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Place is added to favourites!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"This place is already in your favourites list!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
@end
