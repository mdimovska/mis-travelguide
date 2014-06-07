//
//  CategoryDetailsViewController.h
//  TravelGuide
//
//  Created by Goran Kopevski on 6/4/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import "ViewController.h"

@interface CategoryDetailsViewController : UITableViewController

@property (strong, nonatomic) NSArray *categoryDetailModel;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSArray *responseArray;

@end
