class ExportOptions {
  String format; // 'PDF' or 'CSV'
  List<String> selectedFields;

  ExportOptions({
    this.format = 'CSV', // Default
    this.selectedFields = const [
      'Title',
      'Description',
      'Due Date',
      'Priority',
      'Status'
    ], // Default fields
  });
}