class ExportOptions {
  String format; // 'PDF' or 'CSV'
  List<String> selectedFields;

  ExportOptions({
    this.format = 'CSV', // Default
    List<String>? initialFields, // Default fields
  }) : selectedFields =
           initialFields ??
           [
             'Title',
             'Description',
             'Due Date',
             'Priority',
             'Status',
             'Category',
           ];
}
