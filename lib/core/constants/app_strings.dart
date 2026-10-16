class AppStrings {
  AppStrings._();

  // App General
  static const String appName = 'HKI Mobile';
  static const String retry = 'Coba Lagi';
  static const String cancel = 'Batal';
  static const String ok = 'OK';
  static const String success = 'Berhasil';
  static const String error = 'Terjadi Kesalahan';

  // Offline / Network
  static const String offlineMessage =
      'Tidak ada koneksi internet. Periksa jaringan Anda.';
  static const String onlineRestoredMessage =
      'Koneksi internet terhubung kembali.';
  static const String timeoutMessage =
      'Koneksi lambat atau server tidak merespons. Coba lagi.';
  static const String serverErrorMessage =
      'Terjadi kesalahan pada server. Coba lagi nanti.';
  static const String unauthorizedMessage =
      'Sesi Anda telah berakhir. Silakan masuk kembali.';
  static const String forbiddenMessage =
      'Anda tidak memiliki hak akses untuk tindakan ini.';
  static const String notFoundMessage = 'Data tidak ditemukan.';
  static const String parsingErrorMessage = 'Gagal memproses data dari server.';
  static const String unknownErrorMessage =
      'Terjadi kesalahan tidak terduga. Coba lagi.';

  // Welcome Screen
  static const String welcomeHeadline = 'Membangun Indonesia dengan Semangat';
  static const String welcomeTagline = '#BreakTheImpossible';
  static const String welcomeLoginBtn = 'Masuk';
  static const String welcomeRegisterBtn = 'Daftar';

  // Login Screen
  static const String loginTitle = 'Masuk ke akun Anda';
  static const String loginSubtitle = 'Masukkan email dan kata sandi Anda.';
  static const String emailOrNikLabel =
      'Email'; // TODO(confirm): Figma says Email, SoW says NIK or email
  static const String emailOrNikHint = 'Masukkan email Anda';
  static const String passwordLabel = 'Kata Sandi';
  static const String passwordHint = 'Masukkan kata sandi Anda';
  static const String rememberMe = 'Ingat saya';
  static const String forgotPasswordLink = 'Lupa Password';
  static const String loginButton = 'Masuk';
  static const String noAccountPrompt = 'Belum punya akun?';
  static const String registerLink = 'Daftar';
  static const String failedLoginGeneric =
      'Periksa kembali email dan kata sandimu, lalu coba lagi.';

  // Register Screen
  static const String registerTitle = 'Buat akun baru';
  static const String registerSubtitle =
      'Lengkapi informasi Anda untuk membuat akun.';
  static const String fullNameLabel = 'Nama Lengkap';
  static const String fullNameHint = 'Masukkan nama lengkap Anda';
  static const String emailLabel = 'Email';
  static const String emailHint = 'Masukkan email Anda';
  static const String nikLabel = 'NIK';
  static const String nikHint = 'Masukkan 16 digit NIK Anda';
  static const String confirmPasswordLabel = 'Konfirmasi Kata Sandi';
  static const String confirmPasswordHint = 'Masukkan kembali kata sandi Anda';
  static const String registerButton = 'Daftar';
  static const String haveAccountPrompt = 'Sudah punya akun?';
  static const String loginLink = 'Masuk';
  static const String registerSuccessMessage =
      'Pendaftaran berhasil! Silakan masuk ke akun Anda.';

  // Register Inline / Server Errors
  static const String nameAlreadyTaken = 'Nama sudah dipakai';
  static const String emailAlreadyTaken = 'Email sudah dipakai';
  static const String nikAlreadyTaken = 'NIK sudah dipakai';

  // Forgot Password Screen
  static const String forgotPasswordTitle = 'Lupa kata sandi?';
  static const String forgotPasswordSubtitle =
      'Masukkan email untuk menerima kode reset.';
  static const String continueButton = 'Lanjutkan';
  static const String orHaveAccountPrompt = 'Atau sudah punya akun?';
  static const String forgotPasswordSuccessMessage =
      'Petunjuk reset kata sandi telah dikirim ke email Anda.';

  // Reset Password Screen
  static const String resetPasswordTitle = 'Buat kata sandi baru';
  // TODO(confirm): Figma says "Maksimal dengan 8 karakter", defaulted to minimum 8 rule
  static const String resetPasswordSubtitle = 'Maksimal dengan 8 karakter';
  static const String newPasswordLabel = 'Password Baru';
  static const String newPasswordHint = 'Masukkan kata sandi baru';
  static const String confirmNewPasswordLabel = 'Konfirmasi Password Baru';
  static const String confirmNewPasswordHint =
      'Masukkan kembali kata sandi baru';
  static const String resetPasswordSuccessMessage =
      'Kata sandi berhasil diatur ulang. Silakan masuk kembali.';

  // Field Validation Messages
  static const String fieldRequired = 'Field ini wajib diisi';
  static const String nameRequired = 'Nama lengkap wajib diisi';
  static const String emailRequired = 'Email wajib diisi';
  static const String emailInvalid = 'Format email tidak valid';
  static const String identifierRequired = 'Email atau NIK wajib diisi';
  static const String identifierInvalid = 'Format email atau NIK tidak valid';
  static const String nikRequired = 'NIK wajib diisi';
  static const String nikDigitsOnly = 'NIK hanya boleh berisi angka';
  static const String nikLengthInvalid = 'NIK harus 16 digit';
  static const String passwordRequired = 'Kata sandi wajib diisi';
  // TODO(confirm): Figma copy says "Kata sandi harus maksimal 8 karakter" vs minimum 8
  static const String passwordMinLength = 'Kata sandi minimal 8 karakter';
  static const String confirmPasswordRequired =
      'Konfirmasi kata sandi wajib diisi';
  static const String passwordMismatch = 'Kata sandi harus sama';

  // Home Screen (Placeholder)
  static const String homeTitle = 'Beranda';
  static const String welcomeUser = 'Selamat Datang,';
  static const String userRoleLabel = 'Peran Anda:';
  static const String userNikLabel = 'NIK:';
  static const String userEmailLabel = 'Email:';
  static const String logoutButton = 'Keluar dari Akun';
  static const String logoutConfirmTitle = 'Konfirmasi Keluar';
  static const String logoutConfirmMessage =
      'Apakah Anda yakin ingin keluar dari aplikasi HKI Mobile?';
}
