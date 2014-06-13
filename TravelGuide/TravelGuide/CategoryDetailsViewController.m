//
//  CategoryDetailsViewController.m
//  TravelGuide
//
//  Created by Milena Dimovska on 6/4/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import "CategoryDetailsViewController.h"
#import "PlacesTableViewCell.h"
#import "PlaceDetailsViewController.h"

@interface CategoryDetailsViewController ()

@end

@implementation CategoryDetailsViewController


@synthesize categoryDetailModel ;
@synthesize responseData ;
@synthesize responseArray;

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
   
    NSString *categoryName=[categoryDetailModel objectAtIndex:1];
    NSString *lat=[categoryDetailModel objectAtIndex:2];
    NSString * lng= [categoryDetailModel objectAtIndex:3];
    
    
    //formated url with categoryId from the previous page
    NSString *url=   [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?client_id=5V0A4GCWI2BDB5LIA1OEJW4DOH3NVFPUVIVW4CWMCH0ZWZXU&client_secret=02U2I0PBBOOLOLWCPSKER3RVRJZRCNW0CLSZUYUHSKDUGHCV&ll=%@,%@&categoryId=%@&v=20140603", lat,lng,[categoryDetailModel objectAtIndex:0]];
    
    responseArray = [[NSArray alloc] init];
    
    responseData = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:url]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
   
    //navigation bar style (transparent navigation bar)
     [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
     forBarMetrics:UIBarMetricsDefault];
     self.navigationController.navigationBar.shadowImage = [UIImage new];
     self.navigationController.navigationBar.translucent = YES;
     
    self.navigationController.navigationBar.backgroundColor = [UIColor  colorWithRed:((float) 43 / 255.0f)
                                                                               green:((float) 62 / 255.0f)
                                                                                blue:((float) 80/ 255.0f)
                                                                               alpha:0.8];
    //set white title of view
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor  whiteColor] forKey:NSForegroundColorAttributeName];

 }

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
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
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    
  NSArray *groupsArray = res[@"response"][@"groups"];
    
    responseArray= [groupsArray objectAtIndex: 0][@"items"];
    
     [self.tableView reloadData];
 }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowPlaceDetails"])
    {
        PlaceDetailsViewController *detailViewController =
        [segue destinationViewController];
        
        NSIndexPath *myIndexPath = [self.tableView
                                    indexPathForSelectedRow];
        
        NSDictionary *result =[responseArray objectAtIndex: [myIndexPath row]];
       
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
        
        
        detailViewController.placeDetailModel = [[NSArray alloc]
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
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [responseArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"placesTableCell";
    
    PlacesTableViewCell *cell = [tableView
                                   dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PlacesTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    NSDictionary *result =[responseArray objectAtIndex: [indexPath row]];
    
    cell.placeNameLabel.text = result[@"venue"][@"name"];
    cell.placeDistanceLabel.text =  [NSString stringWithFormat:@" %@ m", result[@"venue"][@"location"][@"distance"]];
    cell.placeLocationLabel.text = [result[@"venue"][@"categories"] objectAtIndex: 0][@"name"];    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
    NSLog([categoryDetailModel objectAtIndex:1]);
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor  colorWithRed:((float) 43 / 255.0f)
                                                                              green:((float) 62 / 255.0f)
                                                                               blue:((float) 80/ 255.0f)
                                                                              alpha:0.8];
    //set white title of view
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor  whiteColor] forKey:NSForegroundColorAttributeName];
    [self setTitle:@""];
    self.title=[categoryDetailModel objectAtIndex:1];
}

@end
