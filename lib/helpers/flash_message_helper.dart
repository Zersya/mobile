import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:location_tracker/gen/colors.gen.dart';
import 'package:location_tracker/helpers/navigation_helper.dart';

class FlashMessageHelper {
  /// [message] nullable because we need to create stub in the tests
  /// to fit with the argMatcher
  /// https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md
  void showError(
    String? message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    showTopFlash(message ?? ' - ', isError: true);
  }

  void showTopFlash(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 5),
  }) {
    final context = GetIt.I<NavigationHelper>()
        .goRouter
        .routerDelegate
        .navigatorKey
        .currentContext!;

    showFlash<void>(
      context: context,
      duration: duration,
      builder: (_, controller) {
        return Flash<void>(
          controller: controller,
          position: FlashPosition.top,
          child: FlashBar(
            controller: controller,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            behavior: FlashBehavior.floating,
            backgroundColor:
                isError ? ColorName.errorContainer : ColorName.successContainer,
            icon: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: isError
                  ? const Icon(
                      Icons.error,
                      color: ColorName.error,
                      size: 35,
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: ColorName.success,
                      size: 35,
                    ),
            ),
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: isError ? ColorName.error : ColorName.success,
              ),
            ),
          ),
        );
      },
    );
  }
}
