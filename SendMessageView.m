//
//  SendMessageView.m
//  KeyBoardUserChat
//
//  Created by 金鼎玉铉 on 16/7/27.
//  Copyright © 2016年 whjdyx. All rights reserved.
//

#import "SendMessageView.h"

@implementation SendMessageView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:233/255.0 green:234/255.0 blue:239/255.0 alpha:1];
        self.showMessageTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, self.bounds.size.width-70, 30)];
        self.showMessageTextView.layer.cornerRadius = 5;
        self.showMessageTextView.layer.masksToBounds = YES;
//        self.showMessageTextView.delegate = self;
        self.showMessageTextView.returnKeyType = UIReturnKeySend;
        self.showMessageTextView.font = [UIFont systemFontOfSize:14];
//        self.showMessageTextView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.showMessageTextView];
        
        self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendMessageButton.frame = CGRectMake(self.bounds.size.width-50, 5, 40, 30);
        self.sendMessageButton.layer.cornerRadius = 5;
        self.sendMessageButton.layer.masksToBounds = YES;
        [self.sendMessageButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sendMessageButton.backgroundColor = [UIColor colorWithRed:18/255.0 green:186/255.0 blue:246/255.0 alpha:1];
        [self addSubview:self.sendMessageButton];
        
        self.imageSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageSelectButton.frame = CGRectMake(10, self.frame.size.height-40, 30, 30);
        [self.imageSelectButton setImage:[UIImage imageNamed:@"图片icon选中"] forState:UIControlStateNormal];
//        [self.imageSelectButton setImage:[UIImage imageNamed:@"图片icon选中"] forState:UIControlStateSelected];

        [self addSubview:self.imageSelectButton];
        
        self.emSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
         self.emSelectButton.frame = CGRectMake(60, self.frame.size.height-40, 30, 30);
        [self.emSelectButton setImage:[UIImage imageNamed:@"表情icon未选中"] forState:UIControlStateNormal];
        [self.emSelectButton setImage:[UIImage imageNamed:@"表情icon选中"] forState:UIControlStateSelected];
//        self.emSelectButton.titleLabel.font = [UIFont systemFontOfSize:13];
//        self.emSelectButton.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.emSelectButton];
        
//        self.carmerSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
//         self.carmerSelectButton.frame = CGRectMake(110, self.frame.size.height-40, 30, 30);
//        [self.carmerSelectButton setTitle:@"相机" forState:UIControlStateNormal];
//        self.carmerSelectButton.titleLabel.font = [UIFont systemFontOfSize:13];
//        self.carmerSelectButton.backgroundColor = [UIColor purpleColor];
//        [self addSubview:self.carmerSelectButton];
        
    }
    return  self;
}

- (void)setSelectEm:(BOOL)selectEm
{
    _selectEm = selectEm;
    if (selectEm == YES)
    {
        self.emSelectButton.selected = YES;
    }
    else
    {
        self.emSelectButton.selected = NO;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
