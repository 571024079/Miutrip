//
//  BaseUIViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 11/13/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "RegisterAndLogViewController.h"
#import "AppDelegate.h"

@interface BaseUIViewController ()

@property (strong, nonatomic) UIImageView               *backGroundImageView;
@property (strong, nonatomic) UILabel                   *titleLabel;;

@end

@implementation BaseUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _contentView = [[BaseContentView alloc]initWithFrame:appBounds];
        [_contentView setSuperResponder:self];
        //[_contentView setHidden:YES];
        _requestManager = [[RequestManager alloc]init];
        [_requestManager setDelegate:self];
        [self.view addSubview:_contentView];

        [self superViewInit];
    }
    return self;
}

- (void)setSubjoinViewFrame
{
    //subview rewrite
}

- (void)superViewInit
{
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setBackgroundColor:color(clearColor)];
    [phoneBtn setTag:1000];
    [phoneBtn setImage:imageNameAndType(@"phone_normal", nil) forState:UIControlStateNormal];
    [phoneBtn setImage:imageNameAndType(@"phone_press", nil) forState:UIControlStateHighlighted];
    
    UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatBtn setBackgroundColor:color(clearColor)];
    [wechatBtn setTag:1001];
    [wechatBtn setImage:imageNameAndType(@"wechat_normal", nil) forState:UIControlStateNormal];
    [wechatBtn setImage:imageNameAndType(@"wechat_press", nil) forState:UIControlStateHighlighted];
    
    [self setBottomBarBackGroundImage:imageNameAndType(@"bottombar", nil)];
    [self setBottomBarItems:@[phoneBtn,wechatBtn]];
    
    [phoneBtn addTarget:self action:@selector(superPressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [wechatBtn addTarget:self action:@selector(superPressBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)superPressBtn:(UIButton*)sender
{
    NSLog(@"super tag = %d",sender.tag);
}

- (void)setBackGroundImage:(UIImage*)image
{
    if (image) {
        if (!_backGroundImageView) {
            _backGroundImageView = [[UIImageView alloc]init];
            [_backGroundImageView setFrame:self.view.bounds];
            [_backGroundImageView setBackgroundColor:[UIColor clearColor]];
            if (_contentView) {
                [self.view insertSubview:_backGroundImageView belowSubview:_contentView];
            }else
                [self.view insertSubview:_backGroundImageView aboveSubview:self.view];
        }
        [_backGroundImageView setImage:image];
    }else{
        if (_backGroundImageView && _backGroundImageView.superview) {
            [_backGroundImageView removeFromSuperview];
        }
    }
}

- (void)setTopBarBackGroundImage:(UIImage*)image
{
    if (!_topBar) {
        _topBar = [[UIImageView alloc]init];
        [_topBar setUserInteractionEnabled:YES];
        [_topBar setFrame:CGRectMake(0, 0, appFrame.size.width, 50)];
        [_topBar setBackgroundColor:[UIColor clearColor]];
        if (_titleLabel) {
            [self.view insertSubview:_topBar belowSubview:_titleLabel];
        }else
            [self.view addSubview:_topBar];
        UIGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clearKeyBoard)];
        [gestureRecognizer setDelegate:self];
        [_topBar addGestureRecognizer:gestureRecognizer];
    }
    if (image) {
        [_topBar setImage:image];
    }else{
        [_topBar removeFromSuperview];
    }
}

- (void)setBottomBarBackGroundImage:(UIImage*)image
{
    if (!_bottomBar) {
        _bottomBar = [self createBottomBar];
    }
    [_bottomBar setImage:image forState:UIControlStateNormal];
    [_bottomBar setImage:image forState:UIControlStateHighlighted];
    [_bottomBar setImage:image forState:UIControlStateDisabled];
}

- (void)setBottomBarBackGroundColor:(UIColor*)color
{
    if (!_bottomBar) {
        _bottomBar = [self createBottomBar];
    }
    [_bottomBar setBackgroundColor:color];
}

- (void)setBottomBarItems:(NSArray*)items
{
    if (!_bottomBar) {
        _bottomBar = [self createBottomBar];
    }
    for (/*int i = [items count]; i > 0 ; i--*/int i = 0; i<[items count]; i++) {
        UIButton *item = [items objectAtIndex:i/*([items count] - i)*/];
        //[item setFrame:CGRectMake(self.view.frame.size.width - 50 * i - 15, 0, 70, 35)];//不适配宽度
        [item setFrame:CGRectMake(_bottomBar.frame.size.width * i/[items count], 0, _bottomBar.frame.size.width/[items count], 35)];//适配宽度
        [item setBounds:CGRectMake(0, 0, item.frame.size.width*4/5, item.frame.size.height*4/5)];
        [_bottomBar addSubview:item];
    }
}

- (UIButton*)createBottomBar
{
    UIButton *bottomBar = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBar setBackgroundColor:[UIColor clearColor]];
    [bottomBar setTag:101];
    [bottomBar setFrame:CGRectMake(0, self.view.frame.size.height - 35, self.view.frame.size.width, 35)];
    if (_contentView) {
        [self.view insertSubview:bottomBar aboveSubview:_contentView];
    }else{
        [self.view addSubview:bottomBar];
    }
    
    return bottomBar;
}

- (void)setReturnButton:(UIButton*)button
{
    [button addTarget:self action:@selector(returnToPrevView:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setPopToMainViewButton:(UIButton*)button
{
    [button addTarget:self action:@selector(popToMainView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)returnToPrevView:(UIButton*)sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication  sharedApplication].delegate;
            if (deviceVersion >= 7.0) {
                UIViewController *viewController = nil;
                if (appDelegate.window.rootViewController.presentedViewController) {
                    viewController = appDelegate.window.rootViewController.presentedViewController;
                }else{
                    viewController = appDelegate.window.rootViewController;
                }
                CGAffineTransform currentTransform = appDelegate.window.transform;
                CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 1, (appFrame.size.height - 20)/appFrame.size.height);
                [viewController.view.layer setAnchorPoint:CGPointMake(0.5f, 1.0f)];
                
                [viewController.view setFrame:CGRectMake(0, 0, viewController.view.frame.size.width, viewController.view.frame.size.height)];
                [UIView animateWithDuration:0.25 animations:^{
                    [viewController.view setTransform:newTransform];
                }];
            }
        }];
    }
}

- (void)popToMainView:(UIButton*)sender
{
    if (self.navigationController) {
        if (![Model shareModel].mainView) {
            [Model shareModel].mainView = [[BaseUIViewController alloc]init];
        }if (![self.navigationController.viewControllers containsObject:[Model shareModel].mainView]) {
            [self.navigationController pushViewController:[Model shareModel].mainView animated:YES];
        }else{
            [self.navigationController popToViewController:[Model shareModel].mainView animated:YES];
        }
    }else{
        if (![Model shareModel].mainView) {
            [Model shareModel].mainView = [[BaseUIViewController alloc]init];
        }
        [self presentViewController:[Model shareModel].mainView animated:YES completion:nil];
    }
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/2, 50)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.view addSubview:_titleLabel];
    }
    [_titleLabel setText:title];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self clearKeyBoard];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - keyboard handle
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self clearKeyBoard];
}

- (BOOL)clearKeyBoard
{
    //subview rewrite
    return YES;
}

- (void)keyBoardWillShow:(NSNotification *)notification
{
    //subview rewrite
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    //subview rewrite
}

- (void)keyBoardChangeFrame:(NSNotification *)notification
{
    //subview rewrite
}

- (UIView *)findKeyboard
{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView)
        {
            return keyboardView;
        }
    }
    return nil;
}

- (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            return subView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}

-(void)sendRequestWithRequest:(BaseRequestModel *)request{
    
    if(request == Nil){
        return;
    }

    ASIFormDataRequest *asiRequest = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:[request getRequestURLString]]];
    
    NSString *json = [request getRequestJsonString:YES];
    NSLog(@"request json = '%@'",json);

    [asiRequest setPostValue:json forKey:@"Json"];
    [asiRequest setDelegate:self];
    
    [asiRequest setTimeOutSeconds:30];
    [asiRequest setUseCookiePersistence:NO];
    [asiRequest startAsynchronous];
}

- (void)sendRequestWithURL:(NSString*)URLString params:(NSDictionary*)_params requestMethod:(RequestType)requestType userInfo:(NSDictionary*)userInfo
{

    if(URLString == nil || URLString.length == 0){
        return;
    }
    
    NSLog(@"url = '%@'",URLString);
    NSMutableDictionary *params = nil;
    if (_params) {
        params = [NSMutableDictionary dictionaryWithDictionary:_params];
    }else{
        params = [NSMutableDictionary dictionary];
    }
    

    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:URLString]];
    [request setUserInfo:userInfo];
    
    [params setObject:deviceId forKey:@"deviceId"];
    [params setObject:@"0" forKey:@"appId"];
    [params setObject:[Utils stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"processTime"];
    
    if(requestType != RequestLogIn){
            [params setObject:[UserDefaults shareUserDefault].authTkn forKey:@"authTkn"];
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:URLString]];
        [request setUserInfo:userInfo];
        
        [params setObject:deviceId forKey:@"deviceId"];
        [params setObject:@"0" forKey:@"appId"];
        [params setObject:[Utils stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"processTime"];
        if (requestType != RequestLogIn) {
            if ([UserDefaults shareUserDefault].authTkn) {
                [params setObject:[UserDefaults shareUserDefault].authTkn forKey:@"authTkn"];
            }
        }
        
        [request setPostValue:[params JSONRepresentation] forKey:@"Json"];
        NSLog(@"params json = %@",[params JSONRepresentation]);
        [request setDelegate:self];
        
        [request setTimeOutSeconds:30];
        [request setUseCookiePersistence:NO];
        [request startAsynchronous];
    }else if (requestType == RequestLogOut){
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URLString]];
        request.requestHeaders = [NSMutableDictionary dictionaryWithDictionary:params];
        [request setUserInfo:userInfo];
        
        [params setObject:deviceId forKey:@"deviceId"];
        [params setObject:@"0" forKey:@"appId"];
        [params setObject:[Utils stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"processTime"];
        [params setObject:[UserDefaults shareUserDefault].authTkn forKey:@"authTkn"];
        NSLog(@"json = %@",[params JSONRepresentation]);
        [request setPostValue:[params JSONRepresentation] forKey:@"Json"];
        [request setUseCookiePersistence:NO];
        [request setTimeOutSeconds:30];
        request.delegate = self;
        [request startAsynchronous];
    }
    
    NSString *json = [params JSONRepresentation];
    NSLog(@"request json = '%@'",json);
           
    [request setPostValue:json forKey:@"Json"];
    [request setDelegate:self];
    
    [request setTimeOutSeconds:30];
    [request setUseCookiePersistence:NO];
    [request startAsynchronous];
    
    self.view.userInteractionEnabled = NO;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    self.view.userInteractionEnabled = YES;
    NSString *responseString = request.responseString;
    NSLog(@"response string = '%@'",responseString);
    NSDictionary *dic = [responseString JSONValue];
    if ([[dic objectForKey:@"process_status"] isEqualToString:@"0"]) {
        [self requestDone:dic];
        [self requestSuccess:responseString];
    }else{
        [[Model shareModel] showPromptText:[NSString stringWithFormat:@"%@\n错误码%@",[dic objectForKey:@"errorMessage"],[dic objectForKey:@"errorCode"]] model:YES];
    }
    [self.view setUserInteractionEnabled:YES];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    self.view.userInteractionEnabled = YES;
    [self requestError:request];
}

- (void)requestDone:(NSDictionary*)responseData
{
    //subview inherit this method to do request finished handle
}
- (void)requestError:(ASIHTTPRequest*)request
{
    //subview inherit this method to do error finished handle
}

- (void)requestSuccess:(NSString *)responseData
{
    //subview inherit this method to do success finished handle
}

- (void)pushViewController:(UIViewController*)_viewController transitionType:(TransitionType)_transitionType completionHandler:(void (^) (void))_compleHandler
{
    if (self.navigationController) {
        [self.navigationController pushViewController:_viewController animated:NO];
        CATransition *transition = [Utils getAnimation:_transitionType subType:DirectionRight];
        [self.navigationController.view.layer addAnimation:transition forKey:@"viewtransition"];
        [self performSelector:@selector(completionHandler:) withObject:_compleHandler afterDelay:transitionDuration];
    }
}

- (void)pushViewController:(UIViewController*)_viewController transitionType:(TransitionType)_transitionType Direction:(Direction)_direction completionHandler:(void (^) (void))_compleHandler
{
    if (self.navigationController) {
        [self.navigationController pushViewController:_viewController animated:NO];
        CATransition *transition = [Utils getAnimation:_transitionType subType:_direction];
        [self.navigationController.view.layer addAnimation:transition forKey:@"viewtransition"];
        [self performSelector:@selector(completionHandler:) withObject:_compleHandler afterDelay:transitionDuration];
    }
}

- (void)pushViewControllers:(NSArray*)viewControllers transitionType:(TransitionType)_transitionType completionHandler:(void (^) (void))_compleHandler
{
    for (UIViewController *_viewController in viewControllers) {
        if (viewControllers.lastObject != _viewController) {
            if (self.navigationController) {
                [self.navigationController pushViewController:_viewController animated:NO];
            }
        }else{
            [self.navigationController pushViewController:_viewController animated:NO];
            CATransition *transition = [Utils getAnimation:_transitionType subType:DirectionRight];
            [self.navigationController.view.layer addAnimation:transition forKey:@"viewtransition"];
            [self performSelector:@selector(completionHandler:) withObject:_compleHandler afterDelay:transitionDuration];
        }
    }
}


- (void)popViewControllerTransitionType:(TransitionType)_transitionType completionHandler:(void (^) (void))_compleHandler
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        //CATransition *transition = [Utils getAnimation:_transitionType subType:DirectionLeft];
        //[self.navigationController.view.layer addAnimation:transition forKey:@"viewtransition"];
        [self performSelector:@selector(completionHandler:) withObject:_compleHandler afterDelay:transitionDuration];
    }
}

- (void)popToMainViewControllerTransitionType:(TransitionType)_transitionType completionHandler:(void (^) (void))_compleHandler
{
    if (self.navigationController) {
        if (![Model shareModel].mainView) {
            [Model shareModel].mainView = [[RegisterAndLogViewController alloc]init];
            [self.navigationController pushViewController:[Model shareModel].mainView animated:YES];
        }else
            [self.navigationController popToViewController:[Model shareModel].mainView animated:YES];
        CATransition *transition = [Utils getAnimation:_transitionType subType:DirectionLeft];
        [self.navigationController.view.layer addAnimation:transition forKey:@"viewtransition"];
        [self performSelector:@selector(completionHandler:) withObject:_compleHandler afterDelay:transitionDuration];
    }
}

- (void)popToViewController:(BaseUIViewController*)_viewController transitionType:(TransitionType)_transitionType completionHandler:(void (^) (void))_compleHandler
{
    if (self.navigationController) {
        [self.navigationController popToViewController:_viewController animated:YES];
        CATransition *transition = [Utils getAnimation:_transitionType subType:DirectionLeft];
        [self.navigationController.view.layer addAnimation:transition forKey:@"viewtransition"];
        [self performSelector:@selector(completionHandler:) withObject:_compleHandler afterDelay:transitionDuration];
    }
}

- (void)completionHandler:(void (^) (void))_compleHandler
{
    if (_compleHandler) {
        _compleHandler();
    }
    [self.navigationController.view.layer removeAnimationForKey:@"viewtransition"];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIImageView *)createLineWithParam:(NSObject*)param frame:(CGRect)frame
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:frame];
    if ([param isKindOfClass:[UIColor class]]) {
        UIColor *color = (UIColor*)param;
        [line setBackgroundColor:color];
        //[line setAlpha:0.5];
    }else if ([param isKindOfClass:[UIImage class]]){
        UIImage *image = (UIImage*)param;
        [line setImage:image];
    }
    return line;
}

-(void)addTitleWithTitle:(NSString*) title withRightView:(UIView*)rightView
{
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    
    UIImageView *titleBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar.png"]];
    [titleBg setFrame:CGRectMake(0, 0, titleView.frame.size.width, 40)];
    [titleView addSubview:titleBg];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((titleView.frame.size.width-100)/2, 10, 100, 20)];
    [titleLabel setBackgroundColor:color(clearColor)];
    [titleLabel setTextColor:color(whiteColor)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [titleLabel setText:title];
    [titleView addSubview:titleLabel];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 3, 36, 34)];
    [backBtn setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(returnToPrevView:)forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backBtn];
    [self.contentView addSubview:titleView];
    
    if(rightView){
        [self.contentView addSubview:rightView];
    }
}

-(void)addLoadingView
{
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewWidth(_contentView), viewHeight(_contentView))];
    loadingView.tag = LOADING_VIEW_TAG;
    [loadingView setBackgroundColor:bgColor];
    
    UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [progressView setHidesWhenStopped:NO];
    [progressView setCenter:CGPointMake(self.contentView.frame.size.width /2.0, self.contentView.frame.size.height/2.0)];
    [progressView startAnimating];
    [loadingView addSubview:progressView];
    
    [_contentView addSubview:loadingView];
}

-(void)removeLoadingView
{
    UIView *view = [_contentView viewWithTag:LOADING_VIEW_TAG];
    [view removeFromSuperview];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view setAutoresizesSubviews:NO];
    [self.view setAutoresizingMask:UIViewAutoresizingNone];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end












