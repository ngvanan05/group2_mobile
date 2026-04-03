import 'package:flutter/material.dart';
import 'package:group2_mobile/features/task/screens/task_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  final List<String> _recentSearches = [
    'Phòng 402',
    'Kỹ thuật',
    'Bồn cầu',
  ];

  final List<String> _departments = [
    'Buồng phòng',
    'Kỹ thuật',
    'Lễ tân',
    'Dịch vụ',
    'An ninh',
    'Nhà hàng',
  ];

  final List<Map<String, dynamic>> _allTasks = [
    {
      'title': 'Sửa bồn cầu rò rỉ nước',
      'location': 'Phòng 402',
      'department': 'Bộ phận Kỹ thuật',
      'assignee': 'Nguyễn Văn A',
      'time': '10 phút trước',
      'priority': 'KHẨN CẤP',
      'status': 'Đang xử lý',
    },
    {
      'title': 'Dọn phòng định kỳ',
      'location': 'Phòng 402',
      'department': 'Bộ phận Buồng phòng',
      'assignee': 'Đã kiểm tra bởi Giám sát',
      'time': '08:30 AM',
      'priority': 'HOÀN THÀNH',
      'status': 'Hoàn thành',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredTasks() {
    if (_searchQuery.isEmpty) return [];
    return _allTasks.where((task) {
      return task['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task['location'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task['department'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _getFilteredTasks();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm công việc...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: InputBorder.none,
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text(
                'Tìm kiếm',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          if (_isSearching && _searchQuery.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              child: const Text(
                'Hủy',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Box
              if (!_isSearching)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey.shade600),
                        const SizedBox(width: 12),
                        Text(
                          'Tìm kiếm công việc...',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (_searchQuery.isEmpty) ...[
                const SizedBox(height: 24),
                // Recent Searches
                Text(
                  'TÌM KIẾM GẦN ĐÂY',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                ..._recentSearches.map((search) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _searchController.text = search;
                        _searchQuery = search;
                        _isSearching = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.history, color: Colors.grey.shade400, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              search,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 32),

                // Department Suggestions
                Text(
                  'GỢI Ý THEO BỘ PHẬN',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _departments.map((dept) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _searchController.text = dept;
                          _searchQuery = dept;
                          _isSearching = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: Text(
                          dept,
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Search Results
              if (_searchQuery.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Tìm thấy ${filteredTasks.length} kết quả cho "$_searchQuery"',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ...filteredTasks.map((task) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailScreen(
                            title: task['title'],
                            priority: task['priority'],
                            location: 'FourPoint Hotel - ${task['location']}',
                            department: task['department'],
                            assignee: task['assignee'],
                            startTime: task['time'],
                            description: 'Chi tiết công việc...',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: task['status'] == 'Hoàn thành'
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  task['priority'],
                                  style: TextStyle(
                                    color: task['status'] == 'Hoàn thành' ? Colors.green : Colors.red,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                task['location'],
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            task['title'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.business_center_outlined, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 6),
                              Text(
                                task['department'],
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.orange.shade100,
                                child: Text(
                                  task['assignee'][0],
                                  style: TextStyle(
                                    color: Colors.orange.shade700,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  task['assignee'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              Text(
                                task['time'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
