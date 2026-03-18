import 'package:dishabtob/global/app_colors.dart';
import 'package:flutter/material.dart';

class TatTable extends StatefulWidget {
  final List<String> l1;
  final List<dynamic> l2;
  final List<dynamic>? l3;
  final List<dynamic>? l4;
  final List<dynamic>? l5;
  final List<String> tableHeader;

  const TatTable(
      {super.key,
      required this.l1,
      required this.l2,
      this.l3,
      required this.tableHeader,
      this.l4,
      this.l5});

  @override
  State<TatTable> createState() => _TatTableState();
}

class _TatTableState extends State<TatTable> {
  bool isLoading = true;

  @override
  void initState() {
    shwProgressIndicator();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,

            child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                children: [
                  widget.l1.isNotEmpty
                      ? _buildRoundedTableRow(widget.tableHeader)
                      : const TableRow(children: [Text('Data Not available')]),
                  for (int i = 0; i < widget.l1.length; i++)
                    widget.l1.isNotEmpty
                        ? _buildTableRow(i)
                        : const TableRow(children: [Text('')]),
                ],
              ),
          ),
        );
  }

  shwProgressIndicator() async {
    await Future.delayed(const Duration(seconds: 0));
    setState(() {
      isLoading = false;
    });
  }

  TableRow _buildRoundedTableRow(List<String> data) {
    return TableRow(
      children: List.generate(
        data.length,
        (index) => TableCell(
          child: Container(
            decoration: BoxDecoration(
              color: AppColours.blue,
              // Background color of the first row
              borderRadius: BorderRadius.only(
                topLeft: index == 0 ? const Radius.circular(10.0) : Radius.zero,
                topRight: index == data.length - 1
                    ? const Radius.circular(10.0)
                    : Radius.zero,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: Text(
              data[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ), // Text color
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(int index) {
    return TableRow(
      children: List.generate(
        widget.tableHeader.length,
            (i) => TableCell(
          verticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child:

              Text(
                [
                  widget.l1[index],
                  widget.l2[index],
                  if (widget.l3 != null) widget.l3?[index],
                  if (widget.l4 != null) widget.l4?[index],
                  if (widget.l5 != null) widget.l5?[index],
                ][i]
                    .toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }



}
