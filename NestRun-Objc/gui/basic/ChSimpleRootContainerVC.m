//
//  ChSimpleRootContainerVC.m
//  AppComps
//
//  Created by Dmitry Demenchoock on 09/06/15.
//  Copyright (c) 2015 UAB Mechanikus. All rights reserved.
//

#import "ChSimpleRootContainerVC.h"

@interface ChSimpleRootContainerVC()

    - (void) showVC:(UIViewController*)child_vc;
    - (void) hideVC:(UIViewController*)child_vc;
    - (void) slideVC:(UIViewController*)next overVC:(UIViewController*)present withAnimationDescriptor:(NSDictionary*)adescriptor;
    - (void) transitVC:(UIViewController*)next overVC:(UIViewController*)present withAnimationDescriptor:(NSDictionary*)adescriptor;

@end

@implementation ChSimpleRootContainerVC
{
    BOOL _transitionInProgress;
    UIViewController* _currentlyPresented;
}

#pragma mark - CHILD CONTROLLERS MANAGEMENT

/**
 *   Метод обеспечивает замещение текущего чайл-контроллера на указанный с указанной анимацией
 */
- (void) replacePresentVCwithVC:(UIViewController*)next withAnimation:(ChSimpleRootContainerReplacementAnimation)animation
{
    if(_transitionInProgress) return;
    NSDictionary* a_descriptor = @{
                                       RRA_ID       :@(animation),
                                       RRA_OPTS     :@(UIViewAnimationOptionCurveEaseInOut),
                                       RRA_TIME     :@(0.5),
                                       RRA_X_OVERRUN:@(0),
                                       RRA_Y_OVERRUN:@(0)
                                  };
    [self replacePresentVCwithVC:next withAnimationDescriptor:a_descriptor];
}

- (void) replacePresentVCwithVC:(UIViewController*)next withAnimationDescriptor:(NSDictionary*)adescriptor
{
    if(_transitionInProgress) return;
    _transitionInProgress = YES;
    ChSimpleRootContainerReplacementAnimation animation = (ChSimpleRootContainerReplacementAnimation)[(NSNumber*)(adescriptor[RRA_ID]) integerValue];

    if(!_currentlyPresented || !next) animation=rra_NoAnimation;
    
    switch(animation)
    {
        case rra_NoAnimation:
            //if(self.childViewControllers.count!=0) [self hideVC:self.childViewControllers[0]];
            if(_currentlyPresented) [self hideVC:_currentlyPresented];
            if(next) [self showVC:next];
            _transitionInProgress = NO;
            break;
        case rra_SlideLeft:
        case rra_SlideRight:
        case rra_SlideUp:
        case rra_SlideDown:
        case rra_SlideOverLeft:
        case rra_SlideOverRight:
        case rra_SlideOverUp:
        case rra_SlideOverDown:
        case rra_SlideHideLeft:
        case rra_SlideHideRight:
        case rra_SlideHideUp:
        case rra_SlideHideDown:
            [self slideVC:next overVC:_currentlyPresented withAnimationDescriptor:adescriptor];
            break;
        case rra_FlipHLeft:
        case rra_FlipHRight:
        case rra_FlipVTop:
        case rra_FlipVBottom:
        case rra_Dissolve:
            [self transitVC:next overVC:_currentlyPresented withAnimationDescriptor:adescriptor];
            break;
        case rra_ZoomInFade:
        case rra_ZoomOutFade:
            [self customTransitVC:next overVC:_currentlyPresented withAnimationDescriptor:adescriptor];
            break;
            
    }
    _currentlyPresented = next;
}

- (void) showVC:(UIViewController*)child_vc
{
    [self willPresentNewChild:child_vc];
    [self addChildViewController:child_vc];
    child_vc.view.frame = self.view.frame;
    [self.view insertSubview:child_vc.view atIndex:self.view.subviews.count];
    [self didAddNewChildSubview:child_vc.view];
    [child_vc didMoveToParentViewController:self];
    [self didPresentNewChild:child_vc];
}
- (void) hideVC:(UIViewController*)child_vc
{
    [child_vc willMoveToParentViewController:nil];
    [child_vc.view removeFromSuperview];
    [child_vc removeFromParentViewController];
}


/**
 *  Метод выполняет замещение текущего чайлд-контроллера указанным с использованием метода transitionFromViewController для слайд-анимации
 */
- (void) slideVC:(UIViewController*)next overVC:(UIViewController*)present withAnimationDescriptor:(NSDictionary*)adescriptor
{
    
    ChSimpleRootContainerReplacementAnimation animation = (ChSimpleRootContainerReplacementAnimation)[(NSNumber*)(adescriptor[RRA_ID]) integerValue];
    UIViewAnimationOptions aoptions = (UIViewAnimationOptions)[(NSNumber*)(adescriptor[RRA_OPTS]) integerValue];
    double duration  = [(NSNumber*)(adescriptor[RRA_TIME]) doubleValue];
    double x_overrun = [(NSNumber*)(adescriptor[RRA_X_OVERRUN]) doubleValue];
    double y_overrun = [(NSNumber*)(adescriptor[RRA_Y_OVERRUN]) doubleValue];
    
    CGRect new_start_frame, old_finish_frame, old_start_frame;
    old_start_frame = present.view.frame;
    
    BOOL slide_over = NO;
    BOOL slide_hide = NO;
    switch(animation)
    {
        // Slide present and pull next
        case rra_SlideLeft:
            new_start_frame  = CGRectMake( self.view.frame.size.width + x_overrun, 0, self.view.frame.size.width, self.view.frame.size.height);
            old_finish_frame = CGRectMake(-self.view.frame.size.width - x_overrun, 0, self.view.frame.size.width, self.view.frame.size.height);
            break;
        case rra_SlideRight:
            new_start_frame  = CGRectMake(-self.view.frame.size.width - x_overrun, 0, self.view.frame.size.width, self.view.frame.size.height);
            old_finish_frame = CGRectMake( self.view.frame.size.width + x_overrun, 0, self.view.frame.size.width, self.view.frame.size.height);
            break;
        case rra_SlideUp:
            new_start_frame  = CGRectMake(0, self.view.frame.size.height + y_overrun, self.view.frame.size.width, self.view.frame.size.height);
            old_finish_frame = CGRectMake(0,-self.view.frame.size.height - y_overrun, self.view.frame.size.width, self.view.frame.size.height);
            break;
        case rra_SlideDown:
            new_start_frame  = CGRectMake(0,-self.view.frame.size.height - y_overrun, self.view.frame.size.width, self.view.frame.size.height);
            old_finish_frame = CGRectMake(0, self.view.frame.size.height + y_overrun, self.view.frame.size.width, self.view.frame.size.height);
            break;
        // Slide present and reveal next
        case rra_SlideOverLeft:
            slide_over = YES;
            old_finish_frame = CGRectMake(-self.view.frame.size.width - x_overrun, 0, self.view.frame.size.width, self.view.frame.size.height);
            break;
        case rra_SlideOverRight:
            slide_over = YES;
            old_finish_frame = CGRectMake( self.view.frame.size.width + x_overrun, 0, self.view.frame.size.width, self.view.frame.size.height);
            break;
        case rra_SlideOverUp:
            slide_over = YES;
            old_finish_frame = CGRectMake(0,-self.view.frame.size.height - y_overrun, self.view.frame.size.width, self.view.frame.size.height);
            break;
        case rra_SlideOverDown:
            slide_over = YES;
            old_finish_frame = CGRectMake(0, self.view.frame.size.height + y_overrun, self.view.frame.size.width, self.view.frame.size.height);
            break;
            // Slide next and hide present
        case rra_SlideHideLeft:
            slide_hide = YES;
            new_start_frame  = CGRectMake( self.view.frame.size.width + x_overrun, 0, self.view.frame.size.width, self.view.frame.size.height);
            old_finish_frame = present.view.frame;
            break;
        case rra_SlideHideRight:
            slide_hide = YES;
            new_start_frame  = CGRectMake(-self.view.frame.size.width - x_overrun, 0, self.view.frame.size.width, self.view.frame.size.height);
            old_finish_frame = present.view.frame;
            break;
        case rra_SlideHideUp:
            slide_hide = YES;
            new_start_frame  = CGRectMake(0, self.view.frame.size.height + y_overrun, self.view.frame.size.width, self.view.frame.size.height);
            old_finish_frame = present.view.frame;
            break;
        case rra_SlideHideDown:
            slide_hide = YES;
            new_start_frame  = CGRectMake(0,-self.view.frame.size.height - y_overrun, self.view.frame.size.width, self.view.frame.size.height);
            old_finish_frame = present.view.frame;
            break;
        default: return;
    }
    
    [present willMoveToParentViewController:nil];
    [self willPresentNewChild:next];
    [self addChildViewController:next];
    next.view.frame = (slide_over)?present.view.frame:new_start_frame;
    
    [self addToHierarchy:next toReplace:present presentOver:slide_over];

    [self transitionFromViewController: present toViewController:next
                              duration: duration
                               options: aoptions
                            animations:^
                             {
                                 if(!slide_over) next.view.frame = old_start_frame;
                                 present.view.frame = old_finish_frame;
                             }
                            completion:^(BOOL finished)
                             {
                                 [present removeFromParentViewController];
                                 [next didMoveToParentViewController:self];
                                 _transitionInProgress = NO;
                                 [self didPresentNewChild:next];
                             }];
}

/**
 *  Метод выполняет замещение текущего чайлд-контроллера указанным с использованием метода transitionFromView для флип- и дисолв-анимации
 */
- (void) transitVC:(UIViewController*)next overVC:(UIViewController*)present withAnimationDescriptor:(NSDictionary*)adescriptor
{
    ChSimpleRootContainerReplacementAnimation animation = (ChSimpleRootContainerReplacementAnimation)[(NSNumber*)(adescriptor[RRA_ID]) integerValue];
    UIViewAnimationOptions aoptions = (UIViewAnimationOptions)[(NSNumber*)(adescriptor[RRA_OPTS]) integerValue];
    double duration  = [(NSNumber*)(adescriptor[RRA_TIME]) doubleValue];
    
    UIViewAnimationOptions opts = 0;
    
    if     (animation==rra_FlipHLeft  ) opts = UIViewAnimationOptionTransitionFlipFromLeft;
    else if(animation==rra_FlipHRight ) opts = UIViewAnimationOptionTransitionFlipFromRight;
    else if(animation==rra_FlipVTop)    opts = UIViewAnimationOptionTransitionFlipFromTop;
    else if(animation==rra_FlipVBottom) opts = UIViewAnimationOptionTransitionFlipFromBottom;
    else if(animation==rra_Dissolve   ) opts = UIViewAnimationOptionTransitionCrossDissolve;
    
    [present willMoveToParentViewController:nil];
    [self willPresentNewChild:next];
    [self addChildViewController:next];
    next.view.frame = present.view.frame;
    
    [self addToHierarchy:next toReplace:present presentOver:NO];
    
    [UIView transitionFromView:present.view
                        toView:next.view
                      duration:duration
                       options:opts | aoptions
                    completion:^(BOOL finished)
                     {
                         [present.view removeFromSuperview];
                         [present removeFromParentViewController];
                         [next didMoveToParentViewController:self];
                         [self didPresentNewChild:next];
                         _transitionInProgress = NO;
                     }];
}

/**
 *  Метод выполняет замещение текущего чайлд-контроллера указанным с использованием кастомной анимации
 */
#warning TODO!!! 
// Переименовать метод, он судя по всему только зум и будет делать
- (void) customTransitVC:(UIViewController*)next overVC:(UIViewController*)present withAnimationDescriptor:(NSDictionary*)adescriptor
{
    ChSimpleRootContainerReplacementAnimation animation = (ChSimpleRootContainerReplacementAnimation)[(NSNumber*)(adescriptor[RRA_ID]) integerValue];
    UIViewAnimationOptions aoptions = (UIViewAnimationOptions)[(NSNumber*)(adescriptor[RRA_OPTS]) integerValue];
    double duration  = [(NSNumber*)(adescriptor[RRA_TIME]) doubleValue];
    
    CGAffineTransform transform_from, transform_to;
    UIView* view_to_transform;
    
    #warning HARDCODED VALUES
    if (animation == rra_ZoomInFade)
    {
        transform_from = CGAffineTransformIdentity;
        transform_to   = CGAffineTransformScale(present.view.transform, 1.5, 1.5);
        view_to_transform = present.view;
    }
    else if (animation == rra_ZoomOutFade)
    {
        transform_from = CGAffineTransformScale(present.view.transform, 1.5, 1.5);
        transform_to   = CGAffineTransformIdentity;
        view_to_transform = next.view;
    }
    
    [present willMoveToParentViewController:nil];
    [self willPresentNewChild:next];
    [self addChildViewController:next];
    next.view.frame = present.view.frame;
    
    [self addToHierarchy:next toReplace:present presentOver:YES];
    
    view_to_transform.transform = transform_from;
    
    [UIView animateWithDuration:duration delay:0 options:aoptions animations:^{
        present.view.alpha = 0;
        view_to_transform.transform = transform_to;
    } completion:^(BOOL finished) {
        [present.view removeFromSuperview];
        [present removeFromParentViewController];
        [next didMoveToParentViewController:self];
        [self didPresentNewChild:next];
        _transitionInProgress = NO;
    }];
}

/**
 *  Метод добавляет вью нового контроллера в иерархию и опционально помещает указанный параметром tofront вью на фронт
 *  Это добавление вью в иерархию - очень ответственная процедура. Дело в том что в разных ситуация она должна выполняться
 *  в разные моменты по отношению к анимации которая вызывается после этого.
 *  В частности, если нам необходимо после добавлению нового вью выполнить манипуляции с контейнером ДО начала анимации - переместить
 *  на фронт некоторые контейнерные вью, например в методе didAddNewChildSubview то вызов надо завернуть в dispatch_async как в этом
 *  методе и делается.
 *  Но оказывается, что если добавления вью вызывается таким способом, то при транзите навигационного контроллера вью окажется в иерархии
 *  не тогда когда надо и при транзите будет совершенно по идиотские ехать навигационный бар.
 *  Совместить эти варианты в одной реализации у меня не получилось поэтому я вынес этот кусок кода в отдельный метод. Наследник может перекрыть 
 *  его и отказаться от dispatch_async совсем, если контроллер используется для транзишена нав-контроллеров, или сделать реализацию зависящей
 *  от типа контроллера, который транзитится
 *  ВАЖНО: на момент вызова этого метода новый вью-контроллер оказывается полностью инициализированным после вставки в контейнер
 *  по этой причине в точку вызова этого метода лучше добавить дополнительный хэндлер, а это методо оставить для перекрытия только с описанными выше целями
 */
- (void) addToHierarchy:(UIViewController*)next toReplace:(UIViewController*)present presentOver:(BOOL)over
{
     dispatch_async(dispatch_get_main_queue(),
     ^{
        if(over) [self.view insertSubview:next.view belowSubview:present.view];
        else     [self.view insertSubview:next.view aboveSubview:present.view];
        [self didAddNewChildSubview:next.view];
     });
}

- (void) willPresentNewChild:(UIViewController*)child
{
    
}
- (void) didPresentNewChild:(UIViewController*)child
{
    
}
- (void) didAddNewChildSubview:(UIView*)child_view
{
    
}

@end
