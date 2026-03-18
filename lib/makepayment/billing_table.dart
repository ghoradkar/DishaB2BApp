import 'package:dishabtob/global/app_colors.dart';
import 'package:flutter/material.dart';

class BillingTable extends StatefulWidget {
  final List<String> l1;
  final List<dynamic> l2;
  final List<dynamic>? l3;
  final List<dynamic>? l4;
  final List<dynamic>? l5;
  final List<Widget>? lastColumnWidgets;
  final List<String> tableHeader;
  final Function(int index)? onButtonPressed;

  const BillingTable(
      {super.key,
      required this.l1,
      required this.l2,
      this.l3,
      required this.tableHeader,
      this.lastColumnWidgets,
      this.onButtonPressed,
      this.l4,
      this.l5});

  @override
  State<BillingTable> createState() => _BillingTableState();
}

class _BillingTableState extends State<BillingTable> {
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
            (i) {
          if (i < widget.tableHeader.length - 1) {
            // Handle data columns
            List<dynamic> dataSources = [
              widget.l1,
              widget.l2,
              if (widget.l3 != null) widget.l3!,
              if (widget.l4 != null) widget.l4!,
              if (widget.l5 != null) widget.l5!,
            ];

            if (i < dataSources.length && index < dataSources[i].length) {
              return TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Text(
                    dataSources[i][index].toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          } else {
            // Handle the last column (buttons)
            return TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: InkWell(
                onTap: (){
                  widget.onButtonPressed!(index);
                },
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Icon(
                    Icons.download_for_offline,
                    color: AppColours.orange,
                    size: 28,
                  ),
                ),
              ),
            );
          }
          return const TableCell(child: SizedBox.shrink());
        },
      ),
    );
  }



}
