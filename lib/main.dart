import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MobileDashboard(),
    );
  }
}

class MobileDashboard extends StatefulWidget {
  const MobileDashboard({super.key});

  @override
  State<MobileDashboard> createState() => _MobileDashboardState();
}

class _MobileDashboardState extends State<MobileDashboard> {
  // Demo data
  final List<Map<String, dynamic>> _stats = [
    {'title': 'Revenue', 'value': '\$42K', 'change': '+12.5%', 'icon': Icons.attach_money},
    {'title': 'Orders', 'value': '38', 'change': '-2.4%', 'icon': Icons.shopping_cart},
    {'title': 'Customers', 'value': '1.2K', 'change': '+3.2%', 'icon': Icons.people},
  ];

  final List<Map<String, dynamic>> _recentTransactions = [
    {'client': 'TechCorp', 'amount': 75000, 'status': 'Completed'},
    {'client': 'StartUp', 'amount': 25000, 'status': 'Pending'},
    {'client': 'Global Inc', 'amount': 120000, 'status': 'In Progress'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('2'),
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Add refresh logic here
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats cards
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _stats.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => _buildStatCard(_stats[index]),
                  ),
                ),

                const SizedBox(height: 24),

                // Chart
                _buildChartCard(),

                const SizedBox(height: 24),

                // Transactions
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  _recentTransactions.length,
                      (index) => _buildTransactionItem(_recentTransactions[index]),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (index) {},
      ),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    return Card(
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(stat['icon'] as IconData, color: Colors.blue),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (stat['change'] as String).startsWith('+')
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    stat['change'] as String,
                    style: TextStyle(
                      color: (stat['change'] as String).startsWith('+')
                          ? Colors.green
                          : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              stat['value'] as String,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stat['title'] as String,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                          if (value.toInt() < labels.length) {
                            return Text(labels[value.toInt()],
                                style: TextStyle(color: Colors.grey[600], fontSize: 12));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 30),
                        FlSpot(1, 45),
                        FlSpot(2, 35),
                        FlSpot(3, 55),
                        FlSpot(4, 48),
                        FlSpot(5, 65),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: const Icon(Icons.receipt, color: Colors.blue),
        ),
        title: Text(
          transaction['client'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          NumberFormat.currency(symbol: '\$').format(transaction['amount']),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(transaction['status'] as String).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            transaction['status'] as String,
            style: TextStyle(
              color: _getStatusColor(transaction['status'] as String),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}