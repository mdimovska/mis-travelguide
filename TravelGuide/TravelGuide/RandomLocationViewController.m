//
//  RandomLocationViewController.m
//  TravelGuide
//
//  Created by Milena Dimovska on 6/7/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import "RandomLocationViewController.h"
#import "PlaceDetailsViewController.h"

@interface RandomLocationViewController ()

@end

@implementation RandomLocationViewController
@synthesize  categoryIDs;
@synthesize imageViewLocation;
@synthesize labelLocationName;
@synthesize latitude;
@synthesize longitude;
@synthesize  responseArray;
@synthesize responseData;
@synthesize responseArrayImage;
@synthesize responseDataImage;
@synthesize randomLocationModel;
@synthesize isSecondRequest;
@synthesize viewInfo;

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
    
    categoryIDs=[[NSArray alloc]initWithObjects:@"4d4b7104d754a06370d81259",@"4d4b7105d754a06374d81259",@"4d4b7105d754a06376d81259",@"4d4b7105d754a06377d81259",@"4d4b7105d754a06378d81259", @"4d4b7105d754a06379d81259", nil];
    
    labelLocationName.text=@"";
  
    [self getRandomLocationFromUrl];
    
       //navigation bar style (transparent navigation bar)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor  clearColor];
}

-(void)getRandomLocationFromUrl{
    isSecondRequest=false;
    
    //  random number (for getting random category)
    int rand = arc4random() % [categoryIDs count];
    
    //get location from prefs
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary= [prefs dictionaryForKey:@"latitudeLongitudePrefs"];
    
    latitude=dictionary[@"lat"];
    longitude=dictionary[@"lng"];
    
    //formated url with categoryId from the previous page
    NSString *url=   [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?client_id=5V0A4GCWI2BDB5LIA1OEJW4DOH3NVFPUVIVW4CWMCH0ZWZXU&client_secret=02U2I0PBBOOLOLWCPSKER3RVRJZRCNW0CLSZUYUHSKDUGHCV&ll=%@,%@&categoryId=%@&v=20140603", latitude,longitude,[categoryIDs objectAtIndex: rand]];
    
    responseArray = [[NSArray alloc] init];
    responseData = [NSMutableData data];
    responseArrayImage = [[NSArray alloc] init];
    responseDataImage = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    if(isSecondRequest)
          [responseDataImage setLength:0];
        else
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(isSecondRequest)
        [responseDataImage appendData:data];
    else
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    
    // convert to JSON
    NSError *myError = nil;
 
    
    if(isSecondRequest){
        //get imageUrl
           NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseDataImage options:NSJSONReadingMutableLeaves error:&myError];
        responseArrayImage= res[@"response"][@"photos"][@"items"];
        
        if([responseArrayImage count]>0)
        {
            //get first image
            NSDictionary *result =[responseArrayImage objectAtIndex: 0];
        
            NSString *imageUrl=[NSString stringWithFormat:@"%@300x500%@",result[@"prefix"], result[@"suffix"]];
            NSLog(imageUrl);
        
            if(imageUrl != nil){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSURL *imageURL = [NSURL URLWithString:imageUrl];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
                dispatch_async(dispatch_get_main_queue(), ^{
                imageViewLocation.image = [UIImage imageWithData:imageData];
                labelLocationName.text=[randomLocationModel objectAtIndex:0];
                viewInfo.hidden=NO;
            });
            });
            }
        }
        isSecondRequest=false;
    }else{
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    NSArray *groupsArray = res[@"response"][@"groups"];
    responseArray= [groupsArray objectAtIndex: 0][@"items"];
    
    ///get random item and fill view with data
        if([responseArray count] >0){
    int rand = arc4random() % [responseArray count];

    NSDictionary *result =[responseArray objectAtIndex: rand];
    
    NSString *name=@"";
    NSString *distance=@"";
    NSString *category=@"";
    NSString *address=@"";
    NSString *country=@"";
    NSString *lat=@"";
    NSString *lng=@"";
    NSString *placeId=@"";
    NSString *likes=@"0";
    NSString *rating=@"";
    NSString *tips=@"";
    NSString *venueUrl=@"";
    
    if( result[@"venue"][@"name"] != nil)
        name= result[@"venue"][@"name"];
    if( [NSString stringWithFormat:@" %@ m", result[@"venue"][@"location"][@"distance"]] !=nil)
        distance= [NSString stringWithFormat:@" %@ m", result[@"venue"][@"location"][@"distance"]];
    if(  [result[@"venue"][@"categories"] objectAtIndex: 0][@"name"] != nil)
        category=  [result[@"venue"][@"categories"] objectAtIndex: 0][@"name"];
    if(result[@"venue"][@"location"][@"address"] != NULL)
        if(result[@"venue"][@"location"][@"address"] != nil)
            address=result[@"venue"][@"location"][@"address"];
    if( result[@"venue"][@"location"][@"city"] != NULL)
        if( [NSString stringWithFormat:@" %@", result[@"venue"][@"location"][@"city"]] != nil)
            country=  [NSString stringWithFormat:@" %@", result[@"venue"][@"location"][@"city"]];
    if( result[@"venue"][@"location"][@"lat"] != nil)
        lat=  result[@"venue"][@"location"][@"lat"];
    if( result[@"venue"][@"location"][@"lng"] != nil)
        lng= result[@"venue"][@"location"][@"lng"];
    if( result[@"venue"][@"id"] != nil)
        placeId= result[@"venue"][@"id"];
    if(  result[@"venue"][@"likes"][@"count"] != nil)
        likes=  [result[@"venue"][@"likes"][@"count"] stringValue];
    if(  result[@"venue"][@"rating"] != nil)
        rating=  [result[@"venue"][@"rating"] stringValue];
    if(  [result[@"tips"]objectAtIndex: 0][@"text"] != nil)
        tips=  [result[@"tips"]objectAtIndex: 0][@"text"];
    if(  result[@"venue"][@"url"] != NULL)
         venueUrl = result[@"venue"][@"url"];

    
    randomLocationModel = [[NSArray alloc]
                                             initWithObjects:
                                             name,
                                             distance,
                                             category,
                                             address,
                                             country,
                                             lat,
                                             lng,
                                             placeId,
                                             likes,
                                             rating,
                                             tips,
                                           venueUrl,
                                             nil];
    
    //second request to retrieve image url
        
        isSecondRequest=true;
        
       //photo url
        NSString *url=   [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@/photos?client_id=5V0A4GCWI2BDB5LIA1OEJW4DOH3NVFPUVIVW4CWMCH0ZWZXU&client_secret=02U2I0PBBOOLOLWCPSKER3RVRJZRCNW0CLSZUYUHSKDUGHCV&v=20140603", placeId];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:
                                 [NSURL URLWithString:url]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}


-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        // User was shaking the device
        NSLog(@"SHAKE");
        //another request for random location
        [self getRandomLocationFromUrl];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)shakeSuccess
{
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowRandomLocationDetails"])
    {
        PlaceDetailsViewController *detailViewController =  [segue destinationViewController] ;
        detailViewController.placeDetailModel = [[NSArray alloc]initWithArray:randomLocationModel];
    }
}

@end
