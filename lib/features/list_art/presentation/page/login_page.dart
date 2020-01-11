import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_art_collection/core/presentation/widget/custom_checkbox.dart';
import 'package:student_art_collection/core/presentation/widget/empty_container.dart';
import 'package:student_art_collection/core/util/text_constants.dart';
import 'package:student_art_collection/core/util/theme_constants.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_bloc.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_event.dart';
import 'package:student_art_collection/features/list_art/presentation/bloc/auth/school_auth_state.dart';
import 'package:student_art_collection/features/list_art/presentation/page/registration_page.dart';
import 'package:student_art_collection/features/list_art/presentation/page/school_gallery_page.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/auth_input_decoration.dart';
import 'package:student_art_collection/features/list_art/presentation/widget/horizontal_progress_bar.dart';

import '../../../../app_localization.dart';
import '../../../../service_locator.dart';

class SchoolLoginPage extends StatelessWidget {
  static const String ID = "login";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolAuthBloc>(
      create: (context) => sl<SchoolAuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
    AppLocalizations.of(context).translate(TEXT_LOGIN_APP_BAR_TITLE),
          ),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: BlocBuilder<SchoolAuthBloc, SchoolAuthState>(
              builder: (context, state) {
                if (state is SchoolAuthLoading) {
                  return AppBarLoading();
                }
                return EmptyContainer();
              },
            ),
          ),
        ),
        body: BlocListener<SchoolAuthBloc, SchoolAuthState>(
          listener: (context, state) {
            if (state is Authorized) {
              Navigator.pushReplacementNamed(context, SchoolGalleryPage.ID);
            } else if (state is SchoolAuthError) {
              final snackBar = SnackBar(content: Text(state.message));
              Scaffold.of(context).showSnackBar(snackBar);
            }
          },
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email, password;
  bool shouldRemember = false;

  void _onCheckboxChange() {
    setState(() {
      shouldRemember = !shouldRemember;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Center(
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    getAuthInputDecoration(AppLocalizations.of(context).translate(TEXT_LOGIN_EMAIL_ADDRESS_LABEL)),
              ),
            ),
            Center(child: SizedBox(height: 10)),
            Center(
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                onChanged: (value) {
                  password = value;
                },
                decoration: getAuthInputDecoration(AppLocalizations.of(context).translate(TEXT_LOGIN_PASSWORD_LABEL)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      child: CustomCheckbox(
                        value: shouldRemember,
                        activeColor: accentColor,
                        materialTapTargetSize: null,
                        onChanged: (value) {
                          _onCheckboxChange();
                        },
                        useTapTarget: false,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).translate(TEXT_LOGIN_REMEMBER_ME_BOX),
                    )
                  ],
                ),
                RaisedButton(
                    color: accentColor,
                    child: Text(
                        AppLocalizations.of(context).translate(TEXT_LOGIN_LOGIN_BUTTON),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      dispatchLogin();
                    }),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[
                InkWell(
                  child: Text(
                    AppLocalizations.of(context).translate(TEXT_LOGIN_REGISTER_HERE_LABEL),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, SchoolRegistrationPage.ID);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void dispatchLogin() {
    BlocProvider.of<SchoolAuthBloc>(context).add(LoginSchoolEvent(
      email: email,
      password: password,
    ));
  }
}
