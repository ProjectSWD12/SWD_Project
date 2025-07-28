import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_manager/colors.dart';
import '../providers/guide_provider.dart';
import '../widgets/top_snack_bar.dart';
import 'package:tour_guide_manager/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class Applications extends StatefulWidget {
  const Applications({super.key});

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  late final FirebaseFirestore firestore;
  late final String userEmail;

  late Stream<CombinedData> combinedStream;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    userEmail = FirebaseAuth.instance.currentUser!.email!;

    final guide = Provider.of<GuideProvider>(context, listen: false).guide;

    if (guide == null) {
      combinedStream = const Stream.empty();
      return;
    }

    final level = guide.level;

    combinedStream = Rx.combineLatest3<QuerySnapshot, QuerySnapshot, QuerySnapshot, CombinedData>(
      firestore.collection('companies').snapshots(),
      firestore.collectionGroup('applications')
        .where('email', isEqualTo: userEmail)
        .snapshots(),
      firestore.collection('excursions')
        .where('hasSpots', isEqualTo: true)
        .where('requiredLevels', arrayContains: level)
        .orderBy('startDate')
        .snapshots(),

      (companiesSnapshot, applicationsSnapshot, excursionsSnapshot) {
        final bannedCompanies = companiesSnapshot.docs.where((doc) {
          final banList = List<String>.from(doc['banList'] ?? []);
          return banList.contains(userEmail);
        }).map((doc) => doc.id).toSet();

        final Map<String, String> appliedStatuses = {};
        for (var app in applicationsSnapshot.docs) {
          final excursionId = app.reference.parent.parent!.id;
          final status = app['status'] as String? ?? '';
          appliedStatuses[excursionId] = status;
        }

        final excursions = excursionsSnapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final excursionId = doc.id;
          final companyId = data['companyId'] ?? '';

          if (bannedCompanies.contains(companyId)) return false;

          final status = appliedStatuses[excursionId];
          return status == null || status == 'pending';
        }).toList();

        return CombinedData(
          bannedCompanies: bannedCompanies,
          appliedExcursionStatuses: appliedStatuses,
          excursions: excursions,
        );
      }
    );
  }

  Future<void> _sendApplication(String docId) async {
    final docRef = firestore.collection('excursions').doc(docId);
    final appRef = docRef.collection('applications').doc(userEmail);

    try {
      await firestore.runTransaction((tx) async {
        final snapshot = await tx.get(docRef);
        final data = snapshot.data()!;
        if (!(data['hasSpots'] ?? false)) {
          throw Exception('already_assigned');
        }

        tx.set(appRef, {
          'email': userEmail,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      if (!mounted) return;
      showTopSnackBar(context, 'Заявка отправлена');
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().contains('already_assigned')
          ? 'Экскурсия уже занята'
          : 'Ошибка. Попробуйте позже';
      showTopSnackBar(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Заявки',
          style: TextStyle(fontWeight: FontWeight.w600)
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<CombinedData>(
        stream: combinedStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.darkBlue),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
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
                      fontSize: 22
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final excursions = data.excursions;
          final appliedStatuses = data.appliedExcursionStatuses;

          if (excursions.isEmpty) {
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
                      fontSize: 22
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          }

          return ListView.separated(
              itemBuilder: (context, index) {
                final doc = excursions[index];
                final data = doc.data() as Map<String, dynamic>;
                final docId = doc.id;

                final status = appliedStatuses[docId];
                final isPending = status == 'pending';
                final isDisabled = isPending;

                return ApplicationCard(
                  model: ApplicationModel(
                    date: formatDate(data['startDate']),
                    time: formatTime(data['startDate']),
                    title: data['title'] ?? 'Экскурсия',
                    people: data['maxParticipants'] ?? 0,
                    docId: docId,
                    status: isPending ? 'pending' : 'available',
                  ),
                  onAccept: () => _sendApplication(docId),
                  isDisabled: isDisabled,
                );
              },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: excursions.length
          );
        }
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final ApplicationModel model;
  final VoidCallback onAccept;
  final bool isDisabled;

  const ApplicationCard({
    required this.model,
    required this.onAccept,
    required this.isDisabled,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxCardWidth = 600;
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          '${model.date} ${model.time}, ${model.people} чел.',
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                      backgroundColor: AppColors.darkBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isDisabled ? null : onAccept,
                    child: Text(isDisabled ? 'В обработке' : 'Принять'),
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
  final String title;
  final int people;
  final String docId;
  final String status;

  const ApplicationModel({
    required this.date,
    required this.time,
    required this.title,
    required this.people,
    required this.docId,
    required this.status
  });
}

class CombinedData {
  final Set<String> bannedCompanies;
  final Map<String, String> appliedExcursionStatuses;
  final List<QueryDocumentSnapshot> excursions;

  CombinedData({
    required this.bannedCompanies,
    required this.appliedExcursionStatuses,
    required this.excursions,
  });
}
