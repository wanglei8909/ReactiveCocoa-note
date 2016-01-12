//
//  ViewController.m
//  ReactvieCocoaTest
//
//  Created by 王蕾 on 16/1/8.
//  Copyright © 2016年 Apple inc. All rights reserved.
//

#import "ViewController.h"
#import "DummySignInService.h"

@interface ViewController ()

@property (retain, nonatomic)UITextField *usernameTextField;
@property (retain, nonatomic)UITextField *passwordTextField;
@property (retain, nonatomic)UIButton *signInButton;
@property (retain, nonatomic)UILabel *signInFailureText;

@property (strong, nonatomic)DummySignInService *signInService;

//@property (nonatomic) BOOL passwordIsValid;
//@property (nonatomic) BOOL usernameIsValid;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"登陆";
    [self setUpUI];
    
    self.signInService = [DummySignInService new];
    
//    [self updateUIState];
    
//    [self.usernameTextField addTarget:self action:@selector(usernameTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
//    [self.passwordTextField addTarget:self action:@selector(passwordTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
//    
    self.signInFailureText.hidden = YES;
    
//    [self.usernameTextField.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
//    
//    [[self.usernameTextField.rac_textSignal filter:^BOOL(id value) {
//        NSString *text = value;
//        return text.length > 3;
//    }]
//     subscribeNext:^(id x) {
//         NSLog(@"大于3位了---》%@",x);
//    }];
    
    //分开如下
//    RACSignal *usernameSourceSignal = self.usernameTextField.rac_textSignal;
//    
//    RACSignal *filteredUsername = [usernameSourceSignal filter:^BOOL(id value){
//                                      NSString*text = value;
//                                      return text.length > 3;
//                                  }];
//    
//    [filteredUsername subscribeNext:^(id x){
//        NSLog(@"%@", x);
//    }];
//    
//    [[[self.usernameTextField.rac_textSignal map:^id(NSString *text) {
//        return @(text.length);
//    }]
//    filter:^BOOL(NSNumber *length) {
//        return [length integerValue]>3;
//    }]
//    subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
    RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
    }];
    RACSignal *validpasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
//    [[validpasswordSignal map:^id(NSNumber *passwordValid){
//        return [passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
//    }] subscribeNext:^(UIColor *color){
//        self.passwordTextField.backgroundColor = color;
//    }];
    
    RAC(self.passwordTextField, backgroundColor) = [validpasswordSignal map:^id(NSNumber *passwordValid){
        return [passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
    }];
    RAC(self.usernameTextField, backgroundColor) = [validUsernameSignal map:^id(NSNumber *usernameValid){
        return [usernameValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
    }];
    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal,validpasswordSignal] reduce:^id(NSNumber *usernameValid,NSNumber *passwordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.signInButton.enabled = [signupActive boolValue];
    }];
    
    
    //button 事件
//    [[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"clicked");
//    }];
    
    // 这个操作把按钮点击事件转换为登录信号，同时还从内部信号发送事件到外部信号。
//    [[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//      flattenMap:^id(id x) {
//        return [self singnInSignal];
//      }]
//      subscribeNext:^(id x) {
//        NSLog(@"result:%@",x);
//    }];

    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        NSLog(@"doNext");
        self.signInButton.enabled = NO;
        self.signInFailureText.hidden = YES;
    }] flattenMap:^RACStream *(id value) {
        NSLog(@"flattenMap");
        return [self singnInSignal];
    }] subscribeNext:^(NSNumber *signedIn) {
        NSLog(@"subscribeNext");
        self.signInButton.enabled = YES;
        BOOL success =[signedIn boolValue];
        self.signInFailureText.hidden = success;
        if (success) {
            NSLog(@"登陆成功");
        }
    }];
}

- (RACSignal *)singnInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInService signInWithUsername:self.usernameTextField.text password:self.passwordTextField.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}


//- (void)usernameTextFieldChanged {
//    self.usernameIsValid = [self isValidUsername:self.usernameTextField.text];
//    [self updateUIState];
//}
//
//- (void)passwordTextFieldChanged {
//    self.passwordIsValid = [self isValidPassword:self.passwordTextField.text];
//    [self updateUIState];
//}
//
//- (void)updateUIState {
////    self.usernameTextField.backgroundColor = self.usernameIsValid ? [UIColor clearColor] : [UIColor yellowColor];
////    self.passwordTextField.backgroundColor = self.passwordIsValid ? [UIColor clearColor] : [UIColor yellowColor];
//    self.signInButton.enabled = self.usernameIsValid && self.passwordIsValid;
//}


- (void)setUpUI{
    for (int i = 0; i<2; i++) {
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(50, i*50+110, self.view.bounds.size.width-100, 40)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = i==0?@"username":@"password";
        [self.view addSubview:textField];
        if (i==0) self.usernameTextField = textField;
        else self.passwordTextField = textField;
    }
    
    self.signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signInButton.frame = CGRectMake(self.view.bounds.size.width-100, 100+110, 50, 30);
    [self.signInButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.signInButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.signInButton setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self.view addSubview:self.signInButton];
    
    self.signInFailureText = [[UILabel alloc]initWithFrame:CGRectMake(50, 100+110, 50, 30)];
    self.signInFailureText.text = @"错误";
    [self.view addSubview:self.signInFailureText];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

























