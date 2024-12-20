//
// const ip = "14.139.187.229:8081";
// const baseUrl = `http://${ip}/orthocare_surgery`;

class Config {
  // Replace with the actual IP for production
  //static const String ip = "192.168.39.82";
  /// static const String baseUrl = 'http://$ip/orthocare_surgery'; // Base URL for API
   static const String ip = "180.235.121.245";
  static const String baseUrl = 'http://$ip/defreezeshoulder'; // Base URL for API

  // URLs for login
  static const String adminLoginUrl = '$baseUrl/adminlogin.php';
  static const String doctorLoginUrl = '$baseUrl/doctorlogin.php';
  static const String patientLoginUrl = '$baseUrl/patientlogin.php';
  static const String viewpatientlistUrl = '$baseUrl/viewpatientlist.php';

  // URL for appointment status endpoint
  static const String appointmentstatusUrl = '$baseUrl/appointmentstatus.php';

  // URL for notifications
  static const String getNotificationsUrl = '$baseUrl/get_notifications.php';

  // URL to get doctor list
  // static String getDoctorPatientsUrl(String doctorId) {
  //   return '$baseUrl/doctorlist.php?doctorId=$doctorId';
  // }
  static String getDoctorPatientsUrl(String doctorId) {
    return '$baseUrl/doctorlist.php?doctorId=$doctorId';
  }
  // Method to get the URL to check completion for a specific patient
  static String checkCompletionUrl(String patientId) {
    return '$baseUrl/check_completion.php?patientId=$patientId';
  }

  // Method to get appointments for a doctor based on status
  static String getAppointmentsUrl(String doctorId, String status) {
    return '$baseUrl/appointment.php?status=$status&doctorId=$doctorId';
  }
  // URL for fetching patient profile
  static String getPatientProfileUrl(String patientId) {
    return '$baseUrl/profile.php?patientId=$patientId'; // URL to get patient details
  }

  // URL for fetching patient image
  static String getPatientImageUrl(String patientId) {
    return '$baseUrl/imagepatient.php?patientId=$patientId'; // URL to get patient image
  }

  // URL to fetch pop-up message
  static String getPopMessageUrl(String patientId) {
    return '$baseUrl/popmessage.php?patientId=$patientId'; // URL for submission status message
  }
  static String getPatientAppointmentsUrl(String doctorId, String status) {
    return '$baseUrl/appointment.php?status=$status&doctorId=$doctorId';
  }
  static String PatientcheckCompletionUrl(String patientId) {
    return '$baseUrl/check_completion.php?patientId=$patientId';
  }

  static const String getPatientNotificationsUrl = '$baseUrl/get_notifications_patient.php';
  static const String addDoctorUrl = '$baseUrl/doctorprofile.php'; // Example API endpoint
  static const String  addpatientUrl= '$baseUrl/patientprofile2.php'; // Example API endpoint
  static const String addadnindocUrl = '$baseUrl/admindoctorlist.php'; // URL for fetching doctors
  static String get viewDoctorListUrl => '$baseUrl/viewdoctorlist.php'; // Adjust the endpoint accordingly
  static const String updateDoctorUrl = '$baseUrl/doctoredit.php';
  static const String updatePatientUrl = '$baseUrl/updateprofile.php'; // Update with your actual endpoint
  static const String updatePatientEndpoint = '$baseUrl/updateprofile.php'; // Endpoint for updating patient profile
  static const String getQuestionsUrl = '$baseUrl/qns.php';
  static const String submitAnswersUrl = '$baseUrl/submit_ans.php';
  static String get submitActivityUrl => '$baseUrl/submit_task.php'; // Adjust endpoint if needed
  static const String patientPieChart = '$baseUrl/patientpiechart.php';
  static const String weeklyQuestions = '$baseUrl/weaklyquestions.php';
  static const String dashScores = '$baseUrl/dash_scores.php';
  static const String insertPatientScore = '$baseUrl/insert_patient_score.php';

  static String get selectAppointment => '$baseUrl/selectappointment.php';
  static String get createAppointment => '$baseUrl/patientappointment.php'; // Example for the appointment creation endpoint

  static String getNotificationsUrl1(String doctorId) {
    return '$baseUrl/get_notifications.php?doctorId=$doctorId';
  }
  static String get selectAppointmentUrl => '$baseUrl/selectappointment.php';
  static String get doctorAppointmentUrl => '$baseUrl/doctorappointment.php';

  static String getDoctorHistoryUrl(String status, String patientId) {
    return '$baseUrl/doctorhistoryscreen.php?status=$status&patientId=$patientId'; // Adjust as needed
  }
  static const String patentdataUrl = '$baseUrl/patientscore.php'; // Assuming the endpoint

  static const String addpatient1Url = '$baseUrl/patientprofile2.php'; // replace with your actual URL
  static const String addvideosdoctorUrl = '$baseUrl/doctorvideo.php'; // Replace with your actual URL
  static const String patientPasswordUrl = '$baseUrl/patientsetpassword.php'; // Replace with your API URL
  static const String patSetPasswordScreenUrl = '$baseUrl/UPDATEPASSWORDPATIENT.php';
  static const String doctorPasswordVerificationUrl = "$baseUrl/phonenuberdoc.php";
  static const String doctorPasswordUpdateUrl = "$baseUrl/setpassword.php";// Replace with your API URL

}
