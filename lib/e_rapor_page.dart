import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wicaraplusapp/login_page.dart';
import 'package:wicaraplusapp/therapy_progress_service.dart';

class ERaporPage extends StatelessWidget {
  const ERaporPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('E-Rapor Terapi')),
      body: user == null
          ? _SignInPrompt(
              onSignIn: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
            )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: TherapyProgressService().watchAttempts(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const _MessageView(
                    icon: Icons.cloud_off_outlined,
                    message:
                        'E-Rapor tidak dapat dimuat. Periksa koneksi internet dan coba lagi.',
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final cutoff = DateTime.now().subtract(
                  const Duration(days: 30),
                );
                final attempts = (snapshot.data?.docs ?? [])
                    .map(TherapyAttempt.fromDocument)
                    .where(
                      (attempt) =>
                          attempt.recordedAt != null &&
                          !attempt.recordedAt!.isBefore(cutoff),
                    )
                    .toList();

                return _ReportContent(attempts: attempts);
              },
            ),
    );
  }
}

class _ReportContent extends StatelessWidget {
  const _ReportContent({required this.attempts});

  final List<TherapyAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final correctCount = attempts.where((attempt) => attempt.isCorrect).length;
    final accuracy = attempts.isEmpty ? 0.0 : correctCount / attempts.length;
    final categoryCounts = <String, List<TherapyAttempt>>{};
    for (final attempt in attempts) {
      categoryCounts.putIfAbsent(attempt.category, () => []).add(attempt);
    }
    final sortedCategories = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Ringkasan ini berdasarkan jawaban latihan di aplikasi selama 30 hari terakhir. '
                  'Hasilnya bukan diagnosis atau penilaian klinis.',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Jawaban latihan',
                value: '${attempts.length}',
                icon: Icons.assignment_turned_in_outlined,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: 'Ketepatan',
                value: attempts.isEmpty ? '-' : '${(accuracy * 100).round()}%',
                icon: Icons.track_changes,
                color: Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: 'Kategori dilatih',
                value: '${categoryCounts.length}',
                icon: Icons.category_outlined,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: 'Hari latihan',
                value: '${_activeDays(attempts)}',
                icon: Icons.calendar_month_outlined,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Aktivitas 7 hari terakhir',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _WeeklyActivityChart(attempts: attempts),
        const SizedBox(height: 24),
        const Text(
          'Perkembangan per kategori',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (sortedCategories.isEmpty)
          const _EmptyReportMessage()
        else
          ...sortedCategories.map((entry) {
            final total = entry.value.length;
            final correct = entry.value
                .where((attempt) => attempt.isCorrect)
                .length;
            final rate = total == 0 ? 0.0 : correct / total;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text('$correct/$total benar'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: rate,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
            );
          }),
        const SizedBox(height: 16),
        const Text(
          'Riwayat latihan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (attempts.isEmpty)
          const _EmptyReportMessage()
        else
          ...attempts
              .take(20)
              .map(
                (attempt) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    attempt.isCorrect
                        ? Icons.check_circle
                        : Icons.replay_circle_filled,
                    color: attempt.isCorrect ? Colors.green : Colors.orange,
                  ),
                  title: Text(attempt.activity),
                  subtitle: Text(
                    '${attempt.therapyType} • ${attempt.category} • '
                    '${_formatDate(attempt.recordedAt!)}',
                  ),
                  trailing: Text(attempt.isCorrect ? 'Benar' : 'Coba lagi'),
                ),
              ),
      ],
    );
  }

  int _activeDays(List<TherapyAttempt> attempts) {
    return attempts
        .map((attempt) {
          final date = attempt.recordedAt!;
          return DateTime(date.year, date.month, date.day);
        })
        .toSet()
        .length;
  }
}

class _WeeklyActivityChart extends StatelessWidget {
  const _WeeklyActivityChart({required this.attempts});

  final List<TherapyAttempt> attempts;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = List.generate(
      7,
      (index) => DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(Duration(days: 6 - index)),
    );

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: days.map((day) {
          final count = attempts.where((attempt) {
            final date = attempt.recordedAt!;
            return date.year == day.year &&
                date.month == day.month &&
                date.day == day.day;
          }).length;
          final maxCount = days
              .map(
                (candidate) => attempts.where((attempt) {
                  final date = attempt.recordedAt!;
                  return date.year == candidate.year &&
                      date.month == candidate.month &&
                      date.day == candidate.day;
                }).length,
              )
              .fold<int>(0, (max, value) => value > max ? value : max);
          final barHeight = maxCount == 0 ? 0.0 : 90.0 * count / maxCount;

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('$count', style: const TextStyle(fontSize: 11)),
                const SizedBox(height: 4),
                Container(
                  height: barHeight == 0 ? 4 : barHeight,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${day.day}/${day.month}',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _EmptyReportMessage extends StatelessWidget {
  const _EmptyReportMessage();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Text('Belum ada hasil latihan dalam 30 hari terakhir.'),
    );
  }
}

class _SignInPrompt extends StatelessWidget {
  const _SignInPrompt({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return _MessageView(
      icon: Icons.lock_outline,
      message: 'Masuk ke akun orang tua untuk melihat dan menyimpan E-Rapor.',
      action: TextButton(onPressed: onSignIn, child: const Text('Masuk')),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.icon, required this.message, this.action});

  final IconData icon;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.blueGrey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            ?action,
          ],
        ),
      ),
    );
  }
}

class TherapyAttempt {
  const TherapyAttempt({
    required this.therapyType,
    required this.category,
    required this.activity,
    required this.isCorrect,
    required this.recordedAt,
  });

  factory TherapyAttempt.fromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    final timestamp = data['recordedAt'];

    return TherapyAttempt(
      therapyType: data['therapyType'] as String? ?? 'Terapi',
      category: data['category'] as String? ?? 'Lainnya',
      activity: data['activity'] as String? ?? 'Latihan',
      isCorrect: data['isCorrect'] as bool? ?? false,
      recordedAt: timestamp is Timestamp ? timestamp.toDate() : null,
    );
  }

  final String therapyType;
  final String category;
  final String activity;
  final bool isCorrect;
  final DateTime? recordedAt;
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$day/$month/${date.year} $hour:$minute';
}
