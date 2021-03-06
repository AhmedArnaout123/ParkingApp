import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/common/pages/login_page.dart';
import 'package:parking_graduation_app_1/core/Helpers/constants_helper.dart';
import 'package:parking_graduation_app_1/core/Helpers/dates_helper.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/Providers/current_user_provider.dart';
import 'package:parking_graduation_app_1/core/models/reservation.dart';
import 'package:parking_graduation_app_1/core/models/accounts/user.dart';
import 'package:parking_graduation_app_1/core/services/Api/reservations_api_service.dart';
import 'package:parking_graduation_app_1/core/services/Api/users_api_service.dart';
import 'package:parking_graduation_app_1/core/services/logout_service.dart';
import 'package:parking_graduation_app_1/core/services/notifications_service.dart';
import 'package:parking_graduation_app_1/core/services/storage_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: double.infinity,
          leading: TextButton.icon(
            onPressed: () => LogoutService().logout(context),
            label: const Text(
              "تسجيل الخروج",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ),
        body: StreamBuilder<User>(
          stream:
              UsersApiService().getUserStream(CurrentUserProvider().user.id!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            var user = snapshot.data!;
            return ListView(
              children: [
                const SizedBox(height: 30),
                Container(
                  height: 70,
                  color: Colors.blue[50],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Text(
                      'الرصيد الحالي' + ' :' + ' ${user.balance.toString()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                user.currentReservationId != null
                    ? CurrentReservationWidget(user.currentReservationId!)
                    : Container(
                        height: 70,
                        color: Colors.blue[50],
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: const Center(
                          child: Text(
                            'لا يوجد حجز لك الآن',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    NotificationService().show();
                  },
                  child: Text("Click me"),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> logout() async {
    var isSure = await UiHelper.showConfirmationDialog(
      context,
      'هل أنت متأكد من تسجيل الخروج',
    );
    if (!isSure) return;

    await StorageService().remove('userId');
    await StorageService().remove('userRole');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}

class CurrentBalanceCard extends StatelessWidget {
  const CurrentBalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CurrentReservationWidget extends StatelessWidget {
  const CurrentReservationWidget(this.reservationId, {Key? key})
      : super(key: key);

  final String reservationId;
  String getHoursFromDate(String date) {
    return date.substring(date.length - 5, date.length);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Reservation>(
      stream: ReservationsApiService().getReservationStream(reservationId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        var reservation = snapshot.data!;
        return Container(
          color: Colors.blue[50],
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(
                '${getHoursFromDate(reservation.startDate!)} - ${getHoursFromDate(reservation.endDate!)}'),
            subtitle: Text(reservation.locationName!),
            trailing: TextButton(
              onPressed: () async {
                showReservationExtendingDialog(context, reservation);
              },
              child: Text(
                'تمديد الحجز',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showReservationExtendingDialog(
      BuildContext context, Reservation reservation) {
    var selectedReservation = ConstantsHelper.reservationCategories[1];
    var isLoading = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStater) {
            return SizedBox(
              height: 100,
              child: Dialog(
                insetPadding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  top: 60,
                  bottom: 90,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: ListView(
                        children: [
                          for (var res in ConstantsHelper.reservationCategories)
                            ListTile(
                              title: Text(res['text']),
                              subtitle: Text(res['price'].toString()),
                              trailing: Radio<Map<String, dynamic>>(
                                groupValue: selectedReservation,
                                value: res,
                                onChanged: (res) {
                                  selectedReservation = res!;
                                  setStater(() {});
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (CurrentUserProvider().user.balance! <
                              selectedReservation['price']) {
                            UiHelper.showDialogWithOkButton(
                              context,
                              'لا يوجد لديك رصيد كافي',
                              (_) => Navigator.of(context).pop(),
                            );
                            return;
                          }
                          isLoading = true;
                          setStater(() {});
                          DateTime oldEndDate = DatesHelper.getDateFromString(
                              reservation.endDate!);
                          var newEndDate = oldEndDate.add(
                            selectedReservation['hours'] == 0.5
                                ? const Duration(minutes: 30)
                                : Duration(
                                    hours:
                                        selectedReservation['hours']?.toInt() ??
                                            0,
                                  ),
                          );
                          var newCost =
                              reservation.cost! + selectedReservation['price'];
                          await ReservationsApiService().extendReservation(
                            reservationId,
                            newEndDate.toString().substring(0, 16),
                            newCost.toInt(),
                          );
                          await UsersApiService().subtractFromBalance(
                              CurrentUserProvider().user.id!,
                              selectedReservation['price']);
                          UiHelper.showDialogWithOkButton(
                              context,
                              'تم تمديد الحجز',
                              (_) => Navigator.of(context).pop());
                        },
                        child: isLoading
                            ? const Center(
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text('تأكيد'),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
