import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../onboarding/domain/entities/user_profile.dart';
import '../../../onboarding/presentation/controllers/onboarding_providers.dart';
import '../../../quit_plan/presentation/controllers/quit_plan_providers.dart';
import '../../../quit_plan/presentation/pages/quit_plan_editor_page.dart';
import '../../domain/entities/settings_preferences.dart';
import '../controllers/settings_providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(settingsPreferencesProvider);
    final profile = ref.watch(userProfileProvider).valueOrNull;
    final plan = ref.watch(quitPlanProvider).valueOrNull;
    return AppScaffold(
      child: SafeArea(
        child: preferences.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) =>
              const Center(child: Text('Pengaturan belum bisa dimuat.')),
          data: (value) => ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xxl,
              AppSpacing.xl,
              AppSpacing.xxl,
            ),
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Kembali',
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Pengaturan',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              _Section(
                title: 'Preferensi',
                child: _SettingsTile(
                  icon: Icons.brightness_6_outlined,
                  title: 'Tema',
                  subtitle: _themeLabel(value.themePreference),
                  onTap: () => _pickTheme(context, ref, value),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _Section(
                title: 'Notifikasi',
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.notifications_none),
                      title: const Text('Check-in harian'),
                      subtitle: Text(
                        value.dailyCheckInEnabled
                            ? 'Setiap hari pukul ${value.dailyCheckInTime.label}'
                            : 'Mati secara default',
                      ),
                      value: value.dailyCheckInEnabled,
                      onChanged: (enabled) => _setDaily(context, ref, enabled),
                    ),
                    if (value.dailyCheckInEnabled) ...[
                      const Divider(),
                      _SettingsTile(
                        icon: Icons.schedule_outlined,
                        title: 'Waktu check-in',
                        subtitle: value.dailyCheckInTime.label,
                        onTap: () => _pickReminderTime(context, ref, value),
                      ),
                    ],
                    const Divider(),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.flag_outlined),
                      title: const Text('Pengingat hari berhenti'),
                      subtitle: Text(
                        plan == null
                            ? 'Buat rencana berhenti untuk mengaktifkannya'
                            : 'Pukul 08:00 pada tanggal rencanamu',
                      ),
                      value: value.quitDayReminderEnabled,
                      onChanged: plan == null
                          ? null
                          : (enabled) =>
                                _setQuitReminder(context, ref, enabled),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _Section(
                title: 'Profil & rencana',
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.tune_outlined,
                      title: 'Baseline & harga rokok',
                      subtitle: 'Memperbarui hitungan insight ke depan',
                      onTap: profile == null
                          ? null
                          : () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    ProfileSettingsPage(profile: profile),
                              ),
                            ),
                    ),
                    const Divider(),
                    _SettingsTile(
                      icon: Icons.event_outlined,
                      title: 'Rencana berhenti',
                      subtitle: plan == null
                          ? 'Belum dibuat'
                          : 'Lihat atau ubah rencanamu',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const QuitPlanEditorPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _Section(
                title: 'Data & privasi',
                child: Column(
                  children: [
                    _SettingsTile(
                      icon: Icons.ios_share_outlined,
                      title: 'Ekspor data',
                      subtitle: 'Buat file JSON dari data pribadimu',
                      onTap: () => _export(context, ref),
                    ),
                    const Divider(),
                    _SettingsTile(
                      icon: Icons.delete_outline,
                      title: 'Hapus semua data',
                      subtitle: 'Menghapus data Serenity dari perangkat ini',
                      destructive: true,
                      onTap: () => _confirmReset(context, ref),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _Section(title: 'Tentang', child: const _AboutContent()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickTheme(
    BuildContext context,
    WidgetRef ref,
    SettingsPreferences preferences,
  ) async {
    final selected = await showDialog<AppThemePreference>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: const Text('Tema'),
        children: [
          RadioGroup<AppThemePreference>(
            groupValue: preferences.themePreference,
            onChanged: (value) => Navigator.of(dialogContext).pop(value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in AppThemePreference.values)
                  RadioListTile<AppThemePreference>(
                    value: option,
                    title: Text(_themeLabel(option)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    if (selected == null) {
      return;
    }
    await ref
        .read(settingsRepositoryProvider)
        .savePreferences(preferences.copyWith(themePreference: selected));
  }

  Future<void> _setDaily(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    try {
      await ref
          .read(notificationControllerProvider.notifier)
          .setDailyCheckInEnabled(enabled);
    } on NotificationPermissionDeniedException {
      if (context.mounted) {
        _message(
          context,
          'Izin notifikasi belum diberikan. Serenity tetap bisa dipakai seperti biasa.',
        );
      }
    }
  }

  Future<void> _pickReminderTime(
    BuildContext context,
    WidgetRef ref,
    SettingsPreferences preferences,
  ) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: preferences.dailyCheckInTime.asTimeOfDay,
    );
    if (selected == null) {
      return;
    }
    await ref
        .read(notificationControllerProvider.notifier)
        .setDailyCheckInTime(
          ReminderTime(hour: selected.hour, minute: selected.minute),
        );
  }

  Future<void> _setQuitReminder(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    try {
      await ref
          .read(notificationControllerProvider.notifier)
          .setQuitDayReminderEnabled(enabled);
    } on NotificationPermissionDeniedException {
      if (context.mounted) {
        _message(
          context,
          'Izin notifikasi belum diberikan. Serenity tetap bisa dipakai seperti biasa.',
        );
      }
    }
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(deviceExportServiceProvider).exportAndShare();
      if (context.mounted) {
        _message(context, 'File JSON siap dipilih tempat penyimpanannya.');
      }
    } catch (_) {
      if (context.mounted) {
        _message(context, 'Ekspor belum bisa dibuat. Coba lagi sebentar.');
      }
    }
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus semua data Serenity?'),
        content: const Text(
          'Profil, catatan rokok, craving, rencana berhenti, pengaturan, dan pengingat akan dihapus dari perangkat ini. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus semua'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await ref.read(resetServiceProvider).deleteAllPersonalData();
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  static String _themeLabel(AppThemePreference preference) =>
      switch (preference) {
        AppThemePreference.system => 'Ikuti sistem',
        AppThemePreference.light => 'Terang',
        AppThemePreference.dark => 'Gelap',
      };

  static void _message(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class ProfileSettingsPage extends ConsumerStatefulWidget {
  const ProfileSettingsPage({required this.profile, super.key});

  final UserProfile profile;

  @override
  ConsumerState<ProfileSettingsPage> createState() =>
      _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends ConsumerState<ProfileSettingsPage> {
  late final TextEditingController _baseline;
  late final TextEditingController _perPack;
  late final TextEditingController _price;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _baseline = TextEditingController(
      text: '${widget.profile.baselineCigarettesPerDay}',
    );
    _perPack = TextEditingController(
      text: _nullableNumber(widget.profile.cigarettesPerPack),
    );
    _price = TextEditingController(
      text: _nullableNumber(widget.profile.packPrice),
    );
  }

  @override
  void dispose() {
    _baseline.dispose();
    _perPack.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppScaffold(
    child: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Kembali',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Baseline & harga rokok',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Perubahan ini dipakai untuk hitungan insight. Catatan rokok yang sudah ada tidak diubah.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: _baseline,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Baseline batang per hari',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _perPack,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Batang per bungkus (opsional)',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _price,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Harga per bungkus (opsional)',
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Menyimpan…' : 'Simpan perubahan'),
          ),
        ],
      ),
    ),
  );

  Future<void> _save() async {
    final baseline = int.tryParse(_baseline.text.trim());
    final perPack = _optionalInt(_perPack.text);
    final price = _optionalInt(_price.text);
    if (baseline == null ||
        baseline <= 0 ||
        (_perPack.text.trim().isNotEmpty &&
            (perPack == null || perPack <= 0)) ||
        (_price.text.trim().isNotEmpty && (price == null || price < 0))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Periksa kembali angka yang kamu masukkan.'),
        ),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(settingsProfileControllerProvider)
          .updatePattern(
            baselineCigarettesPerDay: baseline,
            cigarettesPerPack: perPack,
            packPrice: price,
          );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  static int? _optionalInt(String value) =>
      value.trim().isEmpty ? null : int.tryParse(value.trim());

  static String _nullableNumber(int? value) => value?.toString() ?? '';
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: AppSpacing.sm),
      AppCard(child: child),
    ],
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? Theme.of(context).colorScheme.error : null;
    return ListTile(
      enabled: onTap != null,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color),
      title: Text(title, style: color == null ? null : TextStyle(color: color)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
    child: Text(
      'Serenity adalah alat bantu kebiasaan dan bukan pengganti saran dokter atau tenaga kesehatan. Semua data tetap di perangkatmu, kecuali saat kamu memilih untuk mengekspornya.',
    ),
  );
}
