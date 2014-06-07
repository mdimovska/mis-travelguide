//
//  FavouritesTableViewController.m
//  TravelGuide
//
//  Created by Goran Kopevski on 6/6/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import "FavouritesTableViewController.h"
#import "PlacesTableViewCell.h"
#import "PlaceDetailsViewController.h"

@interface FavouritesTableViewController ()

@end

@implementation FavouritesTableViewController
@synthesize  favouritesArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    favouritesArray=[[NSMutableArray alloc] init];
    
    //read back data:
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    favouritesArray = [prefs mutableArrayValueForKey:@"favouritesArray"];
    
    //navigation bar style (transparent navigation bar)
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

}
    

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    // Return the number of rows in the section.
    return [favouritesArray count];
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
    NSMutableDictionary *result =[self.favouritesArray objectAtIndex: [indexPath row]];
    
    cell.placeNameLabel.text = result[@"name"];
    cell.placeLocationLabel.text = result[@"category"];
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // the item should be deleted in NSUserDefaults too!
          [favouritesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:favouritesArray forKey:@"favouritesArray"];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
        
        NSMutableDictionary *result =[favouritesArray objectAtIndex: [myIndexPath row]];
        
        //we won't need to worry whether it's nil or not... (it's checked in categoryDetailsViewController before it's passed to PlaceDetailsViewController)
        NSString *name=  result[@"name"];
        NSString *distance= result[@"distance"];
        NSString *category= result[@"category"];
        NSString *address= result[@"address"];
        NSString *country= result[@"country"];
        NSString *lat= result[@"lat"];
        NSString *lng= result[@"lng"];
        NSString *placeId= result[@"placeId"];
        NSString *likes= result[@"likes"];
        NSString *rating= result[@"rating"];
        NSString *tips= result[@"tips"];
        
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
                                                 nil];
        
    }

}



- (void)viewWillAppear:(BOOL)animated {
    //navigation bar style (transparent navigation bar)
    self.navigationController.navigationBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

@end
