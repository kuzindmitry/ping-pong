//
//  ViewController.m
//  ping_pong
//
//  Created by kuzindmitry on 25.08.17.
//  Copyright © 2017 Dmitry Kuzin. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *paddleTop;
@property (weak, nonatomic) IBOutlet UIImageView *paddleBottom;
@property (nonatomic) CGFloat halfScreenHeight;

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

}

- (CGFloat)halfScreenHeight {
    return [UIScreen mainScreen].bounds.size.height/2;
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
            _paddleTop.center = CGPointMake(point.x, point.y);
        }
        else if (touch == bottomTouch) {
            _paddleBottom.center = CGPointMake(point.x, point.y);
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
