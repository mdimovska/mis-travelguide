//
//  MenuViewController.m
//

#import "MenuViewController.h"
#import "CategoryDetailsViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize textArray;
@synthesize imagesArray;

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
    self.textArray=[[NSArray alloc]initWithObjects:@"Random location",@"Favourites", nil];
    self.imagesArray=[[NSArray alloc]initWithObjects:@"icon_help", @"icon_star.png", nil];

}

#pragma mark - Table view stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [textArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    cell.textLabel.text = [self.textArray objectAtIndex: [indexPath row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image=[UIImage imageNamed:[self.imagesArray objectAtIndex: [indexPath row]]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Heiti TC Light 18.0" size:18]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     if([indexPath row]==0)
      [self performSegueWithIdentifier: @"ShowRandom" sender: self];
     else  if([indexPath row]==1)
      [self performSegueWithIdentifier: @"ShowFavourites" sender: self];
 }

- (void)viewWillAppear:(BOOL)animated {
 // [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowRandom"])
    {
    }else  if ([[segue identifier] isEqualToString:@"ShowFavourites"])
    {
    }
}
*/

@end
