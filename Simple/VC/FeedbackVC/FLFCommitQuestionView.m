//
//  FLFCommitQuestionView.m
//  Fanli
//
//  Created by shaoqing.fan on 2016/11/17.
//  Copyright © 2016年 www.fanli.com. All rights reserved.
//
#import "FLFCommitQuestionView.h"
#import "SIMImageEditDefine.h"

@interface FLFCommitQuestionView ()<UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *proposalText;
@property (weak, nonatomic) IBOutlet UITextField *telephoneField;


@end

@implementation FLFCommitQuestionView

+ (void)addCommitQuestionViewWithImage:(UIImage *)image
{
    if (nil == image)return;
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"FLFCommitQuestionView" owner:nil options:nil];
    FLFCommitQuestionView *view = (FLFCommitQuestionView *)[nibContents lastObject];
    if (nil != view)
    {
        view.screenShot.image = image;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *coverView = [[UIView alloc]initWithFrame:window.bounds];
        coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [window addSubview:coverView];
        coverView.tag = SIMViewTagCoverViewTag;
        
        CGRect rect = view.frame;
        rect.origin.x = (window.bounds.size.width - rect.size.width) / 2.0;
        rect.origin.y = (window.bounds.size.height - rect.size.height) / 2.0;
        view.frame = rect;
        [coverView addSubview:view];
    }
}


- (void)dealloc
{
	self.proposalText = nil;
	self.screenShot = nil;
	self.telephoneField = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	self.proposalText.delegate = self;
	self.telephoneField.delegate = self;
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 1)];
    self.telephoneField.leftViewMode = UITextFieldViewModeAlways;
    self.telephoneField.leftView = leftView;
	[self.proposalText becomeFirstResponder];
    self.layer.cornerRadius = 4.0;
    [self setClipsToBounds:YES];
    
    [self addPlaceholderForTextView];
    [self addTextCountViewForTextView];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)addPlaceholderForTextView
{
    UILabel *placeholder = [[UILabel alloc]initWithFrame:CGRectMake(5, 4, 120, 25)];
    [placeholder setTextColor:[UIColor colorWithWhite:0 alpha:0.3]];
    placeholder.tag = SIMViewTagTextViewPlaceHolderTag;
    placeholder.text = @"请输入反馈意见";
    [placeholder setFont:[UIFont systemFontOfSize:14.0]];
    [self.proposalText addSubview:placeholder];
}

- (void)addTextCountViewForTextView
{
    UILabel *textCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.proposalText.frame.size.width - 100 + 12, self.proposalText.frame.size.height + 18 + 5, 100, 25)];
    [textCountLabel setTextColor:[UIColor colorWithWhite:0 alpha:0.3]];
    [textCountLabel setFont:[UIFont systemFontOfSize:12.0]];
    [textCountLabel setTextAlignment:NSTextAlignmentRight];
    textCountLabel.tag = SIMViewTagTextCountTag;
    textCountLabel.text = [NSString stringWithFormat:@"0/%ld",MAXTextCount];
    [self addSubview:textCountLabel];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
	//获取键盘高度
	NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
	
	CGRect keyboardRect;
	
	[keyboardObject getValue:&keyboardRect];
	
	CGRect frame = self.frame;
	frame.origin.x = (ScreenWidth - frame.size.width) / 2;
	frame.origin.y = ScreenHeight - keyboardRect.size.height - frame.size.height - 30;
	self.frame = frame;
}

# pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([text isEqualToString:@"\n"])
	{
		[textView resignFirstResponder];
		return NO;
	}
	
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSUInteger number = [textView.text length];
    UILabel *textCountLabel = (UILabel *)[self viewWithTag:SIMViewTagTextCountTag];
    if (number > MAXTextCount)
    {
        textView.text = [textView.text substringToIndex:MAXTextCount];
        textCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",MAXTextCount,MAXTextCount];
    }
    else
    {
        textCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",number,MAXTextCount];
    }

    UILabel *placeholderLabel = (UILabel *)[textView viewWithTag:SIMViewTagTextViewPlaceHolderTag];
    placeholderLabel.hidden = number > 0;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[textField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([string isEqualToString:@"\n"])
	{
		[textField resignFirstResponder];
		return NO;
	}
	
	return YES;
}

- (IBAction)cancelProposalQuestion:(id)sender
{
    [self removeCommitQuestionView];
}

- (IBAction)proposalQuestion:(id)sender
{
    [self removeCommitQuestionView];
}

- (void)removeCommitQuestionView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *coverView = [window viewWithTag:SIMViewTagCoverViewTag];
    [coverView removeFromSuperview];
}

@end
