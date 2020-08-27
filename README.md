# AppearanceNavigationController
Sample of navigation controller appearance configuration from our [blog post](https://yalantis.com/blog/declarative-navigation-bar-appearance-configuration/).


#### Declarative Navigation Bar Appearance Configuration

The last couple of month I’ve been working on an app that required implementation of color changing behavior. 

In this app, all users can choose a color for their profile, and the color of the “User Details” navigation bar depends on the avatar. This created a lot of issues in the app development including the need to make a status bar readable on the navigation bar’s background. What’s more, a tool bar in the app can only be visible for users’ friends. 

How do you implement color changing features?

A naive approach was to perform the navigation controller appearance configuration in the `UIViewController.viewWillAppear:`

But with this implementation I shortly found my view controllers full of unnecessary and even odd knowledge, such as navigation bar’s background image names, toolbar’s tint color alpha, and so on. Moreover, this logic was duplicated in several independent classes. 

Given this nuicance I decided to refactor `UIViewController.viewWillAppear` and turn it into a small and handy tool that could free view controllers from repeated imperative appearance configurations. I wanted my implementation to have a UIKit-like declarative style as `UIViewController.preferredStatusBarStyle`. Under this logic, view controllers will be asked the number of questions or requirements that tell them how to behave. 

#### The principle of work of AppearanceNavigationController 

To achieve a declarative behaviour we need to become a UINavigationControllerDelegate to handle push and pop between the view controllers.

In the `navigationController(_:willShowViewController:animated:)` we need to ask view controller that is being shown the following questions: 

- Do we need to display a navigation bar?
- What color should it be?
- Do we need to display a toolbar?
- What color should it be?
- What style for the status bar is preferred?

Let’s turn it into a Swift’s struct: 

```swift
public struct Appearance: Equatable {
    
    public struct Bar: Equatable {
       
        var style: UIBarStyle = .default
        var backgroundColor = UIColor(red: 234 / 255, green: 46 / 255, blue: 73 / 255, alpha: 1)
        var tintColor = UIColor.white
        var barTintColor: UIColor?
    }
    
    var statusBarStyle: UIStatusBarStyle = .default
    var navigationBar = Bar()
    var toolbar = Bar()
}
```
You may have noticed that the flags of the navigation bar and toolbar visibility are missing, and here is why: most of the time I didn’t care about the bars appearance. All I needed is to hide them. Therefore, I decided to keep them separate.
As you remember, we’re going to “ask” our view controller about the preferred apperance. Let’s implement this as follows:

```swift
public protocol NavigationControllerAppearanceContext: class {
    
    func prefersNavigationControllerBarHidden(navigationController: UINavigationController) -> Bool
    func prefersNavigationControllerToolbarHidden(navigationController: UINavigationController) -> Bool
    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance?
}
```

Since not every `UIViewController` will configure appearance, we’re not going to extend `UIViewController` with `AppearanceNavigationControllerContext`. Instead, let’s provide a default implementation using protocol extension introduced in Swift 2.0 so that anyone that confroms to the `NavigationControllerAppearanceContext` can implement only the methods they are interested in:

```swift
extension NavigationControllerAppearanceContext {
    
    func prefersNavigationControllerBarHidden(navigationController: UINavigationController) -> Bool {
        return false
    }
    
    func prefersNavigationControllerToolbarHidden(navigationController: UINavigationController) -> Bool {
        return true
    }
    
    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        return nil
    }
```

As you may have noticed `preferredNavigationControllerAppearance` allows us to return `nil` which is useful to interpret as “Ok, this controller doesn’t want to affect the current appearance”. 

Now let’s implement the basics of our Navigation Controller:
```swift
public class AppearanceNavigationController: UINavigationController, UINavigationControllerDelegate {

    public required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        delegate = self
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        delegate = self
    }

    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        delegate = self
    }
    
    // MARK: - UINavigationControllerDelegate
    
    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController, animated: Bool
    ) {
        guard let appearanceContext = viewController as? NavigationControllerAppearanceContext else {
            return
        }
        setNavigationBarHidden(appearanceContext.prefersNavigationControllerBarHidden(navigationController: self), animated: animated)
        setNavigationBarHidden(appearanceContext.prefersNavigationControllerBarHidden(navigationController: self), animated: animated)
        setToolbarHidden(appearanceContext.prefersNavigationControllerToolbarHidden(navigationController: self), animated: animated)
        applyAppearance(appearance: appearanceContext.preferredNavigationControllerAppearance(navigationController: self), animated: animated)
    }

    // mark: - Appearance Applying
        
    private func applyAppearance(appearance: Appearance?, animated: Bool) {        
        // apply
    }
}
```

#### Appearance Configuration

Now it’s time to implement the appearance applying the details: 

```swift
private func applyAppearance(appearance: Appearance?, animated: Bool) {
    if let appearance = appearance {
        if !navigationBarHidden {
            let background = ImageRenderer.renderImageOfColor(color: appearance.navigationBar.backgroundColor)
            navigationBar.setBackgroundImage(background, for: .default)
            navigationBar.tintColor = appearance.navigationBar.tintColor
            navigationBar.barTintColor = appearance.navigationBar.barTintColor
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: appearance.navigationBar.tintColor
            ]
        }

        if !toolbarHidden {
            toolbar?.setBackgroundImage(
                ImageRenderer.renderImageOfColor(color: appearance.toolbar.backgroundColor),
                forToolbarPosition: .any,
                barMetrics: .default
            )
            toolbar?.tintColor = appearance.toolbar.tintColor
            toolbar?.barTintColor = appearance.toolbar.barTintColor
        }
    }
}
```
If the View Controller’s appearance isn’t nil, we need to apply the apprearance differently – just ignore it. Code, that applies the appearance is fairly simple, except `ImageRenderer.renderImageOfColor(color)` which returns a colored image with 1x1 pixel size.

#### Status bar configuration

Note, that status bar style comes in pair with the `Appearance` and not via `UIViewController.preferredStatusBarStyle()`. This is because a status bar visibility depends on the navigation bar color brightness, so I decided to keep this “knowledge” about colors in a single place instead of putting it in two separate places.

```swift
private var appliedAppearance: Appearance?

private func applyAppearance(appearance: Appearance?, animated: Bool) {
    if let appearance = appearance where appliedAppearance != appearance {
        appliedAppearance = appearance

        // rest of the code

        setNeedsStatusBarAppearanceUpdate()
    }
}

// mark: - Status Bar 

public override var preferredStatusBarStyle: UIStatusBarStyle {
    appliedAppearance?.statusBarStyle ?? super.preferredStatusBarStyle
}

public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
    appliedAppearance != nil ? .fade : super.preferredStatusBarUpdateAnimation
}
```
Since we’re going to use UIKit’s preferred way of Status Bar appearance change, the applied `Appearance` needs to be preserved. Also, if there is no appearance applied we’re switching to the default super’s implementation. 

#### Appearance Update

Obvisouly, the view controller appearance may change during its lifecycle. In order to update the view controller let’s add a UIKit-like method `NavigationControllerAppearanceContext`:

```swift
public protocol NavigationControllerAppearanceContext: class {    
    // rest of the interface

    func setNeedsUpdateNavigationControllerAppearance()
}

extension NavigationControllerAppearanceContext {
    // rest of the defaul implementation

    func setNeedsUpdateNavigationControllerAppearance() {
        if let viewController = self as? UIViewController,
            let navigationController = viewController.navigationController as? AppearanceNavigationController {
            navigationController.updateAppearanceForViewController(viewController: viewController)
        }
    }
}

```
And a corresponding implementation in the `AppearanceNavigationController`:
```swift
func updateAppearanceForViewController(viewController: UIViewController) {
    if let context = viewController as? NavigationControllerAppearanceContext,
        viewController == topViewController && transitionCoordinator == nil {
        setNavigationBarHidden(context.prefersNavigationControllerBarHidden(navigationController: self), animated: true)
        setToolbarHidden(context.prefersNavigationControllerToolbarHidden(navigationController: self), animated: true)
        applyAppearance(appearance: context.preferredNavigationControllerAppearance(navigationController: self), animated: true)
    }
}

public func updateAppearance() {
    if let top = topViewController {
        updateAppearanceForViewController(viewController: top)
    }
}
```
From this point any `AppearanceNavigationControllerContext` can ask its container to re-run the appearance configuration in case something gets changed (editing mode, for example). By various checks like `viewController == topViewController` and `transitionCoordinator() == nil` we’re disallowing appearance change invoked by an invisible view controller or happened during the interactive pop gesture.

#### Usage
We’re done with the implementation. Now any view controller can define an appearance context, change appearance in the middle of the lifecycle and so on:
```swift
class ContentViewController: UIViewController, NavigationControllerAppearanceContext {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    var appearance: Appearance? {
        didSet {
            setNeedsUpdateNavigationControllerAppearance()
        }
    }
    
    // mark: - Actions
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        setNeedsUpdateNavigationControllerAppearance()
    }
    
    // mark: - AppearanceNavigationControllerContent

    func prefersNavigationControllerToolbarHidden(navigationController: UINavigationController) -> Bool {
        // hide toolbar during editing
        return isEditing
    }
    
    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        // inverse navigation bar color and status bar during editing
        return isEditing ? appearance?.inverse() : appearance
    }
}
```
#### Gathering the appearance together

Now we can gather all the appearance configurations as a category with common configurations, thus eliminating code duplication as in the naive solution:
```swift
extension Appearance {
    
    static let lightAppearance: Appearance = {
        var value = Appearance()
        
        value.navigationBar.backgroundColor = .lightGray
        value.navigationBar.tintColor = .white
        value.statusBarStyle = .lightContent
        
        return value
    }()
}
```

#### Customizing the appearance 

To make the animation more customizeable let’s wrap it into the `AppearanceApplyingStrategy`, hence anyone can extend this behaviour by providing a custom strategy:
```swift
public class AppearanceApplyingStrategy {
    
    public func apply(appearance: Appearance?, toNavigationController navigationController: UINavigationController, animated: Bool) {
    }
}

```

And connect the strategy to the `AppearanceNavigationController`:
```swift
private func applyAppearance(appearance: Appearance?, animated: Bool) {
    // we ignore nil appearance
    if appearance != nil && appliedAppearance != appearance {
        appliedAppearance = appearance
        
        appearanceApplyingStrategy.apply(appearance: appearance, toNavigationController: self, animated: animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

public var appearanceApplyingStrategy = AppearanceApplyingStrategy() {
    didSet {
        applyAppearance(appearance: appliedAppearance, animated: false)
    }
}
```

For sure, this solution doesn’t pretend to be a silver bullet, however with this short and simple implementation we have: 

- simplified navigation controller’s appearance configuration
- reduced duplication in code by defining extensions to the `Appearance`
- made our code more UIKit-like
- reduced the number of small and annoying bugs. For example, an accidental status bar style change by MailComposer.
