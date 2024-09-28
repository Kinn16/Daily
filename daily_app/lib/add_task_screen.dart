import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Để định dạng ngày tháng

class AddTaskScreen extends StatefulWidget {
  final Function(Map<String, String>)
      onAddTask; // Callback để truyền task về TaskListScreen

  const AddTaskScreen({super.key, required this.onAddTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  String _taskTitle = "";
  String _location = "";
  String _host = "";
  String _notes = "";
  String _status = "Tạo mới"; // Trạng thái mặc định
  DateTime? _selectedDate;
  String _startTime = "";
  String _endTime = "";

  // Danh sách người chủ trì
  final List<String> _hosts = ['ChunVN', 'Thành Thái'];

  // Danh sách trạng thái công việc
  final List<String> _statuses = [
    'Tạo mới',
    'Thực hiện',
    'Thành công',
    'Kết thúc'
  ];

  // Hàm chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Hàm chọn thời gian bắt đầu và kết thúc
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime.format(context);
        } else {
          _endTime = pickedTime.format(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm Công Việc Mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nội dung công việc
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Nội dung công việc'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập nội dung công việc';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _taskTitle = value!;
                  },
                ),
                const SizedBox(height: 10),

                // Ngày tháng
                Row(
                  children: [
                    const Text("Chọn ngày: "),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(_selectedDate == null
                          ? "Chọn ngày"
                          : DateFormat('EEEE, dd/MM/yyyy')
                              .format(_selectedDate!)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Thời gian
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text("Giờ bắt đầu"),
                          TextButton(
                            onPressed: () => _selectTime(context, true),
                            child: Text(
                                _startTime.isEmpty ? "Chọn giờ" : _startTime),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          const Text("Giờ kết thúc"),
                          TextButton(
                            onPressed: () => _selectTime(context, false),
                            child:
                                Text(_endTime.isEmpty ? "Chọn giờ" : _endTime),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Địa điểm
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Địa điểm'),
                  onSaved: (value) {
                    _location = value!;
                  },
                ),
                const SizedBox(height: 10),

                // Người chủ trì
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Chủ trì'),
                  value: _hosts.first,
                  items: _hosts.map((host) {
                    return DropdownMenuItem(
                      value: host,
                      child: Text(host),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _host = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Ghi chú
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Ghi chú'),
                  onSaved: (value) {
                    _notes = value!;
                  },
                ),
                const SizedBox(height: 10),

                // Trạng thái công việc
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: 'Trạng thái công việc'),
                  value: _status,
                  items: _statuses.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Nút thêm công việc
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Tạo một bản ghi mới chứa thông tin công việc
                      Map<String, String> newTask = {
                        'taskTitle': _taskTitle,
                        'date': _selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                            : 'Chưa chọn ngày',
                        'startTime': _startTime,
                        'endTime': _endTime,
                        'location': _location,
                        'host': _host,
                        'notes': _notes,
                        'status': _status,
                      };

                      // Truyền thông tin công việc về màn hình trước
                      widget.onAddTask(newTask);

                      // Quay lại màn hình danh sách công việc
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Thêm Công Việc'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
