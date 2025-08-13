//
//  SceneDelegate.m
//  pinan-demo
//
//  Created by nagain on 2025/8/12.
//

#import "SceneDelegate.h"
#import "MainViewController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        
        // 创建主视图控制器
        MainViewController *mainViewController = [[MainViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        
        // 设置导航栏样式
        if (@available(iOS 13.0, *)) {
            UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
            [appearance configureWithOpaqueBackground];
            appearance.backgroundColor = [UIColor systemBackgroundColor];
            appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor labelColor]};
            
            navigationController.navigationBar.standardAppearance = appearance;
            navigationController.navigationBar.scrollEdgeAppearance = appearance;
        } else {
            // iOS 12 fallback
            navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        }
        
        navigationController.navigationBar.prefersLargeTitles = YES;
        
        self.window.rootViewController = navigationController;
        [self.window makeKeyAndVisible];
    }
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
