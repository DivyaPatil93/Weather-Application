//
//  ViewController.m
//  DPWeatherApp
//
//  Created by Mrunalini on 18/10/16.
//  Copyright © 2016 Divya Patil. All rights reserved.
//

#import "ViewController.h"
#import "ForecastTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   // days = @[@"Sun",@"Mon",@"Tues",@"Wed",@"Thurs",@"Fri",@"Sun"];
    
    forecast = [[NSMutableArray alloc]init];
    self.myTableView.backgroundColor = [UIColor clearColor];
    
//    [self startLocating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startLocating {
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"Latitude : %f",currentLocation.coordinate.latitude);
    
    NSLog(@"Longitude : %f",currentLocation.coordinate.longitude);
    
    kLatitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    
    kLongitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    
    
    if (currentLocation != nil) {
        
        [locationManager stopUpdatingLocation];
    }

    [self getCurrentWeatherDataWithLatitude:kLatitude.doubleValue longitude:kLongitude.doubleValue APIKey:kWeatherAPIKey];
    
    [self getForecastDataWithLatitude:kLatitude.doubleValue longitude:kLongitude.doubleValue APIKey:kWeatherAPIKey];
}
-(void)updateUIWithForecastDictionary:(NSDictionary *)forecastDictionary {
    
    //NSLog(@"%@",forecastDictionary);
    
    NSArray *list = [forecastDictionary valueForKey:@"list"];
    
    for (NSDictionary *weatherDetail in list) {
        
        //NSLog(@"%@",weatherDetail);
        NSString *dt = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"dt"]];
        
        NSString *maximum = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"temp.max"]];
        maximum = [NSString stringWithFormat:@"MAXIMUM : %d °C",maximum.intValue];
        
        NSString *minimum = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"temp.min"]];
        minimum = [NSString stringWithFormat:@"MINIMUM : %d °C",minimum.intValue];
        
        NSDictionary *tempDictionary = @{
                                         @"maximum" : maximum,
                                         @"minimum" : minimum,
                                         @"dt"      : dt
                                         };
        
        NSLog(@"%@",tempDictionary);
        
        [forecast addObject:tempDictionary];
        

    }
    
    if (forecast.count > 0) {
        [self.myTableView reloadData];
    }
}
-(void)getForecastDataWithLatitude:(double)latitude
                         longitude:(double)longitude
                            APIKey:(NSString *)key {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=7&mode=json&appid=%@&units=metric",latitude,longitude,key];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //alert
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        //start json parsing
                        
                        
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        if (error) {
                            //alert
                        }
                        else{
                            
                            [self performSelectorOnMainThread:@selector(updateUIWithForecastDictionary:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                    else {
                        //alert
                    }
                }
                else {
                    //alert
                }
            }
            else {
                //alert
            }
        }
    }];
    
    [task resume];
}

-(void)getCurrentWeatherDataWithLatitude:(double)latitude
                               longitude:(double)longitude
                                  APIKey:(NSString *)key {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@&units=metric",latitude,longitude,key];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            //alert
        }
        else {
            if (response) {
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                
                if (httpResponse.statusCode == 200) {
                    
                    if (data) {
                        //start json parsing
                        
                        
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        
                        if (error) {
                            //alert
                        }
                        else{
                            
                            [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                    else {
                        //alert
                    }
                }
                else {
                    //alert
                }
            }
            else {
                //alert
            }
        }
    }];
    
    [task resume];
}

-(void)updateUI:(NSDictionary *)resultDictionary {
    
    NSLog(@"%@",resultDictionary);
    
    NSString *temperature = [NSString stringWithFormat:@"%@",[resultDictionary valueForKeyPath:@"main.temp"]];
    
    NSLog(@"\n\nTEMPERATURE BEFORE : %@",temperature);
    
    int temp = temperature.intValue;
    
    temperature = [NSString stringWithFormat:@"%d °C",temp];
    
    
    NSLog(@"\n\nTEMPERATURE AFTER: %@",temperature);
    
    NSArray *weather = [resultDictionary valueForKey:@"weather"];
    
    NSLog(@"%@",weather);
    
    NSDictionary *weatherDictionary = weather.firstObject;
    
    
    NSString *condition = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
    
    NSLog(@"%@",condition);
    
    
    NSString *city = [NSString stringWithFormat:@"%@",[resultDictionary valueForKey:@"name"]];
    
    self.labelCity.text = city;
    self.labelCondition.text = condition.capitalizedString;
    self.labelTemperature.text = temperature;
}


- (IBAction)startCurrentWeatherAction:(id)sender {
    
    [self startLocating];
    //[locationManager startUpdatingLocation];
   
}

-(NSInteger)numberOfSectionInTableView:(UITableView *)tableView {
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return forecast.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  //  ForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forecast_cast"];
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    NSDictionary *tempDictionary = [forecast objectAtIndex:indexPath.row];
    
    //cell.labelDay.text = [tempDictionary valueForKey:@"dt"];
   // cell.labelMaximum.text = [tempDictionary valueForKey:@"maximum"];
    //cell.labelMiniimum.text = [tempDictionary valueForKey:@"minimum"];
    // [tabelView setBounces:NO];
    
    [tableView setSeparatorColor:[UIColor clearColor]];
    
    NSString *dt = [tempDictionary valueForKey:@"dt"];
    
    NSLog(@"%@",dt);
    
    NSTimeInterval time = dt.doubleValue;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"%@",date);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
   // [dateFormatter setLocale:[NSLocale currentLocale]];
  //  [dateFormatter setDateFormat:@"EEEE"];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy HH:mm a Z EEEE"];
    
    NSString *day = [dateFormatter stringFromDate:date];
    
    NSLog(@"%@",day);
    
   // UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

    cell.textLabel.text = day;
    cell.detailTextLabel.text = [[[tempDictionary valueForKey:@"maximum"] stringByAppendingString:@" "]stringByAppendingString:[tempDictionary valueForKey:@"minimum"]];
    tableView.backgroundColor = [UIColor clearColor];
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView.frame.size.height/7;
}
@end
