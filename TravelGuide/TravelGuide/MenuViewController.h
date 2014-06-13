//
//  MenuViewController.h
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *textArray;

@end
