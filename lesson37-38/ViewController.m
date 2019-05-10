//
//  ViewController.m
//  Lesson37Task
//
//  Created by Анастасия Распутняк on 06.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"
#import "ARStudent.h"
#import "ARStudentInfoTVController.h"
#import "UIView+MKAnnotationView.h"
#import "ARMapAnnotation.h"

typedef enum {
    ARCircleRadiusSmall = 3,
    ARCircleRadiusMedium = 5,
    ARCircleRadiusBig = 8
} ARCircleRadius;

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate,
                              UIPopoverPresentationControllerDelegate, ARStudentInfoDelegate>
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLLocation* location;

@property (strong, nonatomic) NSMutableArray* students;
@property (strong, nonatomic) ARStudent* currentStudent;
@property (strong, nonatomic) ARMapAnnotation* meetPoint;

@property (assign, nonatomic) int studentsInSmall;
@property (assign, nonatomic) int studentsInMedium;
@property (assign, nonatomic) int studentsInBig;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    srand48(time(0));
    self.mapView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    self.students = [NSMutableArray array];
    for (int i = 0; i < 15; i++) {
        ARStudent* student = [ARStudent randomStudent];
        
        [self.students addObject:student];
        [self.mapView addAnnotation:student];
    }
    
    self.infoView.layer.cornerRadius = 10;
    NSArray* labels = self.infoView.subviews;
    for (UILabel* label in labels) {
        switch (label.tag) {
            case 0:
                label.tag = ARCircleRadiusSmall;
                break;
                
            case 1:
                label.tag = ARCircleRadiusMedium;
                break;
                
            case 2:
                label.tag = ARCircleRadiusBig;
                break;
                
            default:
                break;
        }
        
        label.textColor = [UIColor colorWithRed:10 / 255.f green:132 / 255.f blue:255 / 255.f alpha:1.f];
        label.text = [self formateLabelTextWithNumber:-1
                                            forRadius:label.tag];
    }
}

#pragma mark - Actions -

- (IBAction)actionShowAll:(UIBarButtonItem *)sender {
    static double delta = 20000;
    
    MKMapRect zoomRect = MKMapRectNull;
    
    for (id <MKAnnotation> annotation in self.students) {
        CLLocationCoordinate2D location = annotation.coordinate;
        MKMapPoint centre = MKMapPointForCoordinate(location);
        MKMapRect rect = MKMapRectMake(centre.x - delta, centre.y - delta, 2 * delta, 2 * delta);
        zoomRect = MKMapRectUnion(zoomRect, rect);
    }
    
    zoomRect = [self.mapView mapRectThatFits:zoomRect];
    [self.mapView setVisibleMapRect:zoomRect
                        edgePadding:UIEdgeInsetsMake(20, 20, 20, 20)
                           animated:YES];
}

- (IBAction)actionAddMeetPoint:(UIBarButtonItem *)sender {
    if (!self.meetPoint) {
        ARMapAnnotation* annotation = [[ARMapAnnotation alloc] init];
        
        annotation.subtitle = @"Click + to get routes";
        annotation.coordinate = self.mapView.region.center;
        annotation.location = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude
                                                         longitude:annotation.coordinate.longitude];
        
        CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:annotation.location
                       completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                           NSString* adress = nil;
                           if (error) {
                               adress = @"Error getting adress.";
                           } else {
                               CLPlacemark* placemark = [placemarks firstObject];
                               adress = [NSString stringWithFormat:@"%@, %@",
                                                                placemark.thoroughfare,
                                                                placemark.subThoroughfare];
                           }
                           
                           annotation.title = adress;
                       }];
        
        self.meetPoint = annotation;
        [self.mapView addAnnotation:annotation];
        
        [self createCircles:annotation.coordinate];
        
        self.studentsInSmall = 0;
        self.studentsInMedium = 0;
        self.studentsInBig = 0;
        [self calculateDistance];
        
    } else {
        UIAlertController* meetPointAlert = [UIAlertController alertControllerWithTitle:@"Pin is already on the map"
                                                                                message:@"Drag it to change the meet place <3"
                                                                         preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        
        [meetPointAlert addAction:actionOK];
        [self presentViewController:meetPointAlert animated:YES completion:nil];
    }
}

- (void)actionInfo:(UIButton*)button {
    MKAnnotationView* currentView = [button superAnnotationView];
    if (!currentView) return;
    self.currentStudent = (ARStudent*)currentView.annotation;
    
    ARStudentInfoTVController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARStudentInfoTVController"];
    infoController.delegate = self;
    
    infoController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:infoController
                       animated:YES
                     completion:nil];
    
    UIPopoverPresentationController *popController = [infoController popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.sourceView = button;
    popController.delegate = self;
}

- (void)actionGetRoutes:(UIButton*)button {
    
    if ([self.mapView.overlays count] == 3) {
        for (ARStudent* student in self.students) {
            if (drand48() > 0.5) {
                
                MKDirectionsRequest* directionRequest = [[MKDirectionsRequest alloc]init];
                [directionRequest setSource:[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:student.coordinate]]];
                [directionRequest setDestination:[[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.meetPoint.coordinate]]];
                [directionRequest setTransportType:MKDirectionsTransportTypeAutomobile];
                
                MKDirections* directions = [[MKDirections alloc] initWithRequest:directionRequest];
                
                [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
                    if (!error) {
                        MKRoute* firstOne = response.routes.firstObject;
                        [self.mapView addOverlay:firstOne.polyline level:MKOverlayLevelAboveRoads];
                        
                        MKMapRect rect = [firstOne.polyline boundingMapRect];
                        [self.mapView setRegion:MKCoordinateRegionForMapRect(rect) animated:YES];
                    } else {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                }];
                
            }
        }
    }
    
}

#pragma mark - MKMapViewDelegate -

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString* studentId = @"studentAnnotation";
    static NSString* pinId = @"pinAnnotation";
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else if ([annotation isKindOfClass:[ARMapAnnotation class]]) {
        MKPinAnnotationView* pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pinId];
        
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:pinId];
            
            pinView.pinTintColor = [MKPinAnnotationView purplePinColor];
            pinView.animatesDrop = YES;
            pinView.draggable = YES;
            pinView.canShowCallout = YES;
            
            UIButton* routeButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
            [routeButton addTarget:self
                           action:@selector(actionGetRoutes:)
                 forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = routeButton;
            
        } else {
            pinView.annotation = annotation;
        }
        
        return pinView;
        
    } else {
        ARStudent* stAnnotation = (ARStudent*)annotation;
        MKAnnotationView* annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:studentId];
        
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:stAnnotation
                                                          reuseIdentifier:studentId];
            
            annotationView.image = stAnnotation.image;
            annotationView.canShowCallout = YES;
            
            UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
            [infoButton addTarget:self
                           action:@selector(actionInfo:)
                 forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = infoButton;
            
        } else {
            annotationView.annotation = stAnnotation;
        }
        
        return annotationView;
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {

    if ([overlay isKindOfClass:[MKCircle class]]) {
        UIColor* circleColor = [UIColor colorWithRed:50.f / 255
                                               green:148.f / 255
                                                blue:166.f / 255
                                               alpha:1.f];

        MKCircleRenderer* circleRenderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
        circleRenderer.fillColor = [circleColor colorWithAlphaComponent:0.1f];
        return circleRenderer;
    }
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer* polylineRenderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRenderer.strokeColor = [self randomColour];
        polylineRenderer.lineWidth = 5;
        return polylineRenderer;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState {
    if ([view.annotation isEqual:self.meetPoint] && newState == MKAnnotationViewDragStateEnding) {
        self.meetPoint.location = [[CLLocation alloc] initWithLatitude:self.meetPoint.coordinate.latitude
                                                             longitude:self.meetPoint.coordinate.longitude];
        
        NSArray* overlays = [self.mapView overlays];
        [self.mapView removeOverlays:overlays];
        
        [self createCircles:self.meetPoint.coordinate];
        
        self.studentsInSmall = 0;
        self.studentsInMedium = 0;
        self.studentsInBig = 0;
        [self calculateDistance];
        
    }
    
}

#pragma mark - ARStudentInfoDelegate -

- (void)insertStudentInfo:(ARStudentInfoTVController*)controller {
    
    controller.firstNameLabel.text = self.currentStudent.firstName;
    controller.lastNameLabel.text = self.currentStudent.lastName;
    controller.birthDateLabel.text = self.currentStudent.birthDate;
    controller.genderLabel.text = self.currentStudent.gender == ARStudentGenderFemale ? @"female" : @"male";
    
    CLLocationCoordinate2D coordinate = self.currentStudent.coordinate;
    CLLocation* location = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                      longitude:coordinate.longitude];
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                       NSString* adress = nil;
                       if (error) {
                           adress = @"Error getting adress.";
                       } else {
                           CLPlacemark* placemark = [placemarks firstObject];
                           adress = [NSString stringWithFormat:@"country: %@,\ncity: %@,\nstreet: %@, %@",
                                                                placemark.country,
                                                                placemark.locality,
                                                                placemark.thoroughfare,
                                                                placemark.subThoroughfare];
                       }
                       
                       controller.adressText.text = adress;
                   }];
    
}

#pragma mark - CLLocationManagerDelegate -

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.location = locations.lastObject;
}

#pragma mark - Additional methods -

- (void)createCircles:(CLLocationCoordinate2D)center {
    
    MKCircle* smallCircle = [MKCircle circleWithCenterCoordinate:center
                                                          radius:ARCircleRadiusSmall * 1000];
    MKCircle* mediumCircle = [MKCircle circleWithCenterCoordinate:center
                                                           radius:ARCircleRadiusMedium * 1000];
    MKCircle* bigCircle = [MKCircle circleWithCenterCoordinate:center
                                                        radius:ARCircleRadiusBig * 1000];
    
    [self.mapView addOverlay:smallCircle];
    [self.mapView addOverlay:mediumCircle];
    [self.mapView addOverlay:bigCircle];
    
}

- (NSString*)formateLabelTextWithNumber:(NSInteger)number forRadius:(NSInteger)radius {
    NSString* mainString = [NSString stringWithFormat:@"Students in radius %ldkm: ", (long)radius];
    
    if (number < 0) {
        return [mainString stringByAppendingString:@"-"];
    } else {
        return [mainString stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)number]];
    }
    
}

- (void)calculateDistance {
    for (ARStudent* student in self.students) {
        
        CLLocationDistance dist = [student.location distanceFromLocation:self.meetPoint.location];
        
        if (dist < ARCircleRadiusBig * 1000) {
            self.studentsInBig++;
            
            if (dist < ARCircleRadiusMedium * 1000) {
                self.studentsInMedium++;
                
                if (dist < ARCircleRadiusSmall * 1000) {
                    self.studentsInSmall++;
                }
            }
        }
    }
    
    NSArray* labels = self.infoView.subviews;
    for (UILabel* label in labels) {
        switch (label.tag) {
            case ARCircleRadiusSmall:
                label.text = [self formateLabelTextWithNumber:self.studentsInSmall
                                                    forRadius:label.tag];
                break;
                
            case ARCircleRadiusMedium:
                label.text = [self formateLabelTextWithNumber:self.studentsInMedium
                                                    forRadius:label.tag];
                break;
                
            case ARCircleRadiusBig:
                label.text = [self formateLabelTextWithNumber:self.studentsInBig
                                                    forRadius:label.tag];
                break;
                
            default:
                break;
        }

    }
}

- (UIColor*) randomColour {
    int r = arc4random_uniform(256);
    int g = arc4random_uniform(256);
    int b = arc4random_uniform(256);
    UIColor* colour = [[UIColor alloc]initWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
    return colour;
}


@end
