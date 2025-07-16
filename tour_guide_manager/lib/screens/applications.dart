import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tour_guide_manager/colors.dart';
import '../widgets/top_snack_bar.dart';

class Applications extends StatefulWidget {
  const Applications({super.key});

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  List<String> excludedCustomers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final firestore = FirebaseFirestore.instance;
    final userEmail = FirebaseAuth.instance.currentUser!.email!;
    final snapshot = await firestore.collection('companies').get();

    final List<String> parsedCustomers = [];
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final List<String> banList = List<String>.from(data['banList'] ?? []);
      if (banList.contains(userEmail)) {
        parsedCustomers.add(doc.id);
      }
    }

    setState(() {
      excludedCustomers = parsedCustomers;
      isLoading = false;
    });
  }

  Future<void> _acceptApplication(BuildContext context, String docId) async {
    final firestore = FirebaseFirestore.instance;
    final docRef = firestore.collection('excursions').doc(docId);
    final userEmail = FirebaseAuth.instance.currentUser!.email!;

    try {
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final data = snapshot.data() as Map<String, dynamic>;

        if ((data['assignedTo'] ?? '') != '') {
          throw Exception('already_assigned');
        }

        transaction.update(docRef, {'assignedTo': userEmail});
      });
      if (!context.mounted) return;
      showTopSnackBar(context, 'Заявка успешно принята');
    } catch (e) {
      if (!context.mounted) return;
      if (e.toString().contains('already_assigned')) {
        showTopSnackBar(context, 'Экскурсия уже занята');
      } else {
        showTopSnackBar(context, 'Ошибка. Попробуйте позже');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.darkBlue),
      );
    }

    final firestore = FirebaseFirestore.instance;
    final stream = firestore
        .collection('excursions')
        .where('assignedTo', isEqualTo: '')
        .orderBy('date')
        .orderBy('time')
        .snapshots();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Заявки',
          style: TextStyle(fontWeight: FontWeight.w600)
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.darkBlue),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/error.svg',
                    height: MediaQuery.of(context).size.height * 0.27,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ошибка загрузки',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/no_applications.svg',
                    height: MediaQuery.of(context).size.height * 0.27,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Нет заявок',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          }

          final List<ApplicationModel> applications = [];
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            if (!excludedCustomers.contains(data['customer'] ?? '')) {
              applications.add(
                ApplicationModel(
                  data['date'],
                  data['time'],
                  data['type'],
                  data['people'],
                  doc.id,
                )
              );
            }
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              final model = applications[index];
              return ApplicationCard(
                model: model,
                onAccept: () => _acceptApplication(context, model.docId)
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: applications.length
          );
        }
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final ApplicationModel model;
  final VoidCallback onAccept;
  const ApplicationCard({required this.model, required this.onAccept, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxCardWidth = 600;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth < maxCardWidth
                  ? constraints.maxWidth
                  : maxCardWidth,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.type,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${formatDate(model.date)} ${model.time}, ${model.people} чел.',
                        style: const TextStyle(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: AppColors.darkBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onAccept,
                    child: const Text('Принять'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ApplicationModel {
  final String date;
  final String time;
  final String type;
  final int people;
  final String docId;

  const ApplicationModel(
    this.date,
    this.time,
    this.type,
    this.people,
    this.docId
  );
}

String formatDate(String formattedDate) {
  final DateTime date = DateTime.parse(formattedDate);
  const months = [
    'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
  ];
  return '${date.day} ${months[date.month - 1]}';
}
