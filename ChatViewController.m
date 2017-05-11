//
//  ChatViewController.m
//  KeyBoardUserChat
//
//  Created by 金鼎玉铉 on 16/7/27.
//  Copyright © 2016年 whjdyx. All rights reserved.
//

#import "ChatViewController.h"
#import "SendMessageView.h"
#import "EmShowView.h"
#import "RequestHttp.h"
@interface ChatViewController ()<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    SendMessageView *_sendView;
    EmShowView *_emShowView;
    UIWebView *_showMessageWebView;
    CGSize keyBoardSize;
    BOOL _isKeyboard;
}
@end

@implementation ChatViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"emName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"在线客服";
    [self.leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(backLastView) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _showMessageWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-85)];
    _showMessageWebView.backgroundColor = [UIColor colorWithRed:233/255.0 green:234/255.0 blue:239/255.0 alpha:1];
    NSString *str = [NSString stringWithFormat:@"http://talk.cctvup.cn:8080/talk/OnLine/Index?tid=1&gid=%d&uid=%@&pwd=%@&pur=%d",1,@"ccy432092",@"000000",0];
    _showMessageWebView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_showMessageWebView loadRequest:request];
    _showMessageWebView.delegate = self;
    [self.view addSubview:_showMessageWebView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delectEmAction) name:@"delectEm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(intoTextToViewAction:) name:@"emName" object:nil];
    _sendView = [[SendMessageView  alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 85, self.view.frame.size.width, 85)];
    [_sendView.sendMessageButton addTarget:self action:@selector(sendMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [_sendView.imageSelectButton addTarget:self action:@selector(selectImageAction) forControlEvents:UIControlEventTouchUpInside];
    [_sendView.emSelectButton addTarget:self action:@selector(selectEmAction) forControlEvents:UIControlEventTouchUpInside];
    _sendView.showMessageTextView.delegate = self;
    [_sendView.carmerSelectButton addTarget:self action:@selector(selectCarmerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendView];
    _emShowView = [[EmShowView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 185)];
//    [_emShowView.delectEmButton addTarget:self action:@selector(delectEmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_emShowView];
    
}
- (void)backLastView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    static CGFloat maxHeight =80.0f;
    CGRect frame = textView.frame;
//    CGRect sendFrame = _sendView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
//    if (size.height<=frame.size.height) {
//        size.height=frame.size.height;
//    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
//    }
//    _sendView.frame = CGRectMake(0, self.view.frame.size.height - keyBoardSize.height - size.height - 55, sendFrame.size.width, sendFrame.size.height+size.height - 30 );
//    
//    NSLog(@"当前的发送框的高度==%@当前的输入框高度==%@",NSStringFromCGSize(_sendView.frame.size),NSStringFromCGSize(frame.size));
//    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    if (_isKeyboard == NO)
    {
        keyBoardSize.height = 180;
    }
    _showMessageWebView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height- keyBoardSize.height -size.height - 40-64);
    _sendView.frame = CGRectMake(0, self.view.frame.size.height - keyBoardSize.height - size.height - 55, self.view.frame.size.width, size.height + 55);
    _sendView.showMessageTextView.frame = CGRectMake(10, 5, _sendView.frame.size.width - 70, size.height);
    _sendView.imageSelectButton.frame = CGRectMake(10, CGRectGetMaxY(_sendView.showMessageTextView.frame)+10, 30, 30);
    _sendView.emSelectButton.frame = CGRectMake(60, CGRectGetMaxY(_sendView.showMessageTextView.frame)+10, 30, 30);
    _sendView.carmerSelectButton.frame = CGRectMake(110, CGRectGetMaxY(_sendView.showMessageTextView.frame)+10, 30, 30);
    _sendView.sendMessageButton.frame = CGRectMake(CGRectGetMaxX(_sendView.showMessageTextView.frame)+10, CGRectGetMaxY(_sendView.showMessageTextView.frame)-30, 40, 30);
//    NSLog(@"当前webView==%@",NSStringFromCGRect(_showMessageWebView.frame));
//    NSLog(@"2键盘的高度==%@",NSStringFromCGSize(keyBoardSize));
//    NSLog(@"输入的高度==%@==%@",NSStringFromCGSize(_sendView.frame.size),NSStringFromCGSize(size));
//    NSLog(@"TextView的高度==%@",NSStringFromCGSize(size));
}
//判断是不是return键
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"])
//    {
//        NSLog(@"你点击的是return建");
//    }
//    
//    return YES;
//}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        DLog(@"发送");
        //在这里做你响应return键的代码
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    if([text length] != 0) //点击了非删除键
    {
    }
    else
    {
        if (_sendView.showMessageTextView.text.length >0)
        {
            NSString *text = _sendView.showMessageTextView.text;
            NSLog(@"删除前==%@",text);
            if ([text containsString:@"]"] && [[text substringFromIndex:text.length -1] isEqualToString:@"]"])
            {
                NSRange startRang = [text rangeOfString:@"[" options:NSBackwardsSearch];
                NSString *current = [text substringToIndex:startRang.location+1];
                //        [_sendView.showMessageTextView setTextViewContent:[current stringByAppendingString:appendText]];
                _sendView.showMessageTextView.selectedRange = NSMakeRange(current.length, 0);
                _sendView.showMessageTextView.text = current;
                
            }
            else
            {
                NSString *current = [text substringToIndex:text.length ];
                
                //        [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
                _sendView.showMessageTextView.selectedRange = NSMakeRange(current.length, 0);
                _sendView.showMessageTextView.text = current;
            }
            
        }
        [self textViewDidChange:_sendView.showMessageTextView]; ; // 按键对应的str
    }
    return YES;
}
- (void)keyboardWillShow:(NSNotification *)notify
{
    _isKeyboard = YES;
    _sendView.selectEm = NO;
    //获取键盘的高度
    NSDictionary *userInfo = [notify userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyBoardSize = keyboardRect.size;
    NSLog(@"1键盘的高度==%@",NSStringFromCGSize(keyBoardSize));
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        _showMessageWebView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-height-85-64);
        _sendView.frame = CGRectMake(0, self.view.frame.size.height - height -85, self.view.frame.size.width, 85);
        _emShowView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
    }];
    NSLog(@"当前webView==%@",NSStringFromCGRect(_showMessageWebView.frame));
}
- (void)keyboardWillHidden:(NSNotification *)notify
{
    
}
//获取发送的表情
- (void)intoTextToViewAction:(NSNotification *)notify
{
    _sendView.showMessageTextView.text = [_sendView.showMessageTextView.text stringByAppendingString:[NSString stringWithFormat:@"%@",notify.userInfo[@"emName"]]];
    [self textViewDidChange:_sendView.showMessageTextView];
}

//发送表情
- (void)sendMessageAction
{
//    [RequestHttp sendMessageWithNsstring:_sendView.showMessageTextView.text userID:@"ccy432092" userType:1 block:^(NSInteger result) {
//        if (result == 1)
//        {
//            NSLog(@"发送成功");
//            [_showMessageWebView reload];
//            _sendView.showMessageTextView.text = @"";
//            [UIView animateWithDuration:0.2 animations:^{
                if (_isKeyboard == NO)
                {
                    keyBoardSize.height = 180;
                    
                }
                _showMessageWebView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - keyBoardSize.height - 85-64);
                _sendView.frame = CGRectMake(0, CGRectGetMaxY(_showMessageWebView.frame), self.view.frame.size.width, 85);
                
                _sendView.showMessageTextView.frame = CGRectMake(10, 5, _sendView.frame.size.width - 70, 30);
                _sendView.imageSelectButton.frame = CGRectMake(10, CGRectGetMaxY(_sendView.showMessageTextView.frame)+10, 30, 30);
                _sendView.emSelectButton.frame = CGRectMake(60, CGRectGetMaxY(_sendView.showMessageTextView.frame)+10, 30, 30);
                _sendView.carmerSelectButton.frame = CGRectMake(110, CGRectGetMaxY(_sendView.showMessageTextView.frame)+10, 30, 30);
                _sendView.sendMessageButton.frame = CGRectMake(CGRectGetMaxX(_sendView.showMessageTextView.frame)+10, CGRectGetMaxY(_sendView.showMessageTextView.frame)-30, 40, 30);
//                NSLog(@"发送当前webView==%@",NSStringFromCGRect(_showMessageWebView.frame));
//                NSLog(@"发送2键盘的高度==%@",NSStringFromCGSize(keyBoardSize));
//                NSLog(@"发送输入的高度==%@",NSStringFromCGRect(_sendView.frame));
              
//            }];
//        }
//        else
//        {
//            NSLog(@"发送失败");
//            _sendView.showMessageTextView.text = @"";
//            [UIView animateWithDuration:0.2 animations:^{
//                if (_isKeyboard == NO)
//                {
//                    keyBoardSize.height = 180;
//                    
//                }
//                _showMessageWebView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - keyBoardSize.height - 85-64);
//                _sendView.frame = CGRectMake(0, CGRectGetMaxY(_showMessageWebView.frame), self.view.frame.size.width, 85);
//                
//                _sendView.showMessageTextView.frame = CGRectMake(10, 5, _sendView.frame.size.width - 70, 30);
//                _sendView.imageSelectButton.frame = CGRectMake(10, CGRectGetMaxY(_sendView.showMessageTextView.frame)+10, 30, 30);
//                _sendView.emSelectButton.frame = CGRectMake(60, CGRectGetMaxY(_sendView.showMessageTextView.frame)+10, 30, 30);
//                _sendView.carmerSelectButton.frame = CGRectMake(110, CGRectGetMaxY(_sendView.showMessageTextView.frame)+10, 30, 30);
//                _sendView.sendMessageButton.frame = CGRectMake(CGRectGetMaxX(_sendView.showMessageTextView.frame)+10, CGRectGetMaxY(_sendView.showMessageTextView.frame)-30, 40, 30);
//                
//            }];
//
//        }
//    }];
}
//选择图片
- (void)selectImageAction
{
  
    _sendView.emSelectButton.selected = NO;
    _sendView.emSelectButton.enabled = YES;
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertView addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = NO;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else
        {
            MYAlert(@"提示", @"您的设备暂不支持拍照", @"确定", @"取消")
        }
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        DLog(@"点击的取消");
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    _imageButton.selected = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    
    CGFloat height =image.size.height;
    if (height >250)
    {
        imageView.frame = CGRectMake(20, 180, 150, (250/image.size.width)*150);
    }
    else
    {
        imageView.frame = CGRectMake(20, 180, 150, (image.size.height/image.size.width)*150);
    }
    CGSize imagesize = image.size;
    DLog(@"图片尺寸%@",NSStringFromCGSize(imagesize));
    imagesize.height =imagesize.height*1024/imagesize.width;
    imagesize.width =1024; //对图片大小进行压缩--
    image = [Tool imageWithImage:image scaledToSize:imagesize];
    DLog(@"压缩后图片尺寸%@",NSStringFromCGSize(image.size));
    imageView.image = image;
    [self.view addSubview:imageView];
//    dataImage = image;
    
    //    [RequestHttp updateImageViewToInternet:image block:^(NSInteger result) {
    //        NSLog(@"返回的结果==%ld",result);
    //    }];
}
//选择表情
- (void)selectEmAction
{
    _isKeyboard = NO;
    _sendView.selectEm = YES;
//    _sendView.emSelectButton.selected = YES;
//    _sendView.emSelectButton.enabled = NO;
    [_sendView.showMessageTextView resignFirstResponder];
    if (_emShowView.frame.origin.y == self.view.frame.size.height)
    {
        [UIView animateWithDuration:0.5 animations:^{
            _showMessageWebView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-180-85-64);
            _sendView.frame = CGRectMake(0, self.view.frame.size.height - 180 - _sendView.frame.size.height, self.view.frame.size.width, _sendView.frame.size.height);
            _emShowView.frame = CGRectMake(0, self.view.frame.size.height-180, self.view.frame.size.width, 180);
        }];
    }
}
//选择相机
- (void)selectCarmerAction
{
    _sendView.selectEm = NO;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
//删除表情
- (void)delectEmAction
{
    if (_sendView.showMessageTextView.text.length >0)
    {
        NSString *text = _sendView.showMessageTextView.text;
        if ([text containsString:@"]"] && [[text substringFromIndex:text.length - 1] isEqualToString:@"]"]) {
            NSRange startRang = [text rangeOfString:@"[" options:NSBackwardsSearch];
            NSString *current = [text substringToIndex:startRang.location];
            //        [_sendView.showMessageTextView setTextViewContent:[current stringByAppendingString:appendText]];
            _sendView.showMessageTextView.selectedRange = NSMakeRange(current.length, 0);
            _sendView.showMessageTextView.text = current;
        }
        else
        {
            NSString *current = [text substringToIndex:text.length - 1];
            
            //        [self.chatToolBar setTextViewContent:[current stringByAppendingString:appendText]];
            _sendView.showMessageTextView.selectedRange = NSMakeRange(current.length, 0);
            _sendView.showMessageTextView.text = current;
        }

    }
    [self textViewDidChange:_sendView.showMessageTextView];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _sendView.selectEm = NO;
    [UIView animateWithDuration:0.5 animations:^{
        _showMessageWebView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-85+5);
        _sendView.frame = CGRectMake(0, self.view.frame.size.height - 85, self.view.frame.size.width, 85);
        _emShowView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 180);
        
    }];
    
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
////    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
//    CGSize imagesize = image.size;
//    imagesize.height =imagesize.height*1024/imagesize.width;     imagesize.width =1024; //对图片大小进行压缩--
//    image = [self imageWithImage:image scaledToSize:imagesize];
////    imageView.image = image;
////    [self.view addSubview:imageView];
////    [RequestHttp updateImageViewToInternet:image userID:@"ccy432092" type:1 block:^(NSInteger result) {
////        NSLog(@"返回的结果==%ld",result);
////        [_showMessageWebView reload];
////    }];
//}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
