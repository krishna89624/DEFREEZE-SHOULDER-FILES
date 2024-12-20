//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart.dart';
// import 'package:defreeze_shoulder/HomeScreen.dart';
// import 'package:defreeze_shoulder/LoginOptions.dart';
// import 'package:defreeze_shoulder/AdminDashboard.dart';
// import 'package:defreeze_shoulder/DoctorDashboard.dart';
// import 'package:defreeze_shoulder/DoctorProfileScreen.dart';
// import 'package:defreeze_shoulder/DoctorNotificationsScreen.dart';
// import 'package:defreeze_shoulder/header.dart';
// import 'package:defreeze_shoulder/doctor_appointments.dart';
// import 'package:defreeze_shoulder/AppointmentsScreen.dart';
// import 'package:defreeze_shoulder/AllPatientsScreen.dart';
// import 'package:defreeze_shoulder/AddPatient.dart';
// import 'package:defreeze_shoulder/AddVideos.dart';
// import 'package:defreeze_shoulder/PatientFullDetScreen.dart';
// import 'package:defreeze_shoulder/AddVideoScreen1.dart';
// import 'package:defreeze_shoulder/DailyProgressScreen1.dart';
// import 'package:defreeze_shoulder/QuestionnairesScreen.dart';
// import 'package:defreeze_shoulder/WhatsAppScreen.dart';
// import 'package:defreeze_shoulder/AppointmentScreen.dart';
// import 'package:defreeze_shoulder/PatientDashboardScreen.dart';
// import 'package:defreeze_shoulder/PendingAppointmentsWidget.dart';
// import 'package:defreeze_shoulder/DailyActivityScreen.dart';
// import 'package:defreeze_shoulder/DailyProgressScreen.dart';
// import 'package:defreeze_shoulder/QuestionnairesScreen1.dart';
// import 'package:defreeze_shoulder/PatientReportedScreen.dart';
// import 'package:defreeze_shoulder/ViewVideosScreen.dart';
// import 'package:defreeze_shoulder/AddAppointmentScreen.dart';
// import 'package:defreeze_shoulder/patientwhatsapp.dart';
// import 'package:defreeze_shoulder/AllAppointmentsScreen.dart';
// import 'package:defreeze_shoulder/AppointmentDetailsScreen.dart';
// import 'package:defreeze_shoulder/PatientProfileScreen.dart';
// import 'package:defreeze_shoulder/PatientNotificationScreen.dart';
// import 'package:defreeze_shoulder/AddDoctorScreen.dart';
// import 'package:defreeze_shoulder/AddPatientScreen.dart';
// import 'package:defreeze_shoulder/DoctorDetailScreen.dart';
// import 'package:defreeze_shoulder/ViewDoctorScreen.dart';
// import 'package:defreeze_shoulder/ViewPatientScreen.dart';
// import 'package:defreeze_shoulder/MyQuestionsScreen.dart';
// import 'package:defreeze_shoulder/PieChartScreen.dart';
// import 'package:defreeze_shoulder/ReportedScorePatient.dart';
// import 'package:defreeze_shoulder/HistoryScreen.dart';
// import 'package:defreeze_shoulder/weekly_questions_screen.dart';
// import 'package:defreeze_shoulder/MedicalHistoryScreen.dart';
// import 'package:defreeze_shoulder/DoctorAppointmentDetailScreen.dart';
// import 'package:defreeze_shoulder/Addvideosscreen.dart';
// import 'package:defreeze_shoulder/AddVideoDetailsScreen.dart';
// import 'package:defreeze_shoulder/DocSetPasswordScreen.dart';
// import 'package:defreeze_shoulder/PatSetPasswordScreen.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Defreeze Shoulder App',
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/home',
//       routes: {
//         '/home': (context) => HomeScreen(),
//         '/LoginOptions': (context) => LoginOptions(),
//         '/DocSetPasswordScreen': (context) => DocSetPasswordScreen(),
//         '/PatSetPasswordScreen': (context) => PatSetPasswordScreen(),
//
//         '/AdminDashboard': (context) => AdminDashboard(),
//         '/DoctorDashboard': (context) => DoctorDashboard(),
//         '/doctorProfile': (context) => DoctorProfileScreen(),
//         '/doctorNotifications': (context) => DoctorNotificationsScreen(),
//         '/header': (context) => Header(title: "Header Title"),
//         '/AddPatient': (context) {
//           // Retrieve the arguments as a Map
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//
//           final doctorId = args['doctorId'] as String; // Retrieve doctorId from the map
//
//           return AddPatient(doctorId: doctorId); // Pass the dynamic doctorId
//         },
//
//         '/Addvideosscreen': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           final doctorId = args['doctorId'] as String;
//           return Addvideosscreen(doctorId: doctorId);
//         },
//         '/AddVideoScreen1': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           final doctorId = args['doctorId'] as String;
//           final patientId = args['patientId'] as String;
//
//           return AddVideoScreen1(doctorId: doctorId,patientId: patientId);
//         },
//         '/AddVideoDetailsScreen': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           final doctorId = args['doctorId'] as String;
//           final patientId = args['patientId'] as String;
//
//           return AddVideoDetailsScreen(doctorId: doctorId,patientId: patientId);
//         },
//
//         '/AddVideos': (context) {
//           // Retrieve the arguments as a Map
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//
//           final doctorId = args['doctorId'] as String; // Retrieve doctorId from the map
//
//           return AddVideos (doctorId: doctorId); // Pass the dynamic doctorId
//         },        '/PatientNotificationScreen': (context) => PatientNotificationScreen(),
//
//         '/doctor_appointments': (context) {
//           final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//           if (args == null) return UndefinedRouteScreen(name: '/doctor_appointments');
//
//           final doctorId = args['doctorId'];
//           final doctorName = args['doctorName'];
//           final doctorSpecialization = args['doctorSpecialization'];
//
//           return DoctorAppointments(
//             pendingAppointments: [], // Provide actual data here
//             doctorId: doctorId,
//             doctorName: doctorName,
//             doctorSpecialization: doctorSpecialization,
//           );
//         },
//         '/AllPatientsScreen': (context) => AllPatientsScreen(),
//         '/PatientFullDetScreen': (context) =>PatientFullDetScreen(),
//         '/DailyProgressScreen1': (context) => DailyProgressScreen1(),
//         '/QuestionnairesScreen': (context) => QuestionnairesScreen(),
//         '/WhatsAppScreen': (context) => WhatsAppScreen(),
//         '/AppointmentScreen': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           return AppointmentScreen(
//             patientId: args['patientId'],
//             doctorId: args['doctorId'],
//           );
//         },
//         '/DailyActivityScreen': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
//           return DailyActivityScreen(patientId: args['patientId']!);
//         },
//         '/DailyProgressScreen': (context) {
//           // Retrieve the arguments passed during navigation
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           return DailyProgressScreen(patientId: args['patientId']);
//         },
//         '/QuestionnairesScreen1': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           return QuestionnairesScreen1(patientId: args['patientId']);
//         },
//         '/PieChartScreen': (context) => PieChartScreen(),
//         '/ReportedScorePatient': (context) => ReportedScorePatient(),
//
//         '/patientwhatsapp': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           final patientId = args['patientId'] as String; // Extract the patientId from the map
//           return PatientWhatsApp(patientId: patientId);
//         },
//         '/AddAppointmentScreen': (context) {
//           final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           final String patientId = args['patientId']; // Access patientId from the map
//           return AddAppointmentScreen(patientId: patientId);
//         },
//
//         '/weeklyQuestions': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>; // Cast as Map
//           final patientId = args['patientId']; // Access patientId
//           return WeeklyQuestionsScreen(patientId: patientId!); // Ensure patientId is not null
//         },
//         // '/AddAppointmentScreen': (context) =>AddAppointmentScreen(),  // Define Add Appointment screen
//         '/ViewVideosScreen': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           return ViewVideosScreen(patientId: args['patientId']);
//         },
//         '/PatientReportedScreen': (context) =>PatientReportedScreen(),
//         '/AddDoctorScreen': (context) =>AddDoctorScreen(),
//         '/AddPatientScreen': (context) =>AddPatientScreen(),
//         '/viewDoctorScreen': (context) =>viewDoctorScreen(),
//         '/DoctorAppointmentDetailScreen': (context) =>DoctorAppointmentDetailScreen(),
//         '/ViewPatientScreen': (context) =>ViewPatientScreen(),
//         '/MedicalHistoryScreen': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           return MedicalHistoryScreen(patientId: args['patientId']); // Use the passed patientId
//         },
//         '/MyQuestionsScreen': (context) {
//           final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
//           return MyQuestionsScreen(
//             patientId: args['patientId'],
//             name: args['name'],
//             patientCase: args['patientCase'],
//             contactNo: args['contactNo'],
//           );
//         },
//         '/AllAppointmentsScreen': (context) {
//           final patientId = ModalRoute.of(context)?.settings.arguments as String;
//           return AllAppointmentsScreen(patientId: patientId);
//
//         },
//         '/AppointmentDetailsScreen': (context) => AppointmentDetailsScreen(),
//
//         '/DoctorDetailScreen': (context) {
//           final doctor = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           return DoctorDetailScreen(doctor: doctor); // Pass the doctor object
//         },
//         '/EditDoctorScreen': (context) {
//           final doctor = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           return DoctorDetailScreen(doctor: doctor); // Pass the doctor object
//         },
//         '/history': (context) {
//           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
//           return HistoryScreen(
//             patientId: args['patientId'],
//             doctorImage: args['doctorImage'],
//             patientImage: args['patientImage'],
//           );
//         },
//         '/PatientDashboardScreen': (context) {
//           final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//           if (args == null) return UndefinedRouteScreen(name: '/PatientDashboardScreen');
//
//           return PatientDashboardScreen(
//             name: args['name'],
//             patientId: args['patientId'],
//             patientCase: args['patientCase'],
//             contactNo: args['contactNo'],
//           );
//         },
//       },
//
//
//       onGenerateRoute: (settings) {
//         if (settings.name == '/AppointmentsScreen') {
//           final args = settings.arguments as Map<String, dynamic>?;
//           if (args == null) return MaterialPageRoute(builder: (_) => UndefinedRouteScreen(name: '/AppointmentsScreen'));
//
//           final doctorId = args['doctorId'];
//           return MaterialPageRoute(
//             builder: (context) => AppointmentsScreen(doctorId: doctorId),
//           );
//         }
//
//
//         if (settings.name == '/PatientProfileScreen') {
//           final args = settings.arguments as Map<String, dynamic>;
//           return MaterialPageRoute(
//             builder: (context) {
//               return PatientProfileScreen(patientId: args['patientId']);
//             },
//           );
//         }
//         return MaterialPageRoute(
//           builder: (context) => UndefinedRouteScreen(name: settings.name),
//         );
//       },
//     );
//   }
// }
// class UndefinedRouteScreen extends StatelessWidget {
//   final String? name;
//   UndefinedRouteScreen({this.name});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('404: Page not found')),
//       body: Center(
//         child: Text('No route defined for $name'),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:defreeze_shoulder/HomeScreen.dart';
import 'package:defreeze_shoulder/LoginOptions.dart';
import 'package:defreeze_shoulder/AdminDashboard.dart';
import 'package:defreeze_shoulder/DoctorDashboard.dart';
import 'package:defreeze_shoulder/DoctorProfileScreen.dart';
import 'package:defreeze_shoulder/DoctorNotificationsScreen.dart';
import 'package:defreeze_shoulder/header.dart';
import 'package:defreeze_shoulder/doctor_appointments.dart';
import 'package:defreeze_shoulder/AppointmentsScreen.dart';
import 'package:defreeze_shoulder/AllPatientsScreen.dart';
import 'package:defreeze_shoulder/AddPatient.dart';
import 'package:defreeze_shoulder/AddVideos.dart';
import 'package:defreeze_shoulder/PatientFullDetScreen.dart';
import 'package:defreeze_shoulder/AddVideoScreen1.dart';
import 'package:defreeze_shoulder/DailyProgressScreen1.dart';
import 'package:defreeze_shoulder/QuestionnairesScreen.dart';
import 'package:defreeze_shoulder/WhatsAppScreen.dart';
import 'package:defreeze_shoulder/AppointmentScreen.dart';
import 'package:defreeze_shoulder/PatientDashboardScreen.dart';
import 'package:defreeze_shoulder/PendingAppointmentsWidget.dart';
import 'package:defreeze_shoulder/DailyActivityScreen.dart';
import 'package:defreeze_shoulder/DailyProgressScreen.dart';
import 'package:defreeze_shoulder/QuestionnairesScreen1.dart';
import 'package:defreeze_shoulder/PatientReportedScreen.dart';
import 'package:defreeze_shoulder/ViewVideosScreen.dart';
import 'package:defreeze_shoulder/AddAppointmentScreen.dart';
import 'package:defreeze_shoulder/patientwhatsapp.dart';
import 'package:defreeze_shoulder/AllAppointmentsScreen.dart';
import 'package:defreeze_shoulder/AppointmentDetailsScreen.dart';
import 'package:defreeze_shoulder/PatientProfileScreen.dart';
import 'package:defreeze_shoulder/PatientNotificationScreen.dart';
import 'package:defreeze_shoulder/AddDoctorScreen.dart';
import 'package:defreeze_shoulder/AddPatientScreen.dart';
import 'package:defreeze_shoulder/DoctorDetailScreen.dart';
import 'package:defreeze_shoulder/ViewDoctorScreen.dart';
import 'package:defreeze_shoulder/ViewPatientScreen.dart';
import 'package:defreeze_shoulder/MyQuestionsScreen.dart';
import 'package:defreeze_shoulder/PieChartScreen.dart';
import 'package:defreeze_shoulder/ReportedScorePatient.dart';
import 'package:defreeze_shoulder/HistoryScreen.dart';
import 'package:defreeze_shoulder/weekly_questions_screen.dart';
import 'package:defreeze_shoulder/MedicalHistoryScreen.dart';
import 'package:defreeze_shoulder/DoctorAppointmentDetailScreen.dart';
import 'package:defreeze_shoulder/Addvideosscreen.dart';
import 'package:defreeze_shoulder/AddVideoDetailsScreen.dart';
import 'package:defreeze_shoulder/DocSetPasswordScreen.dart';
import 'package:defreeze_shoulder/PatSetPasswordScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 855), // Base screen dimensions (adjust if needed)
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Defreeze Shoulder App',
          debugShowCheckedModeBanner: false,
          initialRoute: '/home',
          routes: {
            '/home': (context) => HomeScreen(),
            '/LoginOptions': (context) => LoginOptions(),
            '/DocSetPasswordScreen': (context) => DocSetPasswordScreen(),
            '/PatSetPasswordScreen': (context) => PatSetPasswordScreen(),
            '/AdminDashboard': (context) => AdminDashboard(),
            '/DoctorDashboard': (context) => DoctorDashboard(),
            '/doctorProfile': (context) => DoctorProfileScreen(),
            '/doctorNotifications': (context) => DoctorNotificationsScreen(),
            '/header': (context) => Header(title: "Header Title"),
            '/AddPatient': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              final doctorId = args['doctorId'] as String;
              return AddPatient(doctorId: doctorId);
            },
            '/Addvideosscreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              final doctorId = args['doctorId'] as String;
              return Addvideosscreen(doctorId: doctorId);
            },
            '/AddVideoScreen1': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              final doctorId = args['doctorId'] as String;
              final patientId = args['patientId'] as String;
              return AddVideoScreen1(doctorId: doctorId, patientId: patientId);
            },
            '/AddVideoDetailsScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              final doctorId = args['doctorId'] as String;
              final patientId = args['patientId'] as String;
              return AddVideoDetailsScreen(doctorId: doctorId, patientId: patientId);
            },
            '/AddVideos': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              final doctorId = args['doctorId'] as String;
              return AddVideos(doctorId: doctorId);
            },
            '/PatientNotificationScreen': (context) => PatientNotificationScreen(),
            '/doctor_appointments': (context) {
              final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
              if (args == null) return UndefinedRouteScreen(name: '/doctor_appointments');
              final doctorId = args['doctorId'];
              final doctorName = args['doctorName'];
              final doctorSpecialization = args['doctorSpecialization'];
              return DoctorAppointments(
                pendingAppointments: [],
                doctorId: doctorId,
                doctorName: doctorName,
                doctorSpecialization: doctorSpecialization,
              );
            },
            '/AllPatientsScreen': (context) => AllPatientsScreen(),
            '/PatientFullDetScreen': (context) => PatientFullDetScreen(),
            '/DailyProgressScreen1': (context) => DailyProgressScreen1(),
            '/QuestionnairesScreen': (context) => QuestionnairesScreen(),
            '/WhatsAppScreen': (context) => WhatsAppScreen(),
            '/AppointmentScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return AppointmentScreen(
                patientId: args['patientId'],
                doctorId: args['doctorId'],
              );
            },
            '/DailyActivityScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
              return DailyActivityScreen(patientId: args['patientId']!);
            },
            '/DailyProgressScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return DailyProgressScreen(patientId: args['patientId']);
            },
            '/QuestionnairesScreen1': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return QuestionnairesScreen1(patientId: args['patientId']);
            },
            '/PieChartScreen': (context) => PieChartScreen(),
            '/ReportedScorePatient': (context) => ReportedScorePatient(),
            '/patientwhatsapp': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              final patientId = args['patientId'] as String;
              return PatientWhatsApp(patientId: patientId);
            },
            '/AddAppointmentScreen': (context) {
              final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              final String patientId = args['patientId'];
              return AddAppointmentScreen(patientId: patientId);
            },
            '/weeklyQuestions': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
              final patientId = args['patientId'];
              return WeeklyQuestionsScreen(patientId: patientId!);
            },
            '/ViewVideosScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return ViewVideosScreen(patientId: args['patientId']);
            },
            '/PatientReportedScreen': (context) => PatientReportedScreen(),
            '/AddDoctorScreen': (context) => AddDoctorScreen(),
            '/AddPatientScreen': (context) => AddPatientScreen(),
            '/viewDoctorScreen': (context) =>viewDoctorScreen(),
            '/DoctorAppointmentDetailScreen': (context) => DoctorAppointmentDetailScreen(),
            '/ViewPatientScreen': (context) => ViewPatientScreen(),
            '/MedicalHistoryScreen': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
              return MedicalHistoryScreen(patientId: args['patientId']);
            },
            '/MyQuestionsScreen': (context) {
              final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
              return MyQuestionsScreen(
                patientId: args['patientId'],
                name: args['name'],
                patientCase: args['patientCase'],
                contactNo: args['contactNo'],
              );
            },
            '/AllAppointmentsScreen': (context) {
              final patientId = ModalRoute.of(context)?.settings.arguments as String?;
              return AllAppointmentsScreen(patientId: patientId!);
            },
            '/AppointmentDetailsScreen': (context) => AppointmentDetailsScreen(),
    '/DoctorDetailScreen': (context) {
          final doctor = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
           return DoctorDetailScreen(doctor: doctor); // Pass the doctor object
       },
    '/EditDoctorScreen': (context) {
           final doctor = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
           return DoctorDetailScreen(doctor: doctor); // Pass the doctor object
         },
         '/history': (context) {
           final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
           return HistoryScreen(
            patientId: args['patientId'],
             doctorImage: args['doctorImage'],
             patientImage: args['patientImage'],
           );
         },
         '/PatientDashboardScreen': (context) {
           final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
           if (args == null) return UndefinedRouteScreen(name: '/PatientDashboardScreen');

           return PatientDashboardScreen(
             name: args['name'],
             patientId: args['patientId'],
             patientCase: args['patientCase'],
             contactNo: args['contactNo'],
           );
         },
       },


       onGenerateRoute: (settings) {
         if (settings.name == '/AppointmentsScreen') {
           final args = settings.arguments as Map<String, dynamic>?;
           if (args == null) return MaterialPageRoute(builder: (_) => UndefinedRouteScreen(name: '/AppointmentsScreen'));

           final doctorId = args['doctorId'];
           return MaterialPageRoute(
             builder: (context) => AppointmentsScreen(doctorId: doctorId),
           );
         }


         if (settings.name == '/PatientProfileScreen') {
           final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
             builder: (context) {
              return PatientProfileScreen(patientId: args['patientId']);
             },
           );
        }
          },
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (_) => UndefinedRouteScreen(name: settings.name),
          ),
        );
      },
    );
  }
}

class UndefinedRouteScreen extends StatelessWidget {
  final String? name;

  const UndefinedRouteScreen({Key? key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404 - Page not found')),
      body: Center(child: Text('No route defined for $name')),
    );
  }
}
