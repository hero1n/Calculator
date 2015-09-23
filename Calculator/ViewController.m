//
//  ViewController.m
//  Calculator
//
//  Created by Jaewon on 2015. 4. 20..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize curValue;
@synthesize totalCurValue;
@synthesize curStatusCode;
@synthesize displayLabel;
@synthesize subLabel;

- (void)viewDidLoad {
    [self ClearCalculation];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//회전 X
-(BOOL)shouldAutorotate{
    return NO;
}

//글씨수에 따른 레이블 크기 조절
-(void)CheckLabelSize:(NSString *)displayText{
    NSLog(@"%@ %d %s",displayText,__LINE__,__PRETTY_FUNCTION__);
    if(displayText.length < 7){
        displayLabel.font = [displayLabel.font fontWithSize:56];
    }else if(displayText.length < 9){
        displayLabel.font = [displayLabel.font fontWithSize:51];
    }else if(displayText.length < 11){
        displayLabel.font = [displayLabel.font fontWithSize:46];
    }else{
        displayLabel.font = [displayLabel.font fontWithSize:41];
        isMaxSize = YES;
    }
}

-(void)DisplayHistroy:(NSString *)displayText{
    [historyValue addObject:displayText];
    NSLog(@"%@",[historyValue description]);
    NSMutableString *result = [[NSMutableString alloc]init];
    for(NSObject *obj in historyValue){
        [result appendString:[obj description]];
    }
    [subLabel setText:result];
}

//화면 레이블 출력(변경)
-(void)DisplayInputValue:(NSString *)displayText{
    if(!isMaxSize){
        NSString *CommaText;
        //받아온 숫자에 ,찍기
        [self CheckLabelSize:displayText];
        CommaText = [self ConvertComma:displayText];
        [displayLabel setText:CommaText];
    }
}

//현재 써져있는 값 형변환 후 비우기(계산완료)
-(void)DisplayCalculationValue{
        NSString *displayText;
        displayText = [NSString stringWithFormat:@"%g",totalCurValue];
        NSLog(@"%@ %d %s",displayText,__LINE__,__PRETTY_FUNCTION__);
        [self DisplayHistroy:curInputValue];
        [self DisplayInputValue:displayText];
        curInputValue = @"";
}

//값 전부 비우기
-(void)ClearCalculation{
    historyValue = [[NSMutableArray alloc]init];
    curInputValue = @"0";
    curValue = 0;
    totalCurValue = 0;
    [historyValue removeAllObjects];
    [self DisplayHistroy:@""];
    isPoint = NO;
    isMaxSize = NO;
    //결과값까지 0으로 만듬
    [self DisplayInputValue:curInputValue];
    
    //기본상태로
    curStatusCode = STATUS_DEFAULT;
}

-(void)SignCalculation{
    NSLog(@"%@ %d %s",curInputValue,__LINE__,__PRETTY_FUNCTION__);
    curValue = [curInputValue doubleValue];
    //totalCurValue = 0 - curValue;
    //curValue = totalCurValue;
    curValue = 0 - curValue;
    
    
    NSLog(@"%f %d",curValue,__LINE__);
    NSLog(@"%f %d",totalCurValue,__LINE__);
    curInputValue = [NSString stringWithFormat:@"%g",curValue];
    
    NSLog(@"%f %d",curValue,__LINE__);
    NSLog(@"%f %d",totalCurValue,__LINE__);
    [self DisplayInputValue:curInputValue];
}

//3자리마다 점찍기
-(NSString *)ConvertComma:(NSString *)data{
    //아무것도 안써져있으면 nil 반환
    if(data == nil)
        return nil;
    //세자리 이하라 필요없으면 그대로 반환
    if([data length] <= 3)
        return data;
    
    NSString *integerString = nil;
    NSString *floatString = nil;
    NSString *minusString = nil;
    
    //소수점 찾기
    NSRange pointRange = [data rangeOfString:@"."];
    //소수점이 없을경우 문자열은 그대로
    if(pointRange.location == NSNotFound){
        integerString = data;
    }
    //소수점이 있으면 정수부와 소수부 나누기
    else{
        NSRange r;
        r.location = pointRange.location;
        r.length = [data length] - pointRange.location;
        floatString = [data substringWithRange:r];
        
        //유효숫자 판별 (노의미 0 없애기)
        NSMutableString *floatStringConvert = [[NSMutableString alloc]init];
        int floatStringLength = [floatString length];
        int idx = 0;
        
        if(floatStringLength > 1){
            while(idx < floatStringLength){
                [floatStringConvert appendFormat:@"%C",[floatString characterAtIndex:idx]];
                idx++;
            }
            while(idx > 0){
                if([floatStringConvert characterAtIndex:idx - 1] == '0'){
                    NSLog(@"%@ %d",floatStringConvert,__LINE__);
                    [floatStringConvert deleteCharactersInRange:NSMakeRange([floatStringConvert length]-1, 1)];
                    idx--;
                }else{
                    break;
                }
            }
        }
        
        r.location = 0;
        r.length = pointRange.location;
        integerString = [data substringWithRange:r];
    }
    
    NSRange minusRange = [integerString rangeOfString:@"-"];
    if(minusRange.location != NSNotFound){
        minusString = @"-";
        integerString = [integerString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    NSMutableString *integerStringCommaInserted = [[NSMutableString alloc]init];
    int integerStringLength = [integerString length];
    int idx=0;
    while(idx < integerStringLength){
        [integerStringCommaInserted appendFormat:@"%C",[integerString characterAtIndex:idx]];
        if((integerStringLength - (idx+1))%3 == 0 && integerStringLength != (idx + 1)){
            [integerStringCommaInserted appendString:@","];
        }
        idx ++;
    }
    
    NSMutableString *returnString = [[NSMutableString alloc]init];
    if(minusString != nil)
        [returnString appendString:minusString];
    if(integerStringCommaInserted != nil)
        [returnString appendString:integerStringCommaInserted];
    if(floatString != nil)
        [returnString appendString:floatString];
    
    return returnString;
}

-(IBAction)digitPressed:(UIButton *)sender{
    NSString *numPoint = [[sender titleLabel] text];
    
    //첫 숫자가 0이거나 .이 아닐때, 첫 숫자로 덮어씌움
    if([displayLabel.text isEqual: @"0"] && ![numPoint isEqual:@"."] ){
        NSLog(@"덮어씌우기요 %@ %@",curInputValue,numPoint);
        curInputValue = @"";
    }
    
    if([numPoint isEqual:@"."]){
        NSLog(@"numPoint isEqual");
        if(!isPoint){
            curInputValue = [curInputValue stringByAppendingFormat:numPoint];
            isPoint = YES;
        }
    }else{
        NSLog(@"numPoint else");
            curInputValue = [curInputValue stringByAppendingFormat:numPoint];
    }
    [self DisplayInputValue:curInputValue];
}

-(IBAction)operationPressed:(UIButton *)sender{
    NSString *operationText = [[sender titleLabel] text];
    
    if([@"＋" isEqualToString:operationText]){
        [self Calculation:curStatusCode CurStatusCode:STATUS_PLUS];
    }
    
    if([@"－" isEqualToString:operationText]){
        [self Calculation:curStatusCode CurStatusCode:STATUS_MINUS];
    }

    if([@"×" isEqualToString:operationText]){
        [self Calculation:curStatusCode CurStatusCode:STATUS_MULTPLY];
    }

    if([@"÷" isEqualToString:operationText]){
        [self Calculation:curStatusCode CurStatusCode:STATUS_DIVISION];
    }

    if([@"C" isEqualToString:operationText]){
        [self ClearCalculation];
    }

    if([@"=" isEqualToString:operationText]){
        [self Calculation:curStatusCode CurStatusCode:STATUS_RETURN];
    }
    
    if([@"±" isEqualToString:operationText]){
        [self SignCalculation];
    }
}

-(void)Calculation:(kStatusCode)StatusCode CurStatusCode:(kStatusCode)cStatusCode;{
    switch(StatusCode){
        case STATUS_DEFAULT:
            [self DefaultCalculation];
            break;
        case STATUS_DIVISION:
            [self DivisionCalculation];
            break;
        case STATUS_MULTPLY:
            [self MultiplyCalculation];
            break;
        case STATUS_PLUS:
            [self PlusCalculation];
            break;
        case STATUS_MINUS:
            [self MinusCalculation];
            break;
    }
    curStatusCode = cStatusCode;
}

-(void)DefaultCalculation{
    curValue = [curInputValue doubleValue];
    totalCurValue = curValue;
    
    [self DisplayCalculationValue];
}

-(void)PlusCalculation{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue + curValue;
    [self DisplayHistroy:@"+"];
    [self DisplayCalculationValue];
}

-(void)MinusCalculation{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue - curValue;
    [self DisplayHistroy:@"-"];
    [self DisplayCalculationValue];
}

-(void)MultiplyCalculation{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue * curValue;
    [self DisplayHistroy:@"×"];
    [self DisplayCalculationValue];
}

-(void)DivisionCalculation{
    curValue = [curInputValue doubleValue];
    totalCurValue = totalCurValue / curValue;
    [self DisplayHistroy:@"÷"];
    [self DisplayCalculationValue];
}

@end
