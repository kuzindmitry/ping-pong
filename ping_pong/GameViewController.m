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
@property (strong, nonatomic) UIView *ball;
@property (strong, nonatomic) UITouch *topTouch;
@property (strong, nonatomic) UITouch *bottomTouch;
@property (strong, nonatomic) NSTimer * timer;
@property (nonatomic) CGFloat halfScreenHeight;
@property (nonatomic) CGFloat halfScreenWidth;
@property (nonatomic) float dx;
@property (nonatomic) float dy;
@property (nonatomic) float speed;

@end

@implementation GameViewController

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
    [self start];
}

- (void)config {
    self.view.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:135.0/255.0 blue:191.0/255.0 alpha:1.0];
    
    _gridView = [[UIView alloc] initWithFrame:CGRectMake(0, self.halfScreenHeight - 2, [UIScreen mainScreen].bounds.size.width, 4)];
    _gridView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:_gridView];
    
    _paddleTop = [[UIImageView alloc] initWithFrame:CGRectMake(30, 40, 90, 60)];
    _paddleTop.image = [UIImage imageNamed:@"paddleTop"];
    _paddleTop.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_paddleTop];
    
    _paddleBottom = [[UIImageView alloc] initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height - 90, 90, 60)];
    _paddleBottom.image = [UIImage imageNamed:@"paddleBottom"];
    _paddleBottom.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_paddleBottom];
    
    _ball = [[UIView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 20, 20)];
    _ball.backgroundColor = [UIColor whiteColor];
    _ball.layer.cornerRadius = 10;
    _ball.clipsToBounds = YES;
    _ball.hidden = YES;
    [self.view addSubview:_ball];
}

- (CGFloat)halfScreenHeight {
    return [UIScreen mainScreen].bounds.size.height/2;
}

- (CGFloat)halfScreenWidth {
    return [UIScreen mainScreen].bounds.size.width/2;
}

#pragma mark - Game play

- (void)start {
    _ball.center = CGPointMake(self.halfScreenWidth, self.halfScreenHeight);
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(animate) userInfo:nil repeats:YES];
    }
    _ball.hidden = NO;
}

- (void)stop {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _ball.hidden = YES;
}

- (void)animate {
    _ball.center = CGPointMake(_ball.center.x + _dx*_speed, _ball.center.y + _dy*_speed);
    [self checkCollision:CGRectMake(0, 0, 20, [UIScreen mainScreen].bounds.size.height) X:fabs(_dx) Y:0];
    [self checkCollision:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, 20, [UIScreen mainScreen].bounds.size.height) X:-fabs(_dx) Y:0];
    if ([self checkCollision:_paddleTop.frame X:(_ball.center.x - _paddleTop.center.x) / 32.0 Y:1]) {
        [self increaseSpeed];
    }
    if ([self checkCollision:_paddleBottom.frame X:(_ball.center.x - _paddleBottom.center.x) / 32.0 Y:-1]) {
        [self increaseSpeed];
    }
}

- (void)increaseSpeed {
    _speed += 0.5;
    if (_speed > 10) _speed = 10;
}

- (BOOL)checkCollision: (CGRect)rect X:(float)x Y:(float)y {
    if (CGRectIntersectsRect(_ball.frame, rect)) {
        if (x != 0) _dx = x;
        if (y != 0) _dy = y;
        return YES;
    }
    return NO;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        if (_bottomTouch == nil && point.y > self.halfScreenHeight) {
            _bottomTouch = touch;
            _paddleBottom.center = CGPointMake(point.x, point.y);
        }
        else if (_topTouch == nil && point.y < self.halfScreenHeight) {
            _topTouch = touch;
            _paddleTop.center = CGPointMake(point.x, point.y);
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        if (touch == _topTouch) {
            if (point.y > self.halfScreenHeight) {
                _paddleTop.center = CGPointMake(point.x, self.halfScreenHeight);
                return;
            }
            _paddleTop.center = point;
        }
        else if (touch == _bottomTouch) {
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
        if (touch == _topTouch) {
            _topTouch = nil;
        }
        else if (touch == _bottomTouch) {
            _bottomTouch = nil;
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

@end
