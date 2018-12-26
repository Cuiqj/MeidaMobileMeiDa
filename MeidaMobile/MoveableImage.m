//
//  MoveableImage.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoveableImage.h"

@implementation MoveableImage
@synthesize delegate=_delegate;
@synthesize iconModelID=_iconModelID;
@synthesize rotation = _rotation;
@synthesize fontSize = _fontSize;
@synthesize imageSize = _imageSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setDelegate:self];
    [self addGestureRecognizer:panGesture];
    
    UIRotationGestureRecognizer *rotationGesture=[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [rotationGesture setDelegate:self];
    [self addGestureRecognizer:rotationGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDeleteMenu:)];
    [self addGestureRecognizer:longPressGesture];
    
    self.rotation = 0.0f;
    self.fontSize = 0.0f;
    return self;
}


- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        self.rotation += (gestureRecognizer.rotation*180/M_PI);
        if (self.rotation < 0) {
            int i = (int)self.rotation / 360; 
            self.rotation = self.rotation - i*360;
        } else {
            int i = (int)self.rotation / -360;
            self.rotation = self.rotation - i*(-360);
        }
        [gestureRecognizer setRotation:0];
    }
}

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = [gestureRecognizer view];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        CGPoint piecePosition = CGPointMake(piece.frame.origin.x+translation.x, piece.frame.origin.y+translation.y);
        CGPoint pieceBoundsPoint = CGPointMake(piece.bounds.size.width+piecePosition.x, piece.bounds.size.height+piecePosition.y);
        CGRect  superViewBounds = [[piece superview] bounds];
        CGPoint superViewBoundsPoint = CGPointMake(superViewBounds.origin.x+superViewBounds.size.width,superViewBounds.origin.y+superViewBounds.size.height);
        if (pieceBoundsPoint.y<superViewBoundsPoint.y && piecePosition.y>superViewBounds.origin.y && pieceBoundsPoint.x<superViewBoundsPoint.x && piecePosition.x>0) {
            [piece setCenter:CGPointMake(piece.center.x + translation.x, piece.center.y + translation.y)];
            [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
            NSInteger currentPage=[self.delegate getCurrentPageDelegate];
            if (piece.center.x>(currentPage+1)*PaintAreaWidth) {
                [self.delegate autoScrollPage:(currentPage+1)*PaintAreaWidth];
            }
            if (piece.center.x<currentPage*PaintAreaWidth) {
                [self.delegate autoScrollPage:(currentPage-1)*PaintAreaWidth];
            }
        }
    }
}

- (void)showDeleteMenu:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deletePiece:)];
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        
        [self becomeFirstResponder];
        [menuController setMenuItems:[NSArray arrayWithObject:deleteMenuItem]];
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (void)deletePiece:(UIMenuController *)controller
{    
    [self removeFromSuperview];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)dealloc{
    [self setIconModelID:nil];
    [self setDelegate:nil];
}
@end
