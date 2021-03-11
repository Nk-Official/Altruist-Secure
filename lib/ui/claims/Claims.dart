import 'package:altruist_secure_flutter/apis/apis.dart';
import 'package:altruist_secure_flutter/blocs/claims/raise_claims_bloc.dart';
import 'package:altruist_secure_flutter/blocs/claims/raise_claims_event.dart';
import 'package:altruist_secure_flutter/blocs/claims/raise_claims_state.dart';
import 'package:altruist_secure_flutter/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
class Claims extends StatefulWidget {
  @override
  _ClaimsState createState() => _ClaimsState();
}

class _ClaimsState extends State<Claims> {
  RaiseClaimsBloc _bloc;
  bool isLoadingProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = RaiseClaimsBloc(apisRepository: ApisRepository());
    _bloc.add(FetchClaimsListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, RaiseClaimsState state) {
          if (state is InitialRaiseClaimsState) {
            if (state.isLoading == false && !state.isSuccess) {
              AppUtils.showSnackBar(context, state.message);
            } else if (state.isLoading == false && state.isSuccess) {
              AppUtils.showSnackBar(context, state.message);
            }
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, RaiseClaimsState state) {
            if (state is InitialRaiseClaimsState) {
              if (state.isLoading) {
                isLoadingProgress = state.isLoading;
              } else {
                isLoadingProgress = false;
              }
            }
            return ModalProgressHUD(
              color: Colors.black,
              inAsyncCall: isLoadingProgress,
              child: Container(),
            );
          },
        ),
    ));
  }
}
