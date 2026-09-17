import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(),
      super(const AuthInitial()) {
    on<LoginRequested>(_login);
    on<GoogleLoginRequested>(_googleLogin);
  }

  final AuthRepository _authRepository;

  Future<void> _login(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      await _authRepository.login(email: event.email, password: event.password);
      emit(const AuthSuccess());
    } on FirebaseAuthException catch (error) {
      emit(AuthFailure(_messageFor(error)));
    } catch (_) {
      emit(const AuthFailure('Something went wrong'));
    }
  }

  Future<void> _googleLogin(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final credential = await _authRepository.signInWithGoogle();
      if (credential == null) {
        emit(const AuthFailure('Google login failed'));
        return;
      }
      emit(const AuthSuccess());
    } catch (_) {
      emit(const AuthFailure('Google login failed'));
    }
  }

  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'User not found. Please signup';
      case 'wrong-password':
        return 'Password is incorrect';
      case 'invalid-credential':
        return 'Email or password is incorrect';
      case 'invalid-email':
        return 'Please enter a valid email';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Try again later';
      default:
        return error.message ?? 'Login failed';
    }
  }
}
