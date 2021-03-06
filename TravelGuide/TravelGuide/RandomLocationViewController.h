//
//  RandomLocationViewController.h
//  TravelGuide
//
//  Created by Milena Dimovska on 6/7/14.
//  Copyright (c) 2014 TravelGuide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandomLocationViewController : UIViewController

@property (nonatomic, strong) NSArray *categoryIDs;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewLocation;
@property (strong, nonatomic) IBOutlet UILabel *labelLocationName;
@property (strong, nonatomic) IBOutlet UIView *viewInfo;

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSArray *responseArray;
@property (nonatomic, strong) NSMutableData *responseDataImage;
@property (nonatomic, strong) NSArray *responseArrayImage;
@property (nonatomic, strong) NSArray *randomLocationModel;

@property (atomic, strong) NSString *latitude;
@property (atomic, strong) NSString *longitude;

@property bool isSecondRequest;

@end
