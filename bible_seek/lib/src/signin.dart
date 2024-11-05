import 'package:bible_seek/src/colors.dart';
import 'package:bible_seek/src/controllers/user_controller.dart';
import 'package:bible_seek/src/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagesPath {
  static String kGoogleIcon = 'assets/images/googleSymbol.png';
  static String kFacebookIcon = 'assets/images/facebookSymbol.png';
}

class SigninPage extends StatefulWidget {
  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kTan,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("BibleSeek",
                style: GoogleFonts.kameron(
                    fontSize: 32, height: 1.25, color: AppColor.kWhite)),
            const SizedBox(height: 48),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45),
                child: Column(children: [
                  const DividerRow(title: 'Create an Account'),
                  const SizedBox(height: 18),
                ])),
            PrimaryButton(
              elevation: 0,
              onTap: () async {
                try {
                  final user = await UserController().loginWithGoogle();
                  if (user != null && mounted) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  }
                } on FirebaseAuthException catch (error) {
                  print(error.message);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(error.message ?? "Something went wrong")));
                } catch (error) {
                  print(error);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(error.toString())));
                }
              },
              text: 'Continue with Google',
              bgColor: AppColor.kWhite,
              borderRadius: 50,
              // borderColor: AppColor.kDark,
              height: 56,
              width: 250,
              textColor: AppColor.kDark,
              fontSize: 14,
              icons: ImagesPath.kGoogleIcon,
            ),
            PrimaryButton(
              elevation: 0,
              onTap: () {},
              text: 'Continue with Facebook',
              bgColor: AppColor.kWhite,
              borderRadius: 50,
              // borderColor: AppColor.kDark,
              height: 56,
              width: 250,
              textColor: AppColor.kDark,
              fontSize: 14,
              icons: ImagesPath.kFacebookIcon,
            ),
            PrimaryButton(
              elevation: 0,
              onTap: () {},
              text: 'Continue with Email',
              bgColor: AppColor.kWhite,
              borderRadius: 50,
              // borderColor: AppColor.kDark,
              height: 56,
              width: 250,
              textColor: AppColor.kDark,
              fontSize: 14,
            ),
            const SizedBox(height: 48),
            const DividerRow(title: 'Have an Account?'),
            const SizedBox(height: 18),
            PrimaryButton(
              elevation: 0,
              onTap: () {},
              text: 'Sign In',
              bgColor: AppColor.kTan,
              borderRadius: 50,
              borderColor: AppColor.kWhite,
              height: 56,
              width: 250,
              textColor: AppColor.kWhite,
              fontSize: 14,
            ),
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TermsAndPrivacyText(
                title1: '  By signing up, you agree to our ',
                title2: 'Terms',
                title3: '   and ',
                title4: 'Conditions of Use',
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class PrimaryTextButton extends StatelessWidget {
  const PrimaryTextButton(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.textStyle});
  final Function() onPressed;
  final String title;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text, icons;
  final double? width;
  final double? height;
  final double? borderRadius, elevation;
  final double? fontSize;
  final IconData? iconData;
  final Color? textColor, bgColor, borderColor;
  const PrimaryButton(
      {Key? key,
      required this.onTap,
      required this.text,
      this.icons = "",
      this.width,
      this.height,
      this.elevation = 5,
      this.borderRadius,
      this.borderColor,
      this.fontSize,
      required this.textColor,
      required this.bgColor,
      this.iconData})
      : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Card(
          elevation: widget.elevation ?? 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
          ),
          child: Container(
            height: widget.height ?? 55,
            alignment: Alignment.center,
            width: widget.width ?? double.maxFinite,
            decoration: BoxDecoration(
              color: widget.bgColor,
              border:
                  Border.all(color: widget.borderColor ?? Colors.transparent),
              borderRadius: BorderRadius.circular(widget.borderRadius!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(builder: (builder) {
                  if (widget.icons != "") {
                    return Row(
                      children: [
                        Image.asset(widget.icons, width: 23.85, height: 23.04),
                        const SizedBox(width: 12),
                      ],
                    );
                  } else {
                    return Text("");
                  }
                }),
                Text(
                  widget.text,
                  style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.kWhite)
                      .copyWith(
                          color: widget.textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: widget.fontSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text, icons;
  final double width;
  final double height;
  final double borderRadius;
  final double? fontSize;
  final Color textColor, bgColor;
  const SecondaryButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.width,
      required this.height,
      required this.icons,
      required this.borderRadius,
      this.fontSize,
      required this.textColor,
      required this.bgColor});

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          height: widget.height,
          alignment: Alignment.center,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.bgColor,
            border: Border.all(color: AppColor.kLine),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Row(
            children: [
              Image.asset(widget.icons, width: 23.85, height: 23.04),
              const SizedBox(width: 12),
              Text(widget.text,
                  style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.kWhite)
                      .copyWith(
                    color: widget.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class DividerRow extends StatelessWidget {
  final String title;
  const DividerRow({
    required this.title,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Expanded(
        //     flex: 2,
        //     child: Divider(
        //       color: AppColor.kLine,
        //     )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.kWhite)
                .copyWith(
                    color: AppColor.kWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
          ),
        ),
        // Expanded(
        //     flex: 2,
        //     child: Divider(
        //       color: AppColor.kLine,
        //     ))
      ],
    );
  }
}

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText(
      {super.key,
      required this.title1,
      required this.title2,
      required this.title3,
      this.color2,
      required this.title4});
  final Color? color2;
  final String title1, title2, title3, title4;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.kWhite)
            .copyWith(
                color: AppColor.kWhite,
                fontWeight: FontWeight.w500,
                fontSize: 14),
        children: [
          TextSpan(
            text: title1,
          ),
          TextSpan(
            text: title2,
            style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    color: AppColor.kWhite)
                .copyWith(
                    color: color2 ?? AppColor.kGrayscaleDark100,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
          ),
          TextSpan(
            text: title3,
            style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.kWhite)
                .copyWith(
                    color: AppColor.kWhite,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
          ),
          TextSpan(
            text: title4,
            style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    color: AppColor.kWhite)
                .copyWith(
                    color: AppColor.kGrayscaleDark100,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
          ),
        ],
      ),
    );
  }
}
