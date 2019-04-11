//
//  ViewController.h
//  Lesson24Task1
//
//  Created by Анастасия Распутняк on 09.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARDrawView;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet ARDrawView *drawView;
@property (weak, nonatomic) IBOutlet UIView *settingsPanel;


@end

