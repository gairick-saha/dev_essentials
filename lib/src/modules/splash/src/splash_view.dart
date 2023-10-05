part of '../splash.dart';

class SplashView extends StatelessWidget {
  const SplashView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (BuildContext context, SplashState state) {
        SplashConfig splashConfig = state.splashConfig;
        String logoType = '';
        Widget? logo;
        if (splashConfig.logoPath != null) {
          logoType = lookupMimeType(splashConfig.logoPath!) ?? '';
          logoType = logoType.split('/').last;
          if (logoType.startsWith('svg')) {
            logo = DevEssentialSvgPicture.asset(splashConfig.logoPath!);
          } else {
            logo = Image.asset(splashConfig.logoPath!);
          }
        }
        return Scaffold(
          backgroundColor: Dev.isDarkMode
              ? splashConfig.darkBackgroundColor ?? splashConfig.backgroundColor
              : splashConfig.backgroundColor ??
                  splashConfig.darkBackgroundColor,
          body: SafeArea(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: Dev.isDarkMode
                    ? splashConfig.darkBackgroundGradient ??
                        splashConfig.backgroundGradient
                    : splashConfig.backgroundGradient ??
                        splashConfig.darkBackgroundGradient,
              ),
              child: splashConfig.customUiBuilder != null
                  ? splashConfig.customUiBuilder!(
                      logo,
                      Dev.isDarkMode
                          ? splashConfig.darkBackgroundColor ??
                              splashConfig.backgroundColor
                          : splashConfig.backgroundColor ??
                              splashConfig.darkBackgroundColor,
                    )
                  : Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.percentageWidth,
                            ),
                            child: SizedBox.fromSize(
                              size: splashConfig.logoSize ??
                                  Size.fromWidth(130.percentage),
                              child: logo ??
                                  FlutterLogo(
                                    size: 130.percentage,
                                  ),
                            ),
                          ),
                        ),
                        if (splashConfig.showVersionNumber)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text.rich(
                                TextSpan(
                                  text: 'Version: ',
                                  children: [
                                    TextSpan(
                                      text: state.appVersion,
                                    )
                                  ],
                                ),
                                style: Dev.theme.textTheme.bodySmall?.copyWith(
                                  color: Dev.isDarkMode
                                      ? splashConfig.darkForegroundColor ??
                                          splashConfig.foregroundColor
                                      : splashConfig.foregroundColor ??
                                          splashConfig.darkForegroundColor,
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
