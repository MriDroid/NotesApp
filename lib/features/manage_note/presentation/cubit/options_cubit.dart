import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/core/widgets/app_toast.dart';
part 'options_state.dart';

class OptionsCubit extends Cubit<OptionsState> {
  OptionsCubit() : super(OptionsInitial());
  bool isLocalEnabled = false;
  void changeLocalEnabled(bool value) {
    emit(OptionsInitial());
    isLocalEnabled = value;
    if(value){
      AppToast.build('Local Data is Enabled.');
    }else{
      AppToast.build('Local Data is Disabled.');
    }
    emit(OptionsLocalChanged());
  }
}

// String _mapFailureToMsg(Failure failure) {
//   switch (failure.runtimeType) {
//     case ServerFailure:
//       return AppStrings.serverFailure;
//     case CashFailure:
//       return AppStrings.cashFailure;
//     default:
//       return AppStrings.unexpectedFailure;
//   }
// }
