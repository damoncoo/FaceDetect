
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define m_durationInterval 0.16667f

// Callback
typedef void(^GenericCallback)(BOOL success, id result);

@interface CaptureViewController : UIViewController
{
    
}
@property (nonatomic, copy) void(^doneButtonActionBlock)(NSArray *imagesArray, CGFloat totalDuration);
@property (nonatomic, copy) void(^cancelButtonActionBlock)(BOOL shouldGTUser);

@property (nonatomic, retain) NSString *activityId; // 活动Id
@property (nonatomic, assign) BOOL useCustom; // 和活动一起的

@property (nonatomic, copy) void(^saveAndJoinActionBlock)(NSString *url); // 保存并参加活动

@property (nonatomic, copy) void(^saveAndGoToCommentBlock)(id result); // 保存并评论的回调


@end
