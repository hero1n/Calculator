//
//  ViewController.h
//  Calculator
//
//  Created by Jaewon on 2015. 4. 20..
//  Copyright (c) 2015년 App:ple Pi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    STATUS_DEFAULT=0,
    STATUS_DIVISION,
    STATUS_MULTPLY,
    STATUS_MINUS,
    STATUS_PLUS,
    STATUS_RETURN,
}kStatusCode;

@interface ViewController : UIViewController {
    double curValue;
    double totalCurValue;
    bool isPoint;
    bool isMaxSize;
    NSString *curInputValue;
    NSMutableArray *historyValue;
    kStatusCode curStatusCode;
}

- (IBAction)digitPressed:(UIButton *)sender;
- (IBAction)operationPressed:(UIButton *)sender;

@property Float64 curValue;
@property Float64 totalCurValue;
@property kStatusCode curStatusCode;

@property (strong, nonatomic) IBOutlet UILabel *displayLabel;
@property (strong, nonatomic) IBOutlet UILabel *subLabel;




@end

