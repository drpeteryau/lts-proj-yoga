import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryTeal = Color(0xFF2CC5B6);
    const pageBg = Color(0xFFF2FCFA);
    const cardBg = Colors.white;
    const faintTeal = Color(0xFFE3F8F5);

    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: faintTeal,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Progress',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.teal[800],
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 6),
                    Text(
                      'Celebrating your wellness journey',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.teal[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.25,
                      children: const [
                        _StatCard(
                          icon: Icons.calendar_today,
                          value: '24',
                          label: 'Total Sessions',
                        ),
                        _StatCard(
                          icon: Icons.access_time,
                          value: '360',
                          label: 'Minutes Practiced',
                        ),
                        _StatCard(
                          icon: Icons.local_fire_department,
                          value: '5',
                          label: 'Current Streak',
                          iconColor: Colors.deepOrange,
                        ),
                        _StatCard(
                          icon: Icons.star,
                          value: '3',
                          label: 'Achievements',
                          iconColor: Colors.amber,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Weekly Goal
                    _GoalCard(
                      current: 95,
                      target: 150,
                      subtitle:
                          '55 minutes to reach your weekly goal', // matches screenshot
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // This Week
              _SectionCard(
                title: 'This Week',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WeekRow(
                      days: const [
                        _DayStat('Mon', 15),
                        _DayStat('Tue', 20),
                        _DayStat('Wed', 10),
                        _DayStat('Thu', 25),
                        _DayStat('Fri', 15),
                        _DayStat('Sat', 0),
                        _DayStat('Sun', 0),
                      ],
                      goalPerDay: 30, // for fill ratio of the capsules
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _SectionCard(
              title: 'Achievements',
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1, // slightly taller cells
                    children: const [
                      _AchievementCard(
                        icon: Icons.gps_fixed,
                        title: 'First Step',
                        subtitle: 'Completed first session',
                        earned: true,
                        badgeText: 'Earned!',
                      ),
                      _AchievementCard(
                        icon: Icons.local_fire_department,
                        title: 'Week Warrior',
                        subtitle: '7 day streak',
                        earned: true,
                        badgeText: 'Earned!',
                      ),
                      _AchievementCard(
                        icon: Icons.sports_gymnastics,
                        title: 'Flexibility Master',
                        subtitle: '20 flexibility sessions',
                        earned: true,
                        badgeText: 'Earned!',
                      ),
                      _AchievementCard(
                        icon: Icons.wb_twighlight,
                        title: 'Morning Person',
                        subtitle: '10 morning sessions',
                        earned: false,
                      ),
                      _AchievementCard(
                        icon: Icons.self_improvement,
                        title: 'Zen Master',
                        subtitle: '50 total sessions',
                        earned: false,
                      ),
                      _AchievementCard(
                        icon: Icons.emoji_events_outlined,
                        title: 'Consistency King',
                        subtitle: '30 day streak',
                        earned: false,
                      ),
                    ],
                  );
                },
              ),
            ),


              const SizedBox(height: 16),

              // Footer encouragement
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE7FFF9), Color(0xFFD0F7F0)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.trending_up, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keep it up!',
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          const Text(
                            "You're building healthy habits that will benefit you for years to come.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -------------------------- Components & Models -------------------------- */

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFEFFAF7),
              child: Icon(icon, size: 20, color: iconColor ?? Colors.teal),
            ),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.teal[700],
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(label,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                )),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final int current;
  final int target;
  final String subtitle;
  const _GoalCard({
    required this.current,
    required this.target,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (current / target).clamp(0.0, 1.0);
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Weekly Goal',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8FBF6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text('$current/$target min',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 8,
                child: Stack(
                  children: [
                    Container(color: const Color(0xFFE2F3F0)),
                    FractionallySizedBox(
                      widthFactor: ratio,
                      child: Container(color: const Color(0xFF26B7A8)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _DayStat {
  final String label;
  final int minutes;
  const _DayStat(this.label, this.minutes);
}

class _WeekRow extends StatelessWidget {
  final List<_DayStat> days;
  final int goalPerDay;
  const _WeekRow({required this.days, required this.goalPerDay});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Capsules
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days
              .map((d) => _Pill(value: d.minutes, maxValue: goalPerDay))
              .toList(),
        ),
        const SizedBox(height: 10),
        // Day labels with minutes
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: days
              .map((d) => Column(
                    children: [
                      Text(d.label,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('${d.minutes}m',
                          style: TextStyle(color: Colors.teal[700])),
                    ],
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final int value;
  final int maxValue;
  const _Pill({required this.value, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    final fill = (value / maxValue).clamp(0.0, 1.0);
    return Container(
      width: 34,
      height: 76,
      decoration: BoxDecoration(
        color: const Color(0xFFEFFAF7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: fill,
          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF22B2A3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool earned;
  final String? badgeText;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.earned,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final locked = !earned;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: locked ? Colors.grey.shade200 : Colors.teal.shade50,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:
                locked ? const Color(0xFFF2F2F2) : const Color(0xFFE8FBF6),
            child: Icon(icon, color: locked ? Colors.grey : Colors.teal),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.teal[800],
                ),
          ),
          const SizedBox(height: 4),
          Flexible( // <-- prevents overflow when text wraps
            child: Text(
              subtitle,
              style: TextStyle(color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          if (earned && badgeText != null)
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8FBF6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
