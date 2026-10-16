enum UserRole {
  admin,
  pengawas,
  petugasLapangan;

  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.pengawas:
        return 'Pengawas';
      case UserRole.petugasLapangan:
        return 'Petugas Lapangan';
    }
  }

  static UserRole fromString(String? roleStr) {
    if (roleStr == null) return UserRole.petugasLapangan;
    final normalized = roleStr.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');
    switch (normalized) {
      case 'admin':
        return UserRole.admin;
      case 'pengawas':
      case 'supervisor':
        return UserRole.pengawas;
      case 'petugas_lapangan':
      case 'petugaslapangan':
      case 'field_officer':
      case 'officer':
        return UserRole.petugasLapangan;
      default:
        // Safe fallback without crashing
        return UserRole.petugasLapangan;
    }
  }
}
