//
//  ViewController.h
//  Lesson37Task
//
//  Created by Анастасия Распутняк on 06.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *infoView;

- (IBAction)actionShowAll:(UIBarButtonItem *)sender;
- (IBAction)actionAddMeetPoint:(UIBarButtonItem *)sender;

@end

