//
//  ViewController.m
//  Lesson22Task
//
//  Created by Анастасия Распутняк on 05.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    ARViewTypeCellWhite     = 1 << 0,
    ARViewTypeCellBlack     = 1 << 1,
    ARViewTypeCheckerWhite  = 1 << 2,
    ARViewTypeCheckerRed    = 1 << 3,
    
    ARViewTypeCellEmpty     = 0 << 16,
    ARViewTypeCellFull      = 1 << 16
} ARViewType;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *border;
@property (weak, nonatomic) IBOutlet UIView *chessboard;
@property (weak, nonatomic) UIView* draggingChecker;
@property (weak, nonatomic) UIView* previousCell;
@property (assign, nonatomic) CGPoint delta;
@property (strong, nonatomic) NSMutableArray* cells;

- (void)draggingChecker:(UIView*)checker isStarted:(BOOL)f;
- (void)lettingCheckerDown:(UIView*)checker;
- (double)euklidDestBetween:(CGPoint)point1 and:(CGPoint)point2;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.cells = [[NSMutableArray alloc] init];
    // фиксируем доску
    self.border.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
                                 UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    int cellWidth = CGRectGetWidth(self.chessboard.frame) / 8;
    int checkerIndent = 4;
    int checkerWidth = cellWidth - checkerIndent * 2;
    
    // заполняем доску ячейками и шашками
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            UIView* cell = [[UIView alloc] initWithFrame:CGRectMake(i * cellWidth, j * cellWidth, cellWidth, cellWidth)];
            
            if (i % 2 == j % 2) {
                cell.backgroundColor = [UIColor blackColor];
                cell.tag = ARViewTypeCellBlack;
            } else {
                cell.backgroundColor = [UIColor whiteColor];
                cell.tag = ARViewTypeCellWhite;
            }
            
            [self.chessboard addSubview:cell];  // помещаем вьюхи-ячейки на вьюху-доску
            [self.cells addObject:cell];  // добавляем ячейки в массив ячеек
            
            if ([cell.backgroundColor isEqual:[UIColor blackColor]] && j != 3 && j != 4) {
                UIView* checker = [[UIView alloc] initWithFrame:CGRectMake(i * cellWidth + checkerIndent, j * cellWidth + checkerIndent,
                                                                           checkerWidth, checkerWidth)];
                
                if (j < 3) {
                    checker.backgroundColor = [UIColor whiteColor];
                    checker.tag = ARViewTypeCheckerWhite;
                } else {
                    checker.backgroundColor = [UIColor redColor];
                    checker.tag = ARViewTypeCheckerRed;
                }
                checker.layer.cornerRadius = 19;
                checker.layer.masksToBounds = true;
                [self.chessboard addSubview:checker];
                
                cell.tag |= ARViewTypeCellFull;
            } else {
                cell.tag |= ARViewTypeCellEmpty;
            }
        }
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches began");
    
    UITouch* touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.chessboard];
    UIView* view = [self.chessboard hitTest:touchPoint withEvent:event];
    
    if (view.tag == ARViewTypeCheckerRed ||
        view.tag == ARViewTypeCheckerWhite) {
        self.draggingChecker = view;
        
        for (UIView* cell in self.cells) {
            if ([self euklidDestBetween:view.center and:cell.center] == 0.f) self.previousCell = cell;
        }

        [self.chessboard bringSubviewToFront:view];
        [self draggingChecker:self.draggingChecker isStarted:YES];
        
        
        CGPoint touchPointInSubview = [touch locationInView:view];
        self.delta = CGPointMake(CGRectGetMidX(self.draggingChecker.bounds) - touchPointInSubview.x, CGRectGetMidY(self.draggingChecker.bounds) - touchPointInSubview.y);
        } else {
            NSLog(@"you cannot move this view");
        }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // NSLog(@"touches moved");
    
    if (self.draggingChecker) {
        UITouch* touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInView:self.chessboard];
        
        CGPoint newCentre = CGPointMake(touchPoint.x + self.delta.x, touchPoint.y + self.delta.y);
        self.draggingChecker.center = newCentre;
        
    }
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches ended");
    
    UITouch* touch = [touches anyObject];
    // CGPoint touchPointInSubview = [touch locationInView:self.chessboard];
    CGPoint touchPointInMainview = [touch locationInView:self.view];
    if (touchPointInMainview.x == 0 || touchPointInMainview.y == 0 ||
        touchPointInMainview.x == CGRectGetWidth(self.view.frame) || touchPointInMainview.y == CGRectGetHeight(self.view.frame)) {
        
        NSLog(@"это был край");
        
        if (self.draggingChecker) {
            self.draggingChecker.center = self.previousCell.center;
            [self draggingChecker:self.draggingChecker isStarted:NO];
            self.draggingChecker = nil;
            self.previousCell = nil;
        }
    } else {
        NSLog(@"это был экран");
        
        [self lettingCheckerDown:self.draggingChecker];
        [self draggingChecker:self.draggingChecker isStarted:NO];
        self.draggingChecker = nil;
        self.previousCell = nil;
    }
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches cancelled");
    
    if (self.draggingChecker) {
        self.draggingChecker.center = self.previousCell.center;
        [self draggingChecker:self.draggingChecker isStarted:NO];
        self.draggingChecker = nil;
        self.previousCell = nil;
    }
    
}

- (void)draggingChecker:(UIView *)checker isStarted:(BOOL)f {
    [UIView animateWithDuration:0
                     animations:^{
                         checker.alpha = f ? 0.75f : 1.0f;
                         checker.transform = f ? CGAffineTransformScale(CGAffineTransformIdentity, 1.2f, 1.2f) : CGAffineTransformIdentity;
                         // CGAffineTransformScale(CGAffineTransformIdentity, 1.f, 1.f);
                     } completion:^(BOOL finished) {
                         NSLog(@"--");
                     }];
}

- (void)lettingCheckerDown:(UIView*)checker {
    CGPoint checkerCentre = checker.center;
    
    double r = 10000;
    UIView* nearestCell = [self.cells objectAtIndex:0];
    for (UIView* cell in self.cells) {
        if (cell.tag == (ARViewTypeCellBlack | ARViewTypeCellEmpty)) {
            CGPoint cellCetre = cell.center;
            double euklidDest = [self euklidDestBetween:checkerCentre and:cellCetre];
            if (r > euklidDest) {
                r = euklidDest;
                nearestCell = cell;
            }
        }
    }
    
    checker.center = nearestCell.center;
    nearestCell.tag = ARViewTypeCellBlack | ARViewTypeCellFull;
    self.previousCell.tag = ARViewTypeCellBlack | ARViewTypeCellEmpty;
}

- (double)euklidDestBetween:(CGPoint)point1 and:(CGPoint)point2 {
    return sqrt(pow(point1.x - point2.x, 2.0) + pow(point1.y - point2.y, 2.0));
}

@end
