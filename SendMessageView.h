//
//  SendMessageView.h
//  KeyBoardUserChat
//
//  Created by 金鼎玉铉 on 16/7/27.
//  Copyright © 2016年 whjdyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendMessageView : UIView 
@property (nonatomic,retain) UIButton *sendMessageButton;
@property (nonatomic,retain) UIButton *emSelectButton;
@property (nonatomic,retain) UIButton *imageSelectButton;
@property (nonatomic,retain) UIButton *carmerSelectButton;
@property (nonatomic,retain) UITextView *showMessageTextView;
@property (nonatomic,assign) BOOL selectEm;
@end
