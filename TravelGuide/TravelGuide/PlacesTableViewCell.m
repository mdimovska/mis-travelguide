//
//  PlacesTableViewCell.m
//  TravelGuide
//
//  Created by Goran Kopevski on 6/4/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import "PlacesTableViewCell.h"

@implementation PlacesTableViewCell

@synthesize placeNameLabel=_placeNameLabel;
@synthesize placeDistanceLabel=_placeDistanceLabel;
@synthesize placeLocationLabel=_placeLocationLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
