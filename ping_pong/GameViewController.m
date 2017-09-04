//
//  ViewController.m
//  ping_pong
//
//  Created by kuzindmitry on 25.08.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property (strong, nonatomic) UIImageView *paddleTop;
@property (strong, nonatomic) UIImageView *paddleBottom;
@property (strong, nonatomic) UIView *gridView;
@property (nonatomic) CGFloat halfScreenHeight;
@property (nonatomic) CGFloat halfScreenWidth;

@end

@implementation GameViewController {
    
    UITouch *topTouch;
    UITouch *bottomTouch;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self config];
}

- (void)config {
    self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:135.0/255.0 blue:191.0/255.0 alpha:1.0];
    
    _gridView = [[UIView alloc] initWithFrame:CGRectMake(0, self.halfScreenHeight - 2, [UIScreen mainScreen].bounds.size.width, 4)];
    _gridView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_gridView];
    
    _paddleTop = [[UIImageView alloc] initWithFrame:CGRectMake(30, 40, 90, 60)];
    _paddleTop.image = [UIImage imageNamed:@"paddleTop"];
    _paddleTop.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_paddleTop];
    
    _paddleBottom = [[UIImageView alloc] initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height - 90, 90, 60)];
    _paddleBottom.image = [UIImage imageNamed:@"paddleBottom"];
    _paddleBottom.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_paddleBottom];
}

- (CGFloat)halfScreenHeight {
    return [UIScreen mainScreen].bounds.size.height/2;
}

- (CGFloat)halfScreenWidth {
    return [UIScreen mainScreen].bounds.size.width/2;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        if (bottomTouch == nil && point.y > self.halfScreenHeight) {
            bottomTouch = touch;
            _paddleBottom.center = CGPointMake(point.x, point.y);
        }
        else if (topTouch == nil && point.y < self.halfScreenHeight) {
            topTouch = touch;
            _paddleTop.center = CGPointMake(point.x, point.y);
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        if (touch == topTouch) {
            if (point.y > self.halfScreenHeight) {
                _paddleTop.center = CGPointMake(point.x, self.halfScreenHeight);
                return;
            }
            _paddleTop.center = point;
        }
        else if (touch == bottomTouch) {
            if (point.y < self.halfScreenHeight) {
                _paddleBottom.center = CGPointMake(point.x, self.halfScreenHeight);
                return;
            }
            _paddleBottom.center = point;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch == topTouch) {
            topTouch = nil;
        }
        else if (touch == bottomTouch) {
            bottomTouch = nil;
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

@end
