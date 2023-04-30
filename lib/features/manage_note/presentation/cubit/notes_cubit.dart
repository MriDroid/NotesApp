import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/core/errors/failures.dart';
import 'package:notes/core/usecases/usecase.dart';
import 'package:notes/core/utils/app_strings.dart';
import 'package:notes/features/manage_note/domain/entities/note.dart';
import 'package:notes/features/manage_note/domain/usecases/add_note.dart';
import 'package:notes/features/manage_note/domain/usecases/get_all_notes.dart';

import '../../domain/usecases/update_notes.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final GetAllNotes getAllNotesUseCase;
  final UpdateNoteData updateNoteUseCase;
  final AddNote addNoteUseCase;
  List<Note> listNotes = [];
  List<Note> listNotesSearched = [];
  NotesCubit({
    required this.getAllNotesUseCase,
    required this.updateNoteUseCase,
    required this.addNoteUseCase,
  }) : super(NotesInitial());

  Future<void> getAllNotes() async {
    emit(AllNotesIsLoading());
    Either<Failure, List<Note>> response =
        await getAllNotesUseCase.call(NoParams());

    emit(
      response.fold(
          (failure) => AllNotesLoadedError(msg: _mapFailureToMsg(failure)),
          (note) {
        listNotes = note;
        return AllNotesLoadedSuccess(note: note);
      }),
    );
  }

  List<Note> searchNoteList(String txt) {
    listNotesSearched = listNotes
        .where(
          (element) => element.text.toLowerCase().contains(txt.toLowerCase()),
        )
        .toList();
    emit(AllNotesLoadedSuccess(note: listNotesSearched));
    return listNotesSearched;
  }

  List<Note> clearSearchNoteList() {
    listNotesSearched = [];
    emit(AllNotesLoadedSuccess(note: listNotesSearched));
    return listNotesSearched;
  }

  List<Note> sortAccordingToUser() {
    List<Note> sortedList = listNotes;
    sortedList.sort(((a, b) {
      //sorting in descending order
      return b.text.compareTo(a.text);
    }));
    emit(AllNotesLoadedSuccess(note: sortedList));
    return sortedList;
  }

  Future<void> updateNote({
    required String id,
    required String text,
    required String userId,
    required String placeDateTime,
  }) async {
    // emit(UpdateNoteIsLoading());
    Either<Failure, bool> response = await updateNoteUseCase.call(NoteParam(
        id: id, text: text, userId: userId, placeDateTime: placeDateTime));

    emit(
      response.fold(
        (failure) => InsertNoteError(msg: _mapFailureToMsg(failure)),
        (isUpdated) => UpdateNoteSuccess(isUpdated: isUpdated),
      ),
    );
  }

  Future<void> insertNote({
    required String id,
    required String text,
    required String userId,
    required String placeDateTime,
  }) async {
    // emit(UpdateNoteIsLoading());
    Either<Failure, bool> response = await addNoteUseCase.call(NoteParam(
        id: id, text: text, userId: userId, placeDateTime: placeDateTime));

    emit(
      response.fold(
        (failure) => InsertNoteError(msg: _mapFailureToMsg(failure)),
        (isInserted) => InsertNoteSuccess(isInserted: isInserted),
      ),
    );
  }

  String _mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailure;
      case CashFailure:
        return AppStrings.cashFailure;
      default:
        return AppStrings.unexpectedFailure;
    }
  }
}
