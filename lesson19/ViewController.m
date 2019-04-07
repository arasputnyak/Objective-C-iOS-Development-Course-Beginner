//
//  ViewController.m
//  Lesson19Task
//
//  Created by Анастасия Распутняк on 02.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    ARViewTypeCell,
    ARViewTypeCheckerWhite,
    ARViewTypeCheckerBlack
} ARViewType;

@interface ViewController ()
@property (strong, nonatomic) UIColor* darkCellColour;
@property (weak, nonatomic) UIView* chessboard;
@property (strong, nonatomic) NSMutableArray* chessboardViews;

- (void) shuffleCheckers;
- (UIColor*) randomColour;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIColor* colour = [[UIColor alloc]initWithRed:128.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.darkCellColour = colour;  // default
    self.chessboardViews = [[NSMutableArray alloc] init];
    
    float screenWidth = CGRectGetWidth(self.view.frame);
    float screenHeight = CGRectGetHeight(self.view.frame);
    UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0, (screenHeight - screenWidth) / 2, screenWidth, screenWidth)];
    border.backgroundColor = colour;
    [self.view addSubview:border];
    
    border.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    int cellWidth = (int)(screenWidth / 8);
    int boardWidth = cellWidth * 8;
    int indent = (int)((screenWidth - boardWidth) / 2);
    UIView* chessboard = [[UIView alloc] initWithFrame:CGRectMake(indent, indent, boardWidth, boardWidth)];
    chessboard.backgroundColor = [UIColor whiteColor];
    [border addSubview:chessboard];
    self.chessboard = chessboard;
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, boardWidth / 2 + indent, screenWidth, 1)];
    line.backgroundColor = colour;
    [border addSubview:line];
    
    int checkerIndent = 4;
    int checkerWidth = cellWidth - checkerIndent * 2;
    
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            int y = j * cellWidth;
            if (j > 3) y += 1;  // для сдвига из-за line-view
            UIView* cell = [[UIView alloc] initWithFrame:CGRectMake(i * cellWidth, y, cellWidth, cellWidth)];
            cell.tag = ARViewTypeCell;
            
            cell.backgroundColor = i % 2 == j % 2 ? self.darkCellColour : [UIColor whiteColor];
            
            [chessboard addSubview:cell];
            [self.chessboardViews addObject:cell];
            
            if ([cell.backgroundColor isEqual:self.darkCellColour] && j != 3 && j != 4) {
                UIView* checker = [[UIView alloc] initWithFrame:CGRectMake(i * cellWidth + checkerIndent, y + checkerIndent,
                                                                           checkerWidth, checkerWidth)];
                
                if (j < 3) {
                    checker.backgroundColor = [UIColor whiteColor];
                    checker.tag = ARViewTypeCheckerWhite;
                } else {
                    checker.backgroundColor = [UIColor blackColor];
                    checker.tag = ARViewTypeCheckerBlack;
                }
                checker.layer.cornerRadius = 19;
                checker.layer.masksToBounds = true;
                [chessboard addSubview:checker];
                
                [self.chessboardViews addObject:checker];
            }
        }
    }
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        // do whatever

        self.darkCellColour = [self randomColour];
        
        for (UIView* someView in self.chessboardViews) {
            if (someView.tag == ARViewTypeCell &&
                ![someView.backgroundColor isEqual:[UIColor whiteColor]]) {
                
                someView.backgroundColor = self.darkCellColour;
            }
        }
        
        [self shuffleCheckers];
        
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void) shuffleCheckers {
    for (int i = 0; i < [self.chessboardViews count]; i++) {
        UIView* someView = [self.chessboardViews objectAtIndex:i];
        
        if (someView.tag == ARViewTypeCheckerWhite) {
            while (YES) {
                int rnd = arc4random() % [self.chessboardViews count];
                UIView* someViewExchange = [self.chessboardViews objectAtIndex:rnd];
                if (![someViewExchange isEqual:someView] && someViewExchange.tag == ARViewTypeCheckerBlack) {
                    CGRect frame = someViewExchange.frame;
                    someViewExchange.frame = CGRectMake(someView.frame.origin.x, someView.frame.origin.y,
                                                        someView.frame.size.width, someView.frame.size.height);
                    someView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
                    
                    [self.chessboard exchangeSubviewAtIndex:i withSubviewAtIndex:rnd];
                    [self.chessboardViews exchangeObjectAtIndex:i withObjectAtIndex:rnd];
                    break;
                }
            }
        }
    }
}

- (UIColor*) randomColour {
    int r = arc4random_uniform(127) + 70;
    int g = arc4random_uniform(127) + 70;
    int b = arc4random_uniform(127) + 70;
    UIColor* colour = [[UIColor alloc]initWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    
    return colour;
}


@end
