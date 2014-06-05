//
//  CategoryTableViewCell.h
//  TravelGuide
//
//  Created by Goran Kopevski on 6/4/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *categoryImage;
@property (nonatomic, strong) IBOutlet UILabel *categoryNameLabel;

@end
