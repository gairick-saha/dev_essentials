
`DevEssentials` is a Flutter package to provide re-usable widDevs, navigations, extensions, helpers, to help Flutter developers for building apps from the scratch with less efforts. 

Overall, `DevEssentials` will help Flutter Developers to reduce the development time.

<br>

## Get started

Add this to your package's pubspec.yaml file:

```yaml
dev_essentials: '^0.0.1'
```

<br>

### **Install it**

Install `dev_essentials` package by running this command from the command line or terminal:

```
$ flutter pub get
```

Alternatively, your editor might support flutter pub get.

### **Import it**

Now in your Dart code, you can use:

```dart
import 'package:dev_essentials/dev_essentials.dart';
```

## Navigation Managment

If you want to use routes without context, DevEssentials can help you to do that, just see it:


Add "DevEssential" before your MaterialApp, turning it into DevEssentialMaterialApp

```dart
DevEssentialMaterialApp(
    title: 'DevEssential Example',
    home: MyHome(),
)
```

## Navigation without named routes

To navigate to a new screen:

```dart
Dev.to(NextScreen());
```

To close a screen, or anything you would normally close with Navigator.pop(context);

```dart
Dev.back();
```

To go to the next screen and no option to go back to the previous screen.

```dart
Dev.off(NextScreen());
```

To go to the next screen and cancel all previous routes.

```dart
Dev.offAll(NextScreen());
```

To navigate to the next route, and receive or update data as soon as you return from it:

```dart
var data = await Dev.to(Payment());
```

on other screen, send a data for previous route:

```dart
Dev.back(result: 'success');
```

And use it:

ex:

```dart
if(data == 'success') madeAnything();
```

Don't you want to use `dev_essential`'s navigations extensions?
Just change the Navigator (uppercase) to navigator (lowercase), and you will have all the functions of the standard navigation, without having to use context
Example:

```dart

// Default Flutter navigator
Navigator.of(context).push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) {
      return HomePage();
    },
  ),
);

// DevEssential's using Flutter syntax without needing context
navigator.push(
  MaterialPageRoute(
    builder: (_) {
      return HomePage();
    },
  ),
);

// DevEssential's syntax (It is much better, but you have the right to disagree)
Dev.to(HomePage());

```


## Navigation with named routes

- If you prefer to navigate by namedRoutes, DevEssential also supports this.

To define routes, use DevEssentialMaterialApp:

```dart
void main() {
  runApp(
    DevEssentialMaterialApp(
      pages: [
        DevEssentialPage(name: '/home', builder: (context) => HomePage()),
        DevEssentialPage(name: '/second', builder: (context) => Second()),
      ],
    )
  );
}
```

To navigate to nextScreen

```dart
Dev.toNamed("/NextScreen");
```

To navigate and remove the previous screen from the tree.

```dart
Dev.offNamed("/NextScreen");
```

To navigate and remove all previous screens from the tree.

```dart
Dev.offAllNamed("/NextScreen");

```

To handle navigation to non-defined routes (404 error), you can define an unknownRoute page in `DevEssentialMaterialApp`.

```dart
void main() {
  runApp(
    DevEssentialMaterialApp(
      pages: [
        DevEssentialPage(name: '/home', builder: (context) => HomePage()),
        DevEssentialPage(name: '/second', builder: (context) => Second()),
      ],
      unknownRoute: DevEssentialPage(
        name: '/404NotFound',
        builder: (context) => const Scaffold(
          body: Center(
            child: Text("Page not found."),
          ),
        ),
      ),
    ),
  );
}
```

### Send data to named Routes

Just send what you want for arguments.It accepts anything here, whether it is a String, a Map, a List, or even a class instance.

```dart
Dev.toNamed("/NextScreen", arguments: 'DevEssential is the best');
```


`DevEssentialMaterialApp` also provides a predefined customizable splash screen.

Define the splash configuration to enable predefined splash view and restart the application

```dart 
final SplashConfig splashConfig = SplashConfig(
    logoPath: 'assets/images/logo.png',
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    splashDuration: 3.seconds,
    routeAfterSplash: Routes.dashboard,
)
```
Now use it to pass `splashConfig` parameter inside the `DevEssentialMaterialApp` widget:

```dart
DevEssentialMaterialApp(
    title: 'DevEssential Example',
    splashConfig: splashConfig,
)
```

if you want to perform some operation on the splash load just pass the `onSplashInitCallback` parameter inside the splash configuration and once your operation is completed make sure to call the `loadSplash()` callback from `onSplashInitCallback` to start loading the splash and navigate after the splash completed.


```dart 
final SplashConfig splashConfig = SplashConfig(
    logoPath: 'assets/images/logo.png',
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    splashDuration: 3.seconds,
    routeAfterSplash: Routes.dashboard,
    onSplashInitCallback: (VoidCallback loadSplash) {
        loadSplash();
    },
)
```

`DevEssentialMaterialApp` also provides a toast messages. To enable toast messages set the `useToastNotification` parameter to true.

```dart
DevEssentialMaterialApp(
    title: 'DevEssential Example',
    useToastNotification: true,
)
```

Now to show a text toast message use 


```dart 
"My Toast message".showToast()
```

`DevEssentialMaterialApp` uses `bot_toast: ^4.0.4` so check all the supported bot toast features provided by `bot_toast` package. To use `bot_toast`'s API just use `DevEssentialToast` insted of `BotToast`

```dart

DevEssentialToast.showCustomNotification(...)
DevEssentialToast.showCustomText(...)
DevEssentialToast.showCustomLoading(...)
DevEssentialToast.showAnimationWidget(...)

```

# Available Common Widgets

- SubmitButton
- ScrollableScaffoldWrapper
- LoadingIndictor
- TimelineListView


# TimelineListView example
 For using TimelineListView inside a CustomScrollView please use `TimelineListView.sliver()`

```dart 
TimelineListView.builder(
  padding: const EdgeInsets.only(bottom: 20),
  itemCount: 3,
  lineColor: AppColors.lightGreyTwo,
  labelStyle: Dev.textTheme.labelMedium?.copyWith(
    fontWeight: FontWeight.w500,
    color: AppColors.mediumGrey,
  ),
  lineWidth: 1.0,
  legendText: DateTime.now().add(1.days).custom('dd MMM, yyyy'),
  legendTextStyle: Dev.textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.w500,
  ),
  legendColor: AppColors.duskyBlue10,
  itemBuilder: (BuildContext context, int index) => TimelineListItem(
    height: 75,
    width: double.infinity,
    label: DateTime.now().time12HourFormat().toLowerCase(),
    child: (context, isFirst, isLast) => Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(
          width: 1,
          color: AppColors.lightGrey,
        ),
      ),
      margin: EdgeInsets.only(
        top: isFirst ? 0.0 : 4.0,
        bottom: isLast ? 0.0 : 4.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'User Name: ',
                  ),
                  TextSpan(
                    text: 'Din Djarin ',
                    style: Dev.theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              textScaleFactor: Dev.textScaleFactor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Dev.theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Role: ',
                  ),
                  TextSpan(
                    text: 'User',
                    style: Dev.theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: Dev.textScaleFactor,
              style: Dev.theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Activity Type: ',
                  ),
                  TextSpan(
                    text: 'File access(xyz.file)',
                    style: Dev.theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaleFactor: Dev.textScaleFactor,
              style: Dev.theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mediumGrey,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)
```

# Available Modules

- Splash

# Available Extensions

- DateTimeExtension for formatting date or time [DateTime.now().tod()] [Check all the available methods](./lib/src/extensions/src/datetime_extension.dart)
- TimeOfDayExtension [Check all the available methods](./lib/src/extensions/src/time_of_day_extension.dart)
- DeviceAndPackageInfoExtension [Check all the available methods](./lib/src/extensions/src/device_and_package_info_extension.dart)
- DurationExtension [Check all the available methods](./lib/src/extensions/src/duration_extension.dart)
- FutureExtension [Check all the available methods](./lib/src/extensions/src/future_extension.dart)
- MediaQueryExtension for getting media queries [Dev.height, Dev.width] [Check all the available methods](./lib/src/extensions/src/media_query_extension.dart)
- NumberExtension [Check all the available methods](./lib/src/extensions/src/number_extension.dart)
- PathHelpersExtension [Check all the available methods](./lib/src/extensions/src/path_helpers_extension.dart)
- StringExtension [Check all the available methods](./lib/src/extensions/src/string_extension.dart)
- DevEssentialExtension [Check all the available methods](./lib/src/extensions/src/dev_essential_extension.dart)
- NavigationExtension [Check all the available methods](./lib/src/extensions/src/navigation_extension.dart)