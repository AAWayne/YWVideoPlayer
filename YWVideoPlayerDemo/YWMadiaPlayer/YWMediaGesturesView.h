//
//  YWMediaGesturesView.h
//  YWIjkPlayer
//
//  Created by Candy on 2017/10/10.
//  Copyright © 2017年 com.zhiweism. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol YWMediaGesturesViewDelegate <NSObject>
//移动
-(void)touchesMovedWith:(CGPoint)point;
//开始
-(void)touchesBeganWith:(CGPoint)point;

@end


@interface YWMediaGesturesView : UIView

@property(nonatomic,assign) id<YWMediaGesturesViewDelegate>delegate;

@end
