//
//  ForecastTableViewCell.h
//  DPWeatherApp
//
//  Created by Mrunalini on 20/10/16.
//  Copyright © 2016 Divya Patil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelDay;

@property (weak, nonatomic) IBOutlet UILabel *labelMaximum;
@property (weak, nonatomic) IBOutlet UILabel *labelMinimum;


@end
