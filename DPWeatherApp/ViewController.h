//
//  ViewController.h
//  DPWeatherApp
//
//  Created by Mrunalini on 18/10/16.
//  Copyright © 2016 Divya Patil. All rights reserved.
//
#define kWeatherAPIKey @"348c1a58f6d8d2bd370fb851f8b957cb"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *locationManager;
    NSString *kLatitude;
    NSString *kLongitude;
    NSMutableArray *forecast;
}

@property (weak, nonatomic) IBOutlet UILabel *labelCity;
@property (weak, nonatomic) IBOutlet UILabel *labelTemperature;
@property (weak, nonatomic) IBOutlet UILabel *labelCondition;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)startCurrentWeatherAction:(id)sender;

@end

