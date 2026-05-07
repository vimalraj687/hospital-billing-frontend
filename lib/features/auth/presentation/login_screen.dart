import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  ConsumerState<LoginScreen>
      createState() =>
          _LoginScreenState();
}

class _LoginScreenState
    extends ConsumerState<LoginScreen> {
  final _emailController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState =
        ref.watch(authProvider);

    final size =
        MediaQuery.of(context).size;

    final isDesktop =
        size.width > 800;

    final primaryColor =
        Theme.of(context)
            .colorScheme
            .primary;

    Widget formContent = Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 48,
        vertical: 32,
      ),

      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
              maxWidth: 400,
            ),

            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment
                      .center,

              crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch,

              children: [
                // LOGO
                Icon(
                  Icons
                      .local_hospital_rounded,

                  size: 64,

                  color: primaryColor,
                ),

                const SizedBox(
                  height: 24,
                ),

                // TITLE
                Text(
                  'Welcome Back',

                  style: Theme.of(
                          context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                        fontWeight:
                            FontWeight
                                .bold,

                        color: Colors
                            .black87,
                      ),

                  textAlign:
                      TextAlign.center,
                ),

                const SizedBox(
                  height: 8,
                ),

                // SUBTITLE
                Text(
                  'Sign in to access your billing dashboard',

                  style: Theme.of(
                          context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        color:
                            Colors.grey[
                                600],
                      ),

                  textAlign:
                      TextAlign.center,
                ),

                const SizedBox(
                  height: 48,
                ),

                // ERROR
                if (authState.error !=
                    null)
                  Container(
                    padding:
                        const EdgeInsets
                            .all(12),

                    margin:
                        const EdgeInsets.only(
                      bottom: 24,
                    ),

                    decoration:
                        BoxDecoration(
                      color: Colors
                          .red
                          .shade50,

                      borderRadius:
                          BorderRadius.circular(
                        8,
                      ),

                      border:
                          Border.all(
                        color: Colors
                            .red
                            .shade200,
                      ),
                    ),

                    child: Row(
                      children: [
                        Icon(
                          Icons
                              .error_outline,

                          color: Colors
                              .red
                              .shade700,

                          size: 20,
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child: Text(
                            authState
                                .error!,

                            style:
                                TextStyle(
                              color: Colors
                                  .red
                                  .shade700,

                              fontSize:
                                  14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // EMAIL LABEL
                Text(
                  'Email Address',

                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,

                    color:
                        Colors.grey[800],

                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                // EMAIL FIELD
                TextField(
                  controller:
                      _emailController,

                  decoration:
                      InputDecoration(
                    hintText:
                        'Enter your email',

                    prefixIcon:
                        const Icon(
                      Icons
                          .email_outlined,
                    ),

                    filled: true,

                    fillColor:
                        Colors.grey[50],

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),

                      borderSide:
                          BorderSide(
                        color: Colors
                            .grey
                            .shade300,
                      ),
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),

                      borderSide:
                          BorderSide(
                        color: Colors
                            .grey
                            .shade300,
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),

                      borderSide:
                          BorderSide(
                        color:
                            primaryColor,

                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                // PASSWORD LABEL
                Text(
                  'Password',

                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,

                    color:
                        Colors.grey[800],

                    fontSize: 14,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                // PASSWORD FIELD
                TextField(
                  controller:
                      _passwordController,

                  obscureText: true,

                  decoration:
                      InputDecoration(
                    hintText:
                        'Enter your password',

                    prefixIcon:
                        const Icon(
                      Icons
                          .lock_outline,
                    ),

                    filled: true,

                    fillColor:
                        Colors.grey[50],

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),

                      borderSide:
                          BorderSide(
                        color: Colors
                            .grey
                            .shade300,
                      ),
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),

                      borderSide:
                          BorderSide(
                        color: Colors
                            .grey
                            .shade300,
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),

                      borderSide:
                          BorderSide(
                        color:
                            primaryColor,

                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 32,
                ),

                // LOGIN BUTTON
                SizedBox(
                  height: 52,

                  child: ElevatedButton(
                    onPressed:
                        authState.isLoading
                            ? null
                            : () {
                                ref
                                    .read(
                                      authProvider
                                          .notifier,
                                    )
                                    .login(
                                      _emailController
                                          .text,

                                      _passwordController
                                          .text,
                                    );
                              },

                    style:
                        ElevatedButton.styleFrom(
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),

                      backgroundColor:
                          primaryColor,

                      foregroundColor:
                          Colors.white,

                      elevation: 2,
                    ),

                    child:
                        authState.isLoading
                            ? const SizedBox(
                                height:
                                    24,

                                width:
                                    24,

                                child:
                                    CircularProgressIndicator(
                                  color:
                                      Colors.white,

                                  strokeWidth:
                                      2,
                                ),
                              )
                            : const Text(
                                'Sign In',

                                style:
                                    TextStyle(
                                  fontSize:
                                      16,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor:
          Colors.grey[50],

      body: isDesktop
          ? Row(
              children: [
                // LEFT SIDE
                Expanded(
                  flex: 5,

                  child: Container(
                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        begin:
                            Alignment
                                .topLeft,

                        end: Alignment
                            .bottomRight,

                        colors: [
                          Colors.blue
                              .shade800,

                          Colors
                              .indigo
                              .shade900,
                        ],
                      ),
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets
                              .all(
                        48.0,
                      ),

                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          Container(
                            padding:
                                const EdgeInsets
                                    .all(
                              16,
                            ),

                            decoration:
                                BoxDecoration(
                              color: Colors
                                  .white
                                  .withOpacity(
                                0.1,
                              ),

                              borderRadius:
                                  BorderRadius.circular(
                                16,
                              ),
                            ),

                            child:
                                const Icon(
                              Icons
                                  .medical_services_rounded,

                              color:
                                  Colors.white,

                              size: 48,
                            ),
                          ),

                          const SizedBox(
                            height: 32,
                          ),

                          const Text(
                            'Healthcare\nBilling System',

                            style:
                                TextStyle(
                              color:
                                  Colors.white,

                              fontSize:
                                  48,

                              fontWeight:
                                  FontWeight.bold,

                              height:
                                  1.2,
                            ),
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          Text(
                            'Manage patient invoices, track payments,\nand generate reports seamlessly.',

                            style:
                                TextStyle(
                              color: Colors
                                  .white
                                  .withOpacity(
                                0.8,
                              ),

                              fontSize:
                                  18,

                              height:
                                  1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // RIGHT SIDE
                Expanded(
                  flex: 4,

                  child: Container(
                    color:
                        Colors.white,

                    child:
                        formContent,
                  ),
                ),
              ],
            )

          // MOBILE VIEW
          : Center(
              child:
                  SingleChildScrollView(
                child: Container(
                  margin:
                      const EdgeInsets
                          .all(
                    24,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,

                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors
                            .black
                            .withOpacity(
                          0.05,
                        ),

                        blurRadius:
                            24,

                        offset:
                            const Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      24,
                    ),

                    child:
                        formContent,
                  ),
                ),
              ),
            ),
    );
  }
}