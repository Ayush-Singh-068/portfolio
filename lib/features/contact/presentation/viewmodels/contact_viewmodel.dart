import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContactState {
  final String name;
  final String email;
  final String message;
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const ContactState({
    this.name = '',
    this.email = '',
    this.message = '',
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  ContactState copyWith({
    String? name,
    String? email,
    String? message,
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return ContactState(
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}

class ContactViewModel extends StateNotifier<ContactState> {
  ContactViewModel() : super(const ContactState());

  void updateName(String value) {
    state = state.copyWith(name: value, error: null);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value, error: null);
  }

  void updateMessage(String value) {
    state = state.copyWith(message: value, error: null);
  }

  bool _validateEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> submitForm() async {
    if (state.name.isEmpty || state.email.isEmpty || state.message.isEmpty) {
      state = state.copyWith(error: 'Please fill in all fields');
      return;
    }

    if (!_validateEmail(state.email)) {
      state = state.copyWith(error: 'Please enter a valid email address');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(
      isLoading: false,
      isSuccess: true,
      name: '',
      email: '',
      message: '',
    );

    await Future.delayed(const Duration(seconds: 3));
    state = state.copyWith(isSuccess: false);
  }
}

final contactViewModelProvider =
    StateNotifierProvider<ContactViewModel, ContactState>((ref) {
  return ContactViewModel();
});

