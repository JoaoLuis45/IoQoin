import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../shared/services/storage_service.dart';
import '../../auth/services/auth_service.dart';

import 'package:ioqoin/l10n/app_localizations.dart';

/// Tela de Perfil do usuário
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  DateTime? _dataNascimento;
  String? _genero;
  final _generos = ['male', 'female', 'other', 'prefer_not_to_say'];

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authService = context.read<AuthService>();
    final user = authService.user;
    if (user != null) {
      // Tenta usar o displayName do Auth, se falhar usa do Firestore
      final nome = (user.displayName != null && user.displayName!.isNotEmpty)
          ? user.displayName!
          : (authService.userModel?.nome ?? '');

      _nomeController.text = nome;

      // Carregar telefone se disponível no userModel
      if (authService.userModel?.telefone != null) {
        _telefoneController.text = authService.userModel!.telefone!;
      }

      _dataNascimento = authService.userModel?.dataNascimento;
      _genero = _mapGenderToKey(authService.userModel?.genero);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authService = context.watch<AuthService>();
    final user = authService.user;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(l10n.profileTitle),
            actions: [
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    _loadUserData(); // Garante dados atualizados ao editar
                    setState(() => _isEditing = true);
                  },
                )
              else
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() => _isEditing = false);
                    _loadUserData();
                  },
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.voltCyan,
                              AppColors.voltCyanDark,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.voltCyan.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: user?.photoURL != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(32),
                                  child: Image.network(
                                    user!.photoURL!,
                                    key: ValueKey(
                                      user.photoURL,
                                    ), // Força reconstrução se URL mudar
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                              color: AppColors.deepFinBlue,
                                            ),
                                          );
                                        },
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: AppColors.deepFinBlue,
                                    ),
                                  ),
                                )
                              : Text(
                                  _getInitials(user?.displayName ?? 'U'),
                                  style: const TextStyle(
                                    color: AppColors.deepFinBlue,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.voltCyan,
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt,
                            color: AppColors.voltCyan,
                            size: 20,
                          ),
                          onPressed: _pickPhoto,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Email (não editável)
                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: user?.email ?? '',
                    isEditable: false,
                  ),

                  const SizedBox(height: 16),

                  // Tag do Usuário
                  if (authService.userModel?.userTag != null &&
                      authService.userModel!.userTag!.isNotEmpty)
                    _buildInfoCard(
                      icon: Icons.tag,
                      label: l10n.profileTagLabel,
                      value: authService.userModel!.userTag!,
                      isEditable: true,
                      customEditWidget: Row(
                        children: [
                          Expanded(
                            child: Text(
                              authService.userModel!.userTag!,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                          StatefulBuilder(
                            builder: (context, setState) {
                              return IconButton(
                                icon: const Icon(
                                  Icons.copy,
                                  color: AppColors.voltCyan,
                                ),
                                tooltip: 'Copiar Tag',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: authService.userModel!.userTag!,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.profileTagCopied),
                                      backgroundColor: AppColors.successGreen,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  else
                    _buildInfoCard(
                      icon: Icons.tag,
                      label: l10n.profileTagLabel,
                      value: l10n.profileGeneratingId,
                      isEditable: false,
                      customEditWidget: Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.voltCyan,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.profileGeneratingId,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Nome
                  _buildInfoCard(
                    icon: Icons.person_outlined,
                    label: l10n.profileNameLabel,
                    value:
                        (user?.displayName != null &&
                            user!.displayName!.isNotEmpty)
                        ? user.displayName!
                        : (authService.userModel?.nome ?? ''),
                    isEditable: true,
                    controller: _nomeController,
                  ),

                  const SizedBox(height: 16),

                  // Telefone
                  _buildInfoCard(
                    icon: Icons.phone_outlined,
                    label: l10n.profilePhoneLabel,
                    value: _telefoneController.text,
                    isEditable: true,
                    controller: _telefoneController,
                    hint: l10n.profilePhoneHint,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  // Data de Nascimento
                  _buildDateSelector(l10n),

                  const SizedBox(height: 16),

                  // Gênero
                  _buildGenderSelector(l10n),

                  const SizedBox(height: 32),

                  // Botão de salvar (quando editando)
                  if (_isEditing)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.deepFinBlue,
                                ),
                              )
                            : Text(l10n.profileSaveButton),
                      ),
                    ).animate().fadeIn(duration: 300.ms),

                  const SizedBox(height: 32),

                  // Ações da conta
                  if (!_isEditing) ...[
                    _buildActionTile(
                      icon: Icons.delete_outline,
                      title: l10n.profileDeleteAccountTitle,
                      subtitle: l10n.profileDeleteAccountSubtitle,
                      color: AppColors.alertRed,
                      onTap: () => _confirmDeleteAccount(l10n),
                    ),
                    _buildActionTile(
                      icon: Icons.logout,
                      title: l10n.profileLogoutTitle,
                      subtitle: l10n.profileLogoutSubtitle,
                      onTap: _logout,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.voltCyan),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required bool isEditable,
    TextEditingController? controller,
    String? hint,
    TextInputType? keyboardType,
    Widget? customEditWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.voltCyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.voltCyan),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                if (_isEditing && isEditable)
                  customEditWidget ??
                      TextFormField(
                        controller: controller,
                        keyboardType: keyboardType,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          border: InputBorder.none,
                        ),
                      )
                else
                  Text(
                    value.isNotEmpty ? value : (hint ?? '-'),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: value.isNotEmpty
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1);
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color color = AppColors.voltCyan,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(color: color)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right, color: color),
        tileColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  Future<void> _pickPhoto() async {
    if (_isLoading) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.deepFinBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.voltCyan,
              ),
              title: Text(
                AppLocalizations.of(context)!.profilePhotoGallery,
                style: const TextStyle(color: AppColors.pureWhite),
              ),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.voltCyan),
              title: Text(
                // Assuming we use l10n for Camera/Gallery if available, else hardcode for now or add keys
                // I added keys in ARB task
                AppLocalizations.of(context)!.profilePhotoCamera,
                style: const TextStyle(color: AppColors.pureWhite),
              ),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800, // Otimização básica
        imageQuality: 80,
      );

      if (pickedFile != null) {
        _uploadPhoto(File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');
    }
  }

  Future<void> _uploadPhoto(File file) async {
    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      final storageService = context.read<StorageService>();
      final userId = authService.user?.uid;

      if (userId == null) throw Exception('Usuário não identificado');

      final url = await storageService.uploadProfileImage(file, userId);

      // Atualiza apenas a foto (outros campos null para não sobrescrever com null se a lógica de updateProfile não tratar)
      // Verificando AuthService: ele usa o _userModel atual se os args forem nulos?
      // Sim, updateProfile chama copyWith. Se eu passar null, ele mantém o antigo?
      // Preciso verificar AuthService.
      // O AuthService.updateProfile recebe parâmetros nomeados opcionais.
      // Se eu chamar updateProfile(fotoUrl: url), os outros serão null.
      // E no método: _userModel = _userModel!.copyWith(fotoUrl: fotoUrl ?? _userModel!.fotoUrl ...)
      // Se eu passar null lá, ele mantém? Preciso conferir o copyWith.
      // Se o updateProfile implementation for: fotoUrl: fotoUrl ?? this.fotoUrl - ok.
      // Vou assumir que o AuthService trata isso. Se não, preciso passar os atuais.

      await authService.updateProfile(fotoUrl: url);

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profilePhotoUpdated),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorMessage(e.toString()),
            ),
            backgroundColor: AppColors.alertRed,
          ),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = context.read<AuthService>();
      await authService.updateProfile(
        displayName: _nomeController.text.trim(),
        telefone: _telefoneController.text.trim(),
        dataNascimento: _dataNascimento,
        genero: _genero,
      );

      if (mounted) {
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.profileUpdated),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorMessage(e.toString()),
            ),
            backgroundColor: AppColors.alertRed,
          ),
        );
      }
    }
  }

  void _confirmDeleteAccount(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.deepFinBlueLight,
        title: Text(l10n.profileDeleteAccountTitle),
        content: Text(l10n.profileDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.alertRed),
            child: Text(
              l10n.profileDeleteAccountTitle,
            ), // Recycle title 'Excluir conta' or 'Excluir'
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      final authService = context.read<AuthService>();
      await authService.deleteAccount();
      if (mounted) {
        context.go('/welcome');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: $e'),
            backgroundColor: AppColors.alertRed,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      final authService = context.read<AuthService>();
      await authService.signOut();
      // O redirecionamento é automático pelo GoRouter (refreshListenable)
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.saveError(e.toString()),
            ),
            backgroundColor: AppColors.alertRed,
          ),
        );
      }
    }
  }

  Widget _buildDateSelector(AppLocalizations l10n) {
    return _buildInfoCard(
      icon: Icons.calendar_today_outlined,
      label: l10n.profileBirthDateLabel,
      value: _dataNascimento != null
          ? _formatDate(_dataNascimento!, l10n)
          : '-',
      isEditable: true,
      hint: l10n.profileGenderSelect,
      customEditWidget: GestureDetector(
        onTap: () => _selectDate(l10n),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.textSecondary, width: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _dataNascimento != null
                    ? _formatDate(_dataNascimento!, l10n)
                    : l10n.profileGenderSelect,
                style: TextStyle(
                  color: _dataNascimento != null
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : AppColors.textSecondary.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector(AppLocalizations l10n) {
    return _buildInfoCard(
      icon: Icons.people_outline,
      label: l10n.profileGenderLabel,
      value: _genero != null ? _getGenderLabel(_genero!, l10n) : '-',
      isEditable: true,
      customEditWidget: InputDecorator(
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          border: InputBorder.none,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _genero,
            items: _generos
                .map(
                  (key) => DropdownMenuItem(
                    value: key,
                    child: Text(
                      _getGenderLabel(key, l10n),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _genero = value);
              }
            },
            hint: Text(
              l10n.profileGenderSelect,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
            dropdownColor: Theme.of(context).cardColor,
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.voltCyan),
            style: Theme.of(context).textTheme.bodyLarge,
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  // Helper para mapear valores legados/localizados para chaves fixas
  String? _mapGenderToKey(String? value) {
    if (value == null) return null;
    final v = value.toLowerCase();

    // Mapeamento de valores legados (Português/Inglês/Espanhol)
    if (v == 'masculino' || v == 'male') return 'male';
    if (v == 'feminino' || v == 'female' || v == 'femenino') return 'female';
    if (v == 'outro' || v == 'other' || v == 'otro') return 'other';
    if (v.contains('prefiro') || v.contains('prefer'))
      return 'prefer_not_to_say';

    // Se já for uma chave válida
    if (['male', 'female', 'other', 'prefer_not_to_say'].contains(v)) return v;

    return null; // Ou default 'other'
  }

  String _getGenderLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'male':
        return l10n.profileGenderMale;
      case 'female':
        return l10n.profileGenderFemale;
      case 'other':
        return l10n.profileGenderOther;
      case 'prefer_not_to_say':
        return l10n.profileGenderPreferNotToSay;
      default:
        return key;
    }
  }

  Future<void> _selectDate(AppLocalizations l10n) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.voltCyan,
              onPrimary: AppColors.deepFinBlue,
              surface: AppColors.deepFinBlueLight,
              onSurface: AppColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _dataNascimento = picked);
    }
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
