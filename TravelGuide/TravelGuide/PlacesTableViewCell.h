//
//  PlacesTableViewCell.h
//  TravelGuide
//
//  Created by Goran Kopevski on 6/4/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *placeNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *placeLocationLabel;
@property (nonatomic, strong) IBOutlet UILabel *placeDistanceLabel;

@end
