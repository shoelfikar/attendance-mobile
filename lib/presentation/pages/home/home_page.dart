import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, size: 50, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(user?.fullName ?? 'User', style: AppTextStyles.h3),
              Text(
                user?.email ?? '',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text('Logout'),
                onTap: () async {
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
