import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../history/history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final attendanceProvider = context.read<AttendanceProvider>();
    await attendanceProvider.getTodayAttendance();
    await attendanceProvider.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeView(),
          HistoryPage(),
          _ProfileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, attendanceProvider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await attendanceProvider.getTodayAttendance();
            await attendanceProvider.getCurrentLocation();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildTimeCard(),
                  const SizedBox(height: 24),
                  _buildMenuGrid(context),
                  const SizedBox(height: 24),
                  _buildAttendanceStatus(context, attendanceProvider),
                  const SizedBox(height: 24),
                  _buildActionButton(context, attendanceProvider),
                  const SizedBox(height: 24),
                  _buildLocationInfo(attendanceProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello,', style: AppTextStyles.bodyMedium),
              Text(
                user?.fullName ?? 'User',
                style: AppTextStyles.h4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeCard() {
    final now = DateTime.now();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            DateFormat('EEEE').format(now),
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('HH:mm').format(now),
            style: AppTextStyles.timeText.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd MMMM yyyy').format(now),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Cuti',
        'icon': Icons.event_busy,
        'color': const Color(0xFFE74C3C),
        'bgColor': const Color(0xFFFEEFEE),
        'onTap': () {
          // Navigate to Cuti page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cuti page - Coming soon')),
          );
        },
      },
      {
        'title': 'Izin',
        'icon': Icons.event_available,
        'color': const Color(0xFF4A90E2),
        'bgColor': const Color(0xFFE3F2FD),
        'onTap': () {
          // Navigate to Izin page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin page - Coming soon')),
          );
        },
      },
      {
        'title': 'Lembur',
        'icon': Icons.local_fire_department,
        'color': const Color(0xFFFF9F43),
        'bgColor': const Color(0xFFFFF3E0),
        'onTap': () {
          // Navigate to Lembur page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lembur page - Coming soon')),
          );
        },
      },
      {
        'title': 'Daftar\nPermohonan',
        'icon': Icons.description,
        'color': const Color(0xFF4A90E2),
        'bgColor': const Color(0xFFE3F2FD),
        'onTap': () {
          // Navigate to Daftar Permohonan page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Daftar Permohonan page - Coming soon')),
          );
        },
      },
      {
        'title': 'Daftar\nLembur',
        'icon': Icons.assignment,
        'color': const Color(0xFFFF9F43),
        'bgColor': const Color(0xFFFFF3E0),
        'onTap': () {
          // Navigate to Daftar Lembur page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Daftar Lembur page - Coming soon')),
          );
        },
      },
      {
        'title': 'Task',
        'icon': Icons.check_box,
        'color': const Color(0xFF2ECC71),
        'bgColor': const Color(0xFFE8F5E9),
        'onTap': () {
          // Navigate to Task page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task page - Coming soon')),
          );
        },
      },
      {
        'title': 'Perintah\nLembur',
        'icon': Icons.access_time,
        'color': const Color(0xFF4A90E2),
        'bgColor': const Color(0xFFE3F2FD),
        'onTap': () {
          // Navigate to Perintah Lembur page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perintah Lembur page - Coming soon')),
          );
        },
      },
      {
        'title': 'Lainnya',
        'icon': Icons.grid_view,
        'color': const Color(0xFF4A5C6A),
        'bgColor': const Color(0xFFECEFF1),
        'onTap': () {
          // Navigate to Lainnya page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lainnya page - Coming soon')),
          );
        },
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildMenuItem(
          title: item['title'],
          icon: item['icon'],
          color: item['color'],
          bgColor: item['bgColor'],
          onTap: item['onTap'],
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStatus(
      BuildContext context, AttendanceProvider provider) {
    final status = provider.attendanceStatus;
    final attendance = provider.todayAttendance;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Status', style: AppTextStyles.h5),
          const SizedBox(height: 16),
          if (status == AttendanceStatus.notCheckedIn)
            _buildStatusRow('Not Checked In', Icons.circle_outlined,
                AppColors.textSecondary),
          if (status == AttendanceStatus.checkedIn) ...[
            _buildStatusRow(
                'Checked In', Icons.check_circle, AppColors.success),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Check-In Time',
              DateFormat('HH:mm').format(attendance!.checkInTime),
            ),
            _buildInfoRow(
              'Location',
              attendance.locationName ?? '-',
            ),
          ],
          if (status == AttendanceStatus.checkedOut) ...[
            _buildStatusRow(
                'Checked Out', Icons.check_circle, AppColors.primary),
            const SizedBox(height: 12),
            _buildInfoRow(
              'Check-In',
              DateFormat('HH:mm').format(attendance!.checkInTime),
            ),
            _buildInfoRow(
              'Check-Out',
              DateFormat('HH:mm').format(attendance.checkOutTime!),
            ),
            _buildInfoRow(
              'Duration',
              attendance.getFormattedDuration(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusRow(String text, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.h5.copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, AttendanceProvider provider) {
    final status = provider.attendanceStatus;

    if (status == AttendanceStatus.checkedOut) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Work Complete!',
                    style: AppTextStyles.h5.copyWith(color: AppColors.success),
                  ),
                  Text(
                    'You have checked out for today',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Show both buttons, enable/disable based on status
    return Column(
      children: [
        // Check-In Button
        CustomButton(
          text: 'Check In',
          icon: Icons.login,
          onPressed: status == AttendanceStatus.notCheckedIn
              ? () => _showCheckInDialog(context, provider)
              : null, // Disabled when already checked in
          isLoading: provider.isLoading,
          width: double.infinity,
          backgroundColor: status == AttendanceStatus.notCheckedIn
              ? AppColors.primary
              : AppColors.textDisabled,
        ),
        const SizedBox(height: 12),
        // Check-Out Button
        CustomButton(
          text: 'Check Out',
          icon: Icons.logout,
          onPressed: status == AttendanceStatus.checkedIn
              ? () => _showCheckOutDialog(context, provider)
              : null, // Disabled when not checked in yet
          isLoading: provider.isLoading,
          width: double.infinity,
          backgroundColor: status == AttendanceStatus.checkedIn
              ? AppColors.secondary
              : AppColors.textDisabled,
        ),
      ],
    );
  }

  // Keep old single button version for reference
  Widget _buildActionButtonOld(
      BuildContext context, AttendanceProvider provider) {
    final status = provider.attendanceStatus;

    if (status == AttendanceStatus.checkedOut) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Work Complete!',
                    style: AppTextStyles.h5.copyWith(color: AppColors.success),
                  ),
                  Text(
                    'You have checked out for today',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return CustomButton(
      text: status == AttendanceStatus.notCheckedIn ? 'Check In' : 'Check Out',
      icon: status == AttendanceStatus.notCheckedIn
          ? Icons.login
          : Icons.logout,
      onPressed: () {
        if (status == AttendanceStatus.notCheckedIn) {
          _showCheckInDialog(context, provider);
        } else {
          _showCheckOutDialog(context, provider);
        }
      },
      isLoading: provider.isLoading,
      width: double.infinity,
      backgroundColor: status == AttendanceStatus.notCheckedIn
          ? AppColors.primary
          : AppColors.secondary,
    );
  }

  Widget _buildLocationInfo(AttendanceProvider provider) {
    if (provider.nearbyLocations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Nearby Locations', style: AppTextStyles.h5),
            ],
          ),
          const SizedBox(height: 16),
          ...provider.nearbyLocations.map((location) {
            final distance = provider.currentPosition != null
                ? provider.nearbyLocations.indexOf(location)
                : null;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      location.name,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showCheckInDialog(BuildContext context, AttendanceProvider provider) {
    if (provider.nearbyLocations.isEmpty) {
      Fluttertoast.showToast(
        msg: 'No nearby locations found',
        backgroundColor: AppColors.warning,
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Location', style: AppTextStyles.h4),
            const SizedBox(height: 24),
            ...provider.nearbyLocations.map((location) {
              return ListTile(
                leading: const Icon(Icons.location_on, color: AppColors.primary),
                title: Text(location.name),
                subtitle: Text(location.description ?? ''),
                onTap: () async {
                  Navigator.pop(context);
                  final success = await provider.checkIn(location: location);
                  if (context.mounted) {
                    Fluttertoast.showToast(
                      msg: success
                          ? 'Check-in successful!'
                          : provider.errorMessage ?? 'Check-in failed',
                      backgroundColor:
                          success ? AppColors.success : AppColors.error,
                    );
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showCheckOutDialog(BuildContext context, AttendanceProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Check Out'),
        content: const Text('Are you sure you want to check out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.checkOut();
              if (context.mounted) {
                Fluttertoast.showToast(
                  msg: success
                      ? 'Check-out successful!'
                      : provider.errorMessage ?? 'Check-out failed',
                  backgroundColor: success ? AppColors.success : AppColors.error,
                );
              }
            },
            child: const Text('Check Out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header dengan gradient
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Row(
                  children: [
                    // Profile Picture
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 36,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, ${user?.fullName ?? 'User'}',
                            style: AppTextStyles.h4.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.company ?? 'Company Name',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.notifications_outlined,
                              color: AppColors.white,
                              size: 24,
                            ),
                          ),
                          // Notification badge
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFDD835),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEmployeeDataCard(user),
                  const SizedBox(height: 16),
                  _buildMenuSection(context),
                  const SizedBox(height: 24),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeDataCard(UserModel? user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Kepegawaian',
            style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildEmployeeInfoRow(
            'Status Karyawan',
            user?.employeeStatus ?? '-',
            'Jabatan',
            user?.position ?? '-',
          ),
          const SizedBox(height: 12),
          _buildEmployeeInfoRow(
            'Unit Kerja',
            user?.department ?? '-',
            'Golongan',
            user?.grade ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeInfoRow(
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value1,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value2,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.person_outline,
        'title': 'Edit Profile',
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Edit Profile - Coming soon')),
          );
        },
      },
      {
        'icon': Icons.lock_outline,
        'title': 'Change Password',
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Change Password - Coming soon')),
          );
        },
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'Settings',
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Settings - Coming soon')),
          );
        },
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: menuItems.map((item) {
          return ListTile(
            leading: Icon(
              item['icon'] as IconData,
              color: AppColors.primary,
            ),
            title: Text(
              item['title'] as String,
              style: AppTextStyles.bodyMedium,
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
            onTap: item['onTap'] as VoidCallback,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: AppColors.error),
        title: Text(
          'Logout',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );

          if (shouldLogout == true && context.mounted) {
            await context.read<AuthProvider>().logout();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          }
        },
      ),
    );
  }
}
