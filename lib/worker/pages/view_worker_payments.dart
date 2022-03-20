import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/core/models/payment.dart';
import 'package:parking_graduation_app_1/core/services/Api/payments_api_service.dart';
import 'package:parking_graduation_app_1/worker/pages/add_payment.dart';
import 'package:parking_graduation_app_1/worker/widgets/worker_drawer.dart';

class ViewWorkerPayments extends StatefulWidget {
  const ViewWorkerPayments({Key? key}) : super(key: key);

  @override
  _ViewWorkerPaymentsState createState() => _ViewWorkerPaymentsState();
}

class _ViewWorkerPaymentsState extends State<ViewWorkerPayments> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('الدفعات'),
          ),
          drawer: const WorkerDrawer(),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: onAddPress,
                    child: const Text(
                      'دفعة جديدة +',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              StreamBuilder<List<Payment>>(
                stream: PaymentsApiService().getWorkerPaymentsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  var payments = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var payment in payments!)
                        _PaymentCard(
                          payment: payment,
                        )
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void onAddPress() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddPayment()),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.payment,
    Key? key,
  }) : super(key: key);

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[50],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(payment.userFullName ?? ''),
        subtitle: Text(payment.amount.toString()),
        trailing: Text(
          payment.date ?? '',
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }
}
