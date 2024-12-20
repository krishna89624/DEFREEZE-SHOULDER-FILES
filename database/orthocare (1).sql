-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 11, 2024 at 09:48 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `orthocare`
--

-- --------------------------------------------------------

--
-- Table structure for table `adddoctorvideos`
--

CREATE TABLE `adddoctorvideos` (
  `id` int(11) NOT NULL,
  `video_name` varchar(255) NOT NULL,
  `video_path` varchar(255) NOT NULL,
  `introduction` text NOT NULL,
  `custom_file_name` varchar(255) NOT NULL,
  `doctorId` varchar(11) NOT NULL,
  `upload_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `adddoctorvideos`
--

INSERT INTO `adddoctorvideos` (`id`, `video_name`, `video_path`, `introduction`, `custom_file_name`, `doctorId`, `upload_date`) VALUES
(1, 'Finger fist_4272235a-c2e9-4361-85fb-bc020780fff6.mp4', 'uploads/Finger fist_4272235a-c2e9-4361-85fb-bc020780fff6.mp4', 'Finger fist', 'Finger fist', 'D1', '2024-08-28 12:16:28'),
(2, 'Biceps curl_4d3e3404-b3fb-4425-88cc-46c1d9b119ee.mp4', 'uploads/Biceps curl_4d3e3404-b3fb-4425-88cc-46c1d9b119ee.mp4', 'Biceps curl', 'Biceps curl', 'D1', '2024-09-11 01:06:46'),
(3, 'Rotator_371443e7-efbb-48cc-a23b-aec65638fab4.mp4', 'uploads/Rotator_371443e7-efbb-48cc-a23b-aec65638fab4.mp4', 'Rotator', 'Rotator', 'D1', '2024-09-16 09:02:24'),
(4, 'Shoulder _450cd544-1645-404c-adac-ac3ee09bf770.mp4', 'uploads/Shoulder _450cd544-1645-404c-adac-ac3ee09bf770.mp4', 'Shoulder ', 'Shoulder ', 'D1', '2024-09-17 16:03:25'),
(9, 'shoulder _1000111662.mp4', 'uploads/shoulder _1000111662.mp4', 'shoulder ', 'shoulder ', 'd1', '2024-11-02 08:52:59'),
(10, 'ii_ii', 'uploads/ii_ii', 'kk', 'ii', 'd1', '2024-11-02 08:58:13'),
(11, 'anti clockwise prndular_anti clockwise prndular', 'uploads/anti clockwise prndular_anti clockwise prndular', 'anti clockwise prndular', 'anti clockwise prndular', 'd1', '2024-11-02 08:59:42'),
(12, '_1000111630.mp4', 'uploads/_1000111630.mp4', '', '', 'd1', '2024-11-02 09:04:48'),
(13, 'ju_1000111624.mp4', 'uploads/ju_1000111624.mp4', 'hh', 'ju', 'd1', '2024-11-02 09:05:13'),
(14, 'nj_1000111652.mp4', 'uploads/nj_1000111652.mp4', 'jh', 'nj', 'd1', '2024-11-02 09:10:10'),
(15, 'njhh_1000111641.mp4', 'uploads/njhh_1000111641.mp4', 'jhll', 'njhh', 'd1', '2024-11-02 09:11:36'),
(16, 'tt_1000111644.mp4', 'uploads/tt_1000111644.mp4', 'yt', 'tt', 'd1', '2024-11-02 09:20:21'),
(17, 'tt_1000111644.mp4', 'uploads/tt_1000111644.mp4', 'yt', 'tt', 'd1', '2024-11-02 09:22:58'),
(18, 'rr_1000000754.mp4', 'uploads/rr_1000000754.mp4', 'de', 'rr', 'D1', '2024-11-06 05:23:25'),
(19, 'rr_1000000754.mp4', 'uploads/rr_1000000754.mp4', 'de', 'rr', 'D1', '2024-11-06 05:23:30');

-- --------------------------------------------------------

--
-- Table structure for table `adminlogin`
--

CREATE TABLE `adminlogin` (
  `id` int(11) NOT NULL,
  `adminId` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `adminlogin`
--

INSERT INTO `adminlogin` (`id`, `adminId`, `password`) VALUES
(1, 'admin', '123');

-- --------------------------------------------------------

--
-- Table structure for table `daily_task`
--

CREATE TABLE `daily_task` (
  `id` int(11) NOT NULL,
  `patientId` varchar(50) NOT NULL,
  `flexion` varchar(50) NOT NULL,
  `extension` varchar(50) NOT NULL,
  `adduction` varchar(50) NOT NULL,
  `abduction` varchar(50) NOT NULL,
  `pain_scale` varchar(50) NOT NULL,
  `doing_exercises` varchar(50) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `daily_task`
--

INSERT INTO `daily_task` (`id`, `patientId`, `flexion`, `extension`, `adduction`, `abduction`, `pain_scale`, `doing_exercises`, `date`, `time`) VALUES
(1, 'P1', '35', '58', '85', '88', '5', 'Yes', '2024-08-28', '14:20:19'),
(2, 'P1', '66', '66', '99', '99', '5', 'Yes', '2024-09-11', '03:07:43'),
(3, 'P1', '63', '56', '55', '55', '5', 'Yes', '2024-09-17', '18:07:17'),
(6, 'p1', '20', '00', '00', '00', '88', 'Yes', '2024-10-29', '13:05:51');

-- --------------------------------------------------------

--
-- Table structure for table `dash_score`
--

CREATE TABLE `dash_score` (
  `id` int(11) NOT NULL,
  `patientId` varchar(50) NOT NULL,
  `questions` varchar(255) NOT NULL,
  `options` varchar(50) NOT NULL,
  `score` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dash_score`
--

INSERT INTO `dash_score` (`id`, `patientId`, `questions`, `options`, `score`, `created_at`) VALUES
(1, 'p1', 'Open a tight or new jar', 'No difficulty', 1, '2024-11-01 15:18:14'),
(2, 'p1', 'Write', 'No difficulty', 1, '2024-11-01 15:18:14'),
(3, 'p1', 'Turn a key', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(4, 'p1', 'Prepare a meal', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(5, 'p1', 'Push open a heavy door', 'Severe difficulty', 4, '2024-11-01 15:18:14'),
(6, 'p1', 'Place an object on a shelf above your head', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(7, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(8, 'p1', 'Garden or do yard work', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(9, 'p1', 'Make a bed', 'Severe difficulty', 4, '2024-11-01 15:18:14'),
(10, 'p1', 'Carry a shopping bag or briefcase', 'Severe difficulty', 4, '2024-11-01 15:18:14'),
(11, 'p1', 'Carry a heavy object (over 10 lbs)', 'Severe difficulty', 4, '2024-11-01 15:18:14'),
(12, 'p1', 'Change a lightbulb overhead', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(13, 'p1', 'Wash or blow dry your hair', 'Unable', 5, '2024-11-01 15:18:14'),
(14, 'p1', 'Wash your back', 'Severe difficulty', 4, '2024-11-01 15:18:14'),
(15, 'p1', 'Put on a pullover sweater', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(16, 'p1', 'Use a knife to cut food', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(17, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(18, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(19, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Severe difficulty', 4, '2024-11-01 15:18:14'),
(20, 'p1', 'Manage transportation needs (getting from one place to another)', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(21, 'p1', 'Sexual activities', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(22, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Quite a bit', 4, '2024-11-01 15:18:14'),
(23, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Very limited', 4, '2024-11-01 15:18:14'),
(24, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-01 15:18:14'),
(25, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Extreme', 5, '2024-11-01 15:18:14'),
(26, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Moderate', 3, '2024-11-01 15:18:14'),
(27, 'p1', 'Weakness in your arm, shoulder or hand', 'Moderate', 3, '2024-11-01 15:18:14'),
(28, 'p1', 'Stiffness in your arm, shoulder or hand', 'Moderate', 3, '2024-11-01 15:18:14'),
(29, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Moderate difficulty', 3, '2024-11-01 15:18:14'),
(30, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Neither agree nor disagree', 3, '2024-11-01 15:18:14'),
(31, 'p1', 'Open a tight or new jar', 'No difficulty', 1, '2024-11-05 09:57:34'),
(32, 'p1', 'Write', 'No difficulty', 1, '2024-11-05 09:57:34'),
(33, 'p1', 'Turn a key', 'Mild difficulty', 2, '2024-11-05 09:57:34'),
(34, 'p1', 'Prepare a meal', 'Mild difficulty', 2, '2024-11-05 09:57:34'),
(35, 'p1', 'Push open a heavy door', 'Mild difficulty', 2, '2024-11-05 09:57:34'),
(36, 'p1', 'Place an object on a shelf above your head', 'Moderate difficulty', 3, '2024-11-05 09:57:34'),
(37, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Moderate difficulty', 3, '2024-11-05 09:57:34'),
(38, 'p1', 'Garden or do yard work', 'Mild difficulty', 2, '2024-11-05 09:57:34'),
(39, 'p1', 'Make a bed', 'Moderate difficulty', 3, '2024-11-05 09:57:34'),
(40, 'p1', 'Carry a shopping bag or briefcase', 'Severe difficulty', 4, '2024-11-05 09:57:34'),
(41, 'p1', 'Carry a heavy object (over 10 lbs)', 'Moderate difficulty', 3, '2024-11-05 09:57:34'),
(42, 'p1', 'Change a lightbulb overhead', 'No difficulty', 1, '2024-11-05 09:57:34'),
(43, 'p1', 'Wash or blow dry your hair', 'Severe difficulty', 4, '2024-11-05 09:57:34'),
(44, 'p1', 'Wash your back', 'Unable', 5, '2024-11-05 09:57:34'),
(45, 'p1', 'Put on a pullover sweater', 'Severe difficulty', 4, '2024-11-05 09:57:34'),
(46, 'p1', 'Use a knife to cut food', 'Severe difficulty', 4, '2024-11-05 09:57:34'),
(47, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Severe difficulty', 4, '2024-11-05 09:57:34'),
(48, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Mild difficulty', 2, '2024-11-05 09:57:34'),
(49, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Unable', 5, '2024-11-05 09:57:34'),
(50, 'p1', 'Manage transportation needs (getting from one place to another)', 'Moderate difficulty', 3, '2024-11-05 09:57:34'),
(51, 'p1', 'Sexual activities', 'Moderate difficulty', 3, '2024-11-05 09:57:34'),
(52, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Not at all', 1, '2024-11-05 09:57:34'),
(53, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Moderately limited', 3, '2024-11-05 09:57:34'),
(54, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-05 09:57:34'),
(55, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Extreme', 5, '2024-11-05 09:57:34'),
(56, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Severe', 4, '2024-11-05 09:57:34'),
(57, 'p1', 'Weakness in your arm, shoulder or hand', 'Severe', 4, '2024-11-05 09:57:34'),
(58, 'p1', 'Stiffness in your arm, shoulder or hand', 'Moderate', 3, '2024-11-05 09:57:34'),
(59, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Moderate difficulty', 3, '2024-11-05 09:57:34'),
(60, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Neither agree nor disagree', 3, '2024-11-05 09:57:34'),
(61, 'p1', 'Open a tight or new jar', 'No difficulty', 1, '2024-11-05 10:07:30'),
(62, 'p1', 'Write', 'Mild difficulty', 2, '2024-11-05 10:07:30'),
(63, 'p1', 'Turn a key', 'Unable', 5, '2024-11-05 10:07:30'),
(64, 'p1', 'Prepare a meal', 'Severe difficulty', 4, '2024-11-05 10:07:30'),
(65, 'p1', 'Push open a heavy door', 'Severe difficulty', 4, '2024-11-05 10:07:30'),
(66, 'p1', 'Place an object on a shelf above your head', 'Severe difficulty', 4, '2024-11-05 10:07:30'),
(67, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Severe difficulty', 4, '2024-11-05 10:07:30'),
(68, 'p1', 'Garden or do yard work', 'Unable', 5, '2024-11-05 10:07:30'),
(69, 'p1', 'Make a bed', 'Unable', 5, '2024-11-05 10:07:30'),
(70, 'p1', 'Carry a shopping bag or briefcase', 'Severe difficulty', 4, '2024-11-05 10:07:30'),
(71, 'p1', 'Carry a heavy object (over 10 lbs)', 'Severe difficulty', 4, '2024-11-05 10:07:30'),
(72, 'p1', 'Change a lightbulb overhead', 'Moderate difficulty', 3, '2024-11-05 10:07:30'),
(73, 'p1', 'Wash or blow dry your hair', 'Unable', 5, '2024-11-05 10:07:30'),
(74, 'p1', 'Wash your back', 'Unable', 5, '2024-11-05 10:07:30'),
(75, 'p1', 'Put on a pullover sweater', 'Severe difficulty', 4, '2024-11-05 10:07:30'),
(76, 'p1', 'Use a knife to cut food', 'Severe difficulty', 4, '2024-11-05 10:07:30'),
(77, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Moderate difficulty', 3, '2024-11-05 10:07:30'),
(78, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Moderate difficulty', 3, '2024-11-05 10:07:30'),
(79, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Unable', 5, '2024-11-05 10:07:30'),
(80, 'p1', 'Manage transportation needs (getting from one place to another)', 'Severe difficulty', 4, '2024-11-05 10:07:30'),
(81, 'p1', 'Sexual activities', 'Moderate difficulty', 3, '2024-11-05 10:07:30'),
(82, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Moderately', 3, '2024-11-05 10:07:30'),
(83, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Moderately limited', 3, '2024-11-05 10:07:30'),
(84, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-05 10:07:30'),
(85, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Severe', 4, '2024-11-05 10:07:30'),
(86, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Extreme', 5, '2024-11-05 10:07:30'),
(87, 'p1', 'Weakness in your arm, shoulder or hand', 'Extreme', 5, '2024-11-05 10:07:30'),
(88, 'p1', 'Stiffness in your arm, shoulder or hand', 'Severe', 4, '2024-11-05 10:07:30'),
(89, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Moderate difficulty', 3, '2024-11-05 10:07:30'),
(90, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Disagree', 2, '2024-11-05 10:07:30'),
(91, 'p1', 'Open a tight or new jar', 'No difficulty', 1, '2024-11-05 10:09:23'),
(92, 'p1', 'Write', 'Mild difficulty', 2, '2024-11-05 10:09:23'),
(93, 'p1', 'Turn a key', 'Unable', 5, '2024-11-05 10:09:23'),
(94, 'p1', 'Prepare a meal', 'Severe difficulty', 4, '2024-11-05 10:09:23'),
(95, 'p1', 'Push open a heavy door', 'Severe difficulty', 4, '2024-11-05 10:09:23'),
(96, 'p1', 'Place an object on a shelf above your head', 'Severe difficulty', 4, '2024-11-05 10:09:23'),
(97, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Severe difficulty', 4, '2024-11-05 10:09:23'),
(98, 'p1', 'Garden or do yard work', 'Unable', 5, '2024-11-05 10:09:23'),
(99, 'p1', 'Make a bed', 'Unable', 5, '2024-11-05 10:09:23'),
(100, 'p1', 'Carry a shopping bag or briefcase', 'Severe difficulty', 4, '2024-11-05 10:09:23'),
(101, 'p1', 'Carry a heavy object (over 10 lbs)', 'Severe difficulty', 4, '2024-11-05 10:09:23'),
(102, 'p1', 'Change a lightbulb overhead', 'Moderate difficulty', 3, '2024-11-05 10:09:23'),
(103, 'p1', 'Wash or blow dry your hair', 'Unable', 5, '2024-11-05 10:09:23'),
(104, 'p1', 'Wash your back', 'Unable', 5, '2024-11-05 10:09:23'),
(105, 'p1', 'Put on a pullover sweater', 'Severe difficulty', 4, '2024-11-05 10:09:23'),
(106, 'p1', 'Use a knife to cut food', 'Severe difficulty', 4, '2024-11-05 10:09:23'),
(107, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Moderate difficulty', 3, '2024-11-05 10:09:23'),
(108, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Moderate difficulty', 3, '2024-11-05 10:09:23'),
(109, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Unable', 5, '2024-11-05 10:09:23'),
(110, 'p1', 'Manage transportation needs (getting from one place to another)', 'Severe difficulty', 4, '2024-11-05 10:09:23'),
(111, 'p1', 'Sexual activities', 'Moderate difficulty', 3, '2024-11-05 10:09:23'),
(112, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Moderately', 3, '2024-11-05 10:09:23'),
(113, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Moderately limited', 3, '2024-11-05 10:09:23'),
(114, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-05 10:09:23'),
(115, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Severe', 4, '2024-11-05 10:09:23'),
(116, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Extreme', 5, '2024-11-05 10:09:23'),
(117, 'p1', 'Weakness in your arm, shoulder or hand', 'Extreme', 5, '2024-11-05 10:09:23'),
(118, 'p1', 'Stiffness in your arm, shoulder or hand', 'Severe', 4, '2024-11-05 10:09:23'),
(119, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Moderate difficulty', 3, '2024-11-05 10:09:23'),
(120, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Disagree', 2, '2024-11-05 10:09:23'),
(121, 'p1', 'Open a tight or new jar', 'No difficulty', 1, '2024-11-05 10:10:25'),
(122, 'p1', 'Write', 'Mild difficulty', 2, '2024-11-05 10:10:25'),
(123, 'p1', 'Place an object on a shelf above your head', 'Unable', 5, '2024-11-05 10:10:25'),
(124, 'p1', 'Push open a heavy door', 'Moderate difficulty', 3, '2024-11-05 10:10:25'),
(125, 'p1', 'Prepare a meal', 'Severe difficulty', 4, '2024-11-05 10:10:25'),
(126, 'p1', 'Turn a key', 'Severe difficulty', 4, '2024-11-05 10:10:25'),
(127, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Unable', 5, '2024-11-05 10:10:25'),
(128, 'p1', 'Garden or do yard work', 'Moderate difficulty', 3, '2024-11-05 10:10:25'),
(129, 'p1', 'Make a bed', 'Moderate difficulty', 3, '2024-11-05 10:10:25'),
(130, 'p1', 'Carry a shopping bag or briefcase', 'Severe difficulty', 4, '2024-11-05 10:10:25'),
(131, 'p1', 'Carry a heavy object (over 10 lbs)', 'Moderate difficulty', 3, '2024-11-05 10:10:25'),
(132, 'p1', 'Change a lightbulb overhead', 'Moderate difficulty', 3, '2024-11-05 10:10:25'),
(133, 'p1', 'Wash or blow dry your hair', 'Unable', 5, '2024-11-05 10:10:25'),
(134, 'p1', 'Wash your back', 'Unable', 5, '2024-11-05 10:10:25'),
(135, 'p1', 'Put on a pullover sweater', 'Severe difficulty', 4, '2024-11-05 10:10:25'),
(136, 'p1', 'Use a knife to cut food', 'Severe difficulty', 4, '2024-11-05 10:10:25'),
(137, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Unable', 5, '2024-11-05 10:10:25'),
(138, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Severe difficulty', 4, '2024-11-05 10:10:25'),
(139, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Unable', 5, '2024-11-05 10:10:25'),
(140, 'p1', 'Manage transportation needs (getting from one place to another)', 'Severe difficulty', 4, '2024-11-05 10:10:25'),
(141, 'p1', 'Sexual activities', 'Unable', 5, '2024-11-05 10:10:25'),
(142, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Moderately', 3, '2024-11-05 10:10:25'),
(143, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Slightly limited', 2, '2024-11-05 10:10:25'),
(144, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-05 10:10:25'),
(145, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Extreme', 5, '2024-11-05 10:10:25'),
(146, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Severe', 4, '2024-11-05 10:10:25'),
(147, 'p1', 'Weakness in your arm, shoulder or hand', 'Severe', 4, '2024-11-05 10:10:25'),
(148, 'p1', 'Stiffness in your arm, shoulder or hand', 'Severe', 4, '2024-11-05 10:10:25'),
(149, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Severe difficulty', 4, '2024-11-05 10:10:25'),
(150, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Neither agree nor disagree', 3, '2024-11-05 10:10:25'),
(151, 'p1', 'Open a tight or new jar', 'Mild difficulty', 2, '2024-11-08 13:47:27'),
(152, 'p1', 'Write', 'Mild difficulty', 2, '2024-11-08 13:47:27'),
(153, 'p1', 'Place an object on a shelf above your head', 'Severe difficulty', 4, '2024-11-08 13:47:27'),
(154, 'p1', 'Push open a heavy door', 'Severe difficulty', 4, '2024-11-08 13:47:27'),
(155, 'p1', 'Prepare a meal', 'Severe difficulty', 4, '2024-11-08 13:47:27'),
(156, 'p1', 'Turn a key', 'Moderate difficulty', 3, '2024-11-08 13:47:27'),
(157, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Mild difficulty', 2, '2024-11-08 13:47:27'),
(158, 'p1', 'Garden or do yard work', 'Mild difficulty', 2, '2024-11-08 13:47:27'),
(159, 'p1', 'Make a bed', 'Moderate difficulty', 3, '2024-11-08 13:47:27'),
(160, 'p1', 'Carry a shopping bag or briefcase', 'Moderate difficulty', 3, '2024-11-08 13:47:27'),
(161, 'p1', 'Carry a heavy object (over 10 lbs)', 'Moderate difficulty', 3, '2024-11-08 13:47:27'),
(162, 'p1', 'Change a lightbulb overhead', 'Moderate difficulty', 3, '2024-11-08 13:47:27'),
(163, 'p1', 'Wash or blow dry your hair', 'Unable', 5, '2024-11-08 13:47:27'),
(164, 'p1', 'Wash your back', 'Severe difficulty', 4, '2024-11-08 13:47:27'),
(165, 'p1', 'Put on a pullover sweater', 'Severe difficulty', 4, '2024-11-08 13:47:27'),
(166, 'p1', 'Use a knife to cut food', 'Severe difficulty', 4, '2024-11-08 13:47:27'),
(167, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Severe difficulty', 4, '2024-11-08 13:47:27'),
(168, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Severe difficulty', 4, '2024-11-08 13:47:27'),
(169, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Severe difficulty', 4, '2024-11-08 13:47:27'),
(170, 'p1', 'Manage transportation needs (getting from one place to another)', 'Mild difficulty', 2, '2024-11-08 13:47:27'),
(171, 'p1', 'Sexual activities', 'Moderate difficulty', 3, '2024-11-08 13:47:27'),
(172, 'p1', 'Arm, shoulder or hand pain', 'Severe', 4, '2024-11-08 13:47:27'),
(173, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Moderately limited', 3, '2024-11-08 13:47:27'),
(174, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Quite a bit', 4, '2024-11-08 13:47:27'),
(175, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Severe', 4, '2024-11-08 13:47:27'),
(176, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 13:47:27'),
(177, 'p1', 'Weakness in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 13:47:27'),
(178, 'p1', 'Stiffness in your arm, shoulder or hand', 'Extreme', 5, '2024-11-08 13:47:27'),
(179, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'So much I can\'t sleep', 5, '2024-11-08 13:47:27'),
(180, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Strongly agree', 5, '2024-11-08 13:47:27'),
(181, 'p1', 'Write', 'Mild difficulty', 2, '2024-11-08 13:49:13'),
(182, 'p1', 'Open a tight or new jar', 'Moderate difficulty', 3, '2024-11-08 13:49:13'),
(183, 'p1', 'Turn a key', 'Moderate difficulty', 3, '2024-11-08 13:49:13'),
(184, 'p1', 'Prepare a meal', 'Severe difficulty', 4, '2024-11-08 13:49:13'),
(185, 'p1', 'Push open a heavy door', 'Moderate difficulty', 3, '2024-11-08 13:49:13'),
(186, 'p1', 'Place an object on a shelf above your head', 'Moderate difficulty', 3, '2024-11-08 13:49:13'),
(187, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Unable', 5, '2024-11-08 13:49:13'),
(188, 'p1', 'Garden or do yard work', 'Moderate difficulty', 3, '2024-11-08 13:49:13'),
(189, 'p1', 'Make a bed', 'Severe difficulty', 4, '2024-11-08 13:49:13'),
(190, 'p1', 'Carry a shopping bag or briefcase', 'Severe difficulty', 4, '2024-11-08 13:49:13'),
(191, 'p1', 'Carry a heavy object (over 10 lbs)', 'Severe difficulty', 4, '2024-11-08 13:49:13'),
(192, 'p1', 'Change a lightbulb overhead', 'Mild difficulty', 2, '2024-11-08 13:49:13'),
(193, 'p1', 'Wash or blow dry your hair', 'Severe difficulty', 4, '2024-11-08 13:49:13'),
(194, 'p1', 'Wash your back', 'Moderate difficulty', 3, '2024-11-08 13:49:13'),
(195, 'p1', 'Put on a pullover sweater', 'Moderate difficulty', 3, '2024-11-08 13:49:13'),
(196, 'p1', 'Use a knife to cut food', 'Severe difficulty', 4, '2024-11-08 13:49:13'),
(197, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Moderate difficulty', 3, '2024-11-08 13:49:13'),
(198, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Mild difficulty', 2, '2024-11-08 13:49:13'),
(199, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Severe difficulty', 4, '2024-11-08 13:49:13'),
(200, 'p1', 'Manage transportation needs (getting from one place to another)', 'Moderate difficulty', 3, '2024-11-08 13:49:13'),
(201, 'p1', 'Sexual activities', 'Severe difficulty', 4, '2024-11-08 13:49:13'),
(202, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Moderately', 3, '2024-11-08 13:49:13'),
(203, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Moderately limited', 3, '2024-11-08 13:49:13'),
(204, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-08 13:49:13'),
(205, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Extreme', 5, '2024-11-08 13:49:13'),
(206, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 13:49:13'),
(207, 'p1', 'Weakness in your arm, shoulder or hand', 'Moderate', 3, '2024-11-08 13:49:13'),
(208, 'p1', 'Stiffness in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 13:49:13'),
(209, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Severe difficulty', 4, '2024-11-08 13:49:13'),
(210, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Neither agree nor disagree', 3, '2024-11-08 13:49:13'),
(211, 'p1', 'Write', 'Mild difficulty', 2, '2024-11-08 13:55:32'),
(212, 'p1', 'Open a tight or new jar', 'Moderate difficulty', 3, '2024-11-08 13:55:32'),
(213, 'p1', 'Turn a key', 'Moderate difficulty', 3, '2024-11-08 13:55:32'),
(214, 'p1', 'Prepare a meal', 'Severe difficulty', 4, '2024-11-08 13:55:32'),
(215, 'p1', 'Push open a heavy door', 'Moderate difficulty', 3, '2024-11-08 13:55:32'),
(216, 'p1', 'Place an object on a shelf above your head', 'Moderate difficulty', 3, '2024-11-08 13:55:32'),
(217, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Unable', 5, '2024-11-08 13:55:32'),
(218, 'p1', 'Garden or do yard work', 'Moderate difficulty', 3, '2024-11-08 13:55:32'),
(219, 'p1', 'Make a bed', 'Severe difficulty', 4, '2024-11-08 13:55:32'),
(220, 'p1', 'Carry a shopping bag or briefcase', 'Severe difficulty', 4, '2024-11-08 13:55:32'),
(221, 'p1', 'Carry a heavy object (over 10 lbs)', 'Severe difficulty', 4, '2024-11-08 13:55:32'),
(222, 'p1', 'Change a lightbulb overhead', 'Mild difficulty', 2, '2024-11-08 13:55:32'),
(223, 'p1', 'Wash or blow dry your hair', 'Severe difficulty', 4, '2024-11-08 13:55:32'),
(224, 'p1', 'Wash your back', 'Moderate difficulty', 3, '2024-11-08 13:55:32'),
(225, 'p1', 'Put on a pullover sweater', 'Moderate difficulty', 3, '2024-11-08 13:55:32'),
(226, 'p1', 'Use a knife to cut food', 'Severe difficulty', 4, '2024-11-08 13:55:32'),
(227, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Moderate difficulty', 3, '2024-11-08 13:55:32'),
(228, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Mild difficulty', 2, '2024-11-08 13:55:32'),
(229, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Severe difficulty', 4, '2024-11-08 13:55:32'),
(230, 'p1', 'Manage transportation needs (getting from one place to another)', 'Moderate difficulty', 3, '2024-11-08 13:55:32'),
(231, 'p1', 'Sexual activities', 'Severe difficulty', 4, '2024-11-08 13:55:32'),
(232, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Moderately', 3, '2024-11-08 13:55:32'),
(233, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Moderately limited', 3, '2024-11-08 13:55:32'),
(234, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-08 13:55:32'),
(235, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Extreme', 5, '2024-11-08 13:55:32'),
(236, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 13:55:32'),
(237, 'p1', 'Weakness in your arm, shoulder or hand', 'Moderate', 3, '2024-11-08 13:55:32'),
(238, 'p1', 'Stiffness in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 13:55:32'),
(239, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Severe difficulty', 4, '2024-11-08 13:55:32'),
(240, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Neither agree nor disagree', 3, '2024-11-08 13:55:32'),
(241, 'p1', 'Write', 'Mild difficulty', 2, '2024-11-08 14:01:06'),
(242, 'p1', 'Open a tight or new jar', 'Moderate difficulty', 3, '2024-11-08 14:01:06'),
(243, 'p1', 'Turn a key', 'Moderate difficulty', 3, '2024-11-08 14:01:06'),
(244, 'p1', 'Prepare a meal', 'Severe difficulty', 4, '2024-11-08 14:01:06'),
(245, 'p1', 'Push open a heavy door', 'Moderate difficulty', 3, '2024-11-08 14:01:06'),
(246, 'p1', 'Place an object on a shelf above your head', 'Moderate difficulty', 3, '2024-11-08 14:01:06'),
(247, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Unable', 5, '2024-11-08 14:01:06'),
(248, 'p1', 'Garden or do yard work', 'Moderate difficulty', 3, '2024-11-08 14:01:06'),
(249, 'p1', 'Make a bed', 'Severe difficulty', 4, '2024-11-08 14:01:06'),
(250, 'p1', 'Carry a shopping bag or briefcase', 'Severe difficulty', 4, '2024-11-08 14:01:06'),
(251, 'p1', 'Carry a heavy object (over 10 lbs)', 'Severe difficulty', 4, '2024-11-08 14:01:06'),
(252, 'p1', 'Change a lightbulb overhead', 'Mild difficulty', 2, '2024-11-08 14:01:06'),
(253, 'p1', 'Wash or blow dry your hair', 'Severe difficulty', 4, '2024-11-08 14:01:06'),
(254, 'p1', 'Wash your back', 'Moderate difficulty', 3, '2024-11-08 14:01:06'),
(255, 'p1', 'Put on a pullover sweater', 'Moderate difficulty', 3, '2024-11-08 14:01:06'),
(256, 'p1', 'Use a knife to cut food', 'Severe difficulty', 4, '2024-11-08 14:01:06'),
(257, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Moderate difficulty', 3, '2024-11-08 14:01:06'),
(258, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Mild difficulty', 2, '2024-11-08 14:01:06'),
(259, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Severe difficulty', 4, '2024-11-08 14:01:06'),
(260, 'p1', 'Manage transportation needs (getting from one place to another)', 'Moderate difficulty', 3, '2024-11-08 14:01:06'),
(261, 'p1', 'Sexual activities', 'Severe difficulty', 4, '2024-11-08 14:01:06'),
(262, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Moderately', 3, '2024-11-08 14:01:06'),
(263, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Moderately limited', 3, '2024-11-08 14:01:06'),
(264, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-08 14:01:06'),
(265, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Extreme', 5, '2024-11-08 14:01:06'),
(266, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 14:01:06'),
(267, 'p1', 'Weakness in your arm, shoulder or hand', 'Moderate', 3, '2024-11-08 14:01:06'),
(268, 'p1', 'Stiffness in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 14:01:06'),
(269, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Severe difficulty', 4, '2024-11-08 14:01:06'),
(270, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Neither agree nor disagree', 3, '2024-11-08 14:01:06'),
(271, 'p1', 'Write', 'Mild difficulty', 2, '2024-11-08 14:01:13'),
(272, 'p1', 'Open a tight or new jar', 'Moderate difficulty', 3, '2024-11-08 14:01:13'),
(273, 'p1', 'Turn a key', 'Moderate difficulty', 3, '2024-11-08 14:01:13'),
(274, 'p1', 'Prepare a meal', 'Severe difficulty', 4, '2024-11-08 14:01:13'),
(275, 'p1', 'Push open a heavy door', 'Moderate difficulty', 3, '2024-11-08 14:01:13'),
(276, 'p1', 'Place an object on a shelf above your head', 'Moderate difficulty', 3, '2024-11-08 14:01:13'),
(277, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Unable', 5, '2024-11-08 14:01:13'),
(278, 'p1', 'Garden or do yard work', 'Moderate difficulty', 3, '2024-11-08 14:01:13'),
(279, 'p1', 'Make a bed', 'Severe difficulty', 4, '2024-11-08 14:01:13'),
(280, 'p1', 'Carry a shopping bag or briefcase', 'Severe difficulty', 4, '2024-11-08 14:01:13'),
(281, 'p1', 'Carry a heavy object (over 10 lbs)', 'Severe difficulty', 4, '2024-11-08 14:01:13'),
(282, 'p1', 'Change a lightbulb overhead', 'Mild difficulty', 2, '2024-11-08 14:01:13'),
(283, 'p1', 'Wash or blow dry your hair', 'Severe difficulty', 4, '2024-11-08 14:01:13'),
(284, 'p1', 'Wash your back', 'Moderate difficulty', 3, '2024-11-08 14:01:13'),
(285, 'p1', 'Put on a pullover sweater', 'Moderate difficulty', 3, '2024-11-08 14:01:13'),
(286, 'p1', 'Use a knife to cut food', 'Severe difficulty', 4, '2024-11-08 14:01:13'),
(287, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Moderate difficulty', 3, '2024-11-08 14:01:13'),
(288, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Mild difficulty', 2, '2024-11-08 14:01:13'),
(289, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Severe difficulty', 4, '2024-11-08 14:01:13'),
(290, 'p1', 'Manage transportation needs (getting from one place to another)', 'Moderate difficulty', 3, '2024-11-08 14:01:13'),
(291, 'p1', 'Sexual activities', 'Severe difficulty', 4, '2024-11-08 14:01:13'),
(292, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Moderately', 3, '2024-11-08 14:01:13'),
(293, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Moderately limited', 3, '2024-11-08 14:01:13'),
(294, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-08 14:01:13'),
(295, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Extreme', 5, '2024-11-08 14:01:13'),
(296, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 14:01:13'),
(297, 'p1', 'Weakness in your arm, shoulder or hand', 'Moderate', 3, '2024-11-08 14:01:13'),
(298, 'p1', 'Stiffness in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 14:01:13'),
(299, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Severe difficulty', 4, '2024-11-08 14:01:13'),
(300, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Neither agree nor disagree', 3, '2024-11-08 14:01:13'),
(301, 'p1', 'Open a tight or new jar', 'Moderate difficulty', 3, '2024-11-08 14:40:15'),
(302, 'p1', 'Write', 'Moderate difficulty', 3, '2024-11-08 14:40:15'),
(303, 'p1', 'Turn a key', 'Severe difficulty', 4, '2024-11-08 14:40:15'),
(304, 'p1', 'Prepare a meal', 'Moderate difficulty', 3, '2024-11-08 14:40:15'),
(305, 'p1', 'Push open a heavy door', 'Mild difficulty', 2, '2024-11-08 14:40:15'),
(306, 'p1', 'Place an object on a shelf above your head', 'Mild difficulty', 2, '2024-11-08 14:40:15'),
(307, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Severe difficulty', 4, '2024-11-08 14:40:15'),
(308, 'p1', 'Garden or do yard work', 'Moderate difficulty', 3, '2024-11-08 14:40:15'),
(309, 'p1', 'Make a bed', 'Severe difficulty', 4, '2024-11-08 14:40:15'),
(310, 'p1', 'Carry a shopping bag or briefcase', 'Moderate difficulty', 3, '2024-11-08 14:40:15'),
(311, 'p1', 'Carry a heavy object (over 10 lbs)', 'Moderate difficulty', 3, '2024-11-08 14:40:15'),
(312, 'p1', 'Change a lightbulb overhead', 'Moderate difficulty', 3, '2024-11-08 14:40:15'),
(313, 'p1', 'Wash or blow dry your hair', 'Severe difficulty', 4, '2024-11-08 14:40:15'),
(314, 'p1', 'Wash your back', 'Moderate difficulty', 3, '2024-11-08 14:40:15'),
(315, 'p1', 'Put on a pullover sweater', 'Severe difficulty', 4, '2024-11-08 14:40:15'),
(316, 'p1', 'Use a knife to cut food', 'Moderate difficulty', 3, '2024-11-08 14:40:15'),
(317, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Severe difficulty', 4, '2024-11-08 14:40:15'),
(318, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Moderate difficulty', 3, '2024-11-08 14:40:15'),
(319, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Moderate difficulty', 3, '2024-11-08 14:40:16'),
(320, 'p1', 'Manage transportation needs (getting from one place to another)', 'Mild difficulty', 2, '2024-11-08 14:40:16'),
(321, 'p1', 'Sexual activities', 'Mild difficulty', 2, '2024-11-08 14:40:16'),
(322, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Slightly', 2, '2024-11-08 14:40:16'),
(323, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Moderately limited', 3, '2024-11-08 14:40:16'),
(324, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-08 14:40:16'),
(325, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Severe', 4, '2024-11-08 14:40:16'),
(326, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Moderate', 3, '2024-11-08 14:40:16'),
(327, 'p1', 'Weakness in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 14:40:16'),
(328, 'p1', 'Stiffness in your arm, shoulder or hand', 'Moderate', 3, '2024-11-08 14:40:16'),
(329, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Moderate difficulty', 3, '2024-11-08 14:40:16'),
(330, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Neither agree nor disagree', 3, '2024-11-08 14:40:16'),
(331, 'p1', 'Open a tight or new jar', 'Unable', 5, '2024-11-08 14:46:49'),
(332, 'p1', 'Write', 'Mild difficulty', 2, '2024-11-08 14:46:49'),
(333, 'p1', 'Turn a key', 'No difficulty', 1, '2024-11-08 14:46:49'),
(334, 'p1', 'Prepare a meal', 'Severe difficulty', 4, '2024-11-08 14:46:49'),
(335, 'p1', 'Push open a heavy door', 'No difficulty', 1, '2024-11-08 14:46:49'),
(336, 'p1', 'Place an object on a shelf above your head', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(337, 'p1', 'Do heavy household chores (e.g., wash walls, wash floors)', 'Severe difficulty', 4, '2024-11-08 14:46:49'),
(338, 'p1', 'Garden or do yard work', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(339, 'p1', 'Make a bed', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(340, 'p1', 'Carry a shopping bag or briefcase', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(341, 'p1', 'Carry a heavy object (over 10 lbs)', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(342, 'p1', 'Change a lightbulb overhead', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(343, 'p1', 'Wash or blow dry your hair', 'Severe difficulty', 4, '2024-11-08 14:46:49'),
(344, 'p1', 'Wash your back', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(345, 'p1', 'Put on a pullover sweater', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(346, 'p1', 'Use a knife to cut food', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(347, 'p1', 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(348, 'p1', 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(349, 'p1', 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)', 'Unable', 5, '2024-11-08 14:46:49'),
(350, 'p1', 'Manage transportation needs (getting from one place to another)', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(351, 'p1', 'Sexual activities', 'Moderate difficulty', 3, '2024-11-08 14:46:49'),
(352, 'p1', 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?', 'Slightly', 2, '2024-11-08 14:46:49'),
(353, 'p1', 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?', 'Slightly limited', 2, '2024-11-08 14:46:49'),
(354, 'p1', 'Arm, shoulder or hand pain', 'Moderate', 3, '2024-11-08 14:46:49'),
(355, 'p1', 'Arm, shoulder or hand pain when you performed any specific activity', 'Extreme', 5, '2024-11-08 14:46:49'),
(356, 'p1', 'Tingling (pins and needles) in your arm, shoulder or hand', 'Moderate', 3, '2024-11-08 14:46:49'),
(357, 'p1', 'Weakness in your arm, shoulder or hand', 'Moderate', 3, '2024-11-08 14:46:49'),
(358, 'p1', 'Stiffness in your arm, shoulder or hand', 'Severe', 4, '2024-11-08 14:46:49'),
(359, 'p1', 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?', 'Severe difficulty', 4, '2024-11-08 14:46:49'),
(360, 'p1', 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem', 'Agree', 4, '2024-11-08 14:46:49');

-- --------------------------------------------------------

--
-- Table structure for table `doctorappointments`
--

CREATE TABLE `doctorappointments` (
  `id` int(11) NOT NULL,
  `appointmentId` varchar(20) NOT NULL,
  `doctorId` varchar(20) NOT NULL,
  `doctorname` varchar(100) NOT NULL,
  `specialization` varchar(100) NOT NULL,
  `experience` int(11) NOT NULL,
  `doctorImage` varchar(255) NOT NULL,
  `patientId` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `patientCase` text NOT NULL,
  `patientImage` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctorappointments`
--

INSERT INTO `doctorappointments` (`id`, `appointmentId`, `doctorId`, `doctorname`, `specialization`, `experience`, `doctorImage`, `patientId`, `name`, `patientCase`, `patientImage`, `date`, `start_time`, `end_time`, `status`, `created_at`) VALUES
(1, 'appoin_0001', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-08-28', '17:22:50', '17:22:50', 'accepted', '2024-08-28 11:52:46'),
(2, 'appoin_0002', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-08-28', '17:22:50', '17:22:50', 'rejected', '2024-08-28 11:52:48'),
(3, 'appoin_0003', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-02', '12:44:09', '12:44:09', 'pending', '2024-09-02 07:14:12'),
(4, 'appoin_0004', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-17', '21:28:16', '21:28:16', 'pending', '2024-09-17 15:58:15'),
(5, 'appoin_0005', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-17', '21:34:05', '21:34:05', 'pending', '2024-09-17 16:04:03'),
(6, 'appoin_0006', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-17', '22:17:27', '22:17:27', 'pending', '2024-09-17 16:47:26'),
(7, 'appoin_0007', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-18', '10:22:38', '10:22:38', 'pending', '2024-09-18 04:52:35'),
(8, 'appoin_0008', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-18', '10:23:03', '10:23:03', 'accepted', '2024-09-18 04:53:00'),
(9, 'appoin_0009', 'd1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-11-01', '12:53:00', '12:53:00', 'pending', '2024-11-01 07:24:52'),
(10, 'appoin_0010', 'd1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-11-01', '12:53:00', '12:53:00', 'pending', '2024-11-01 07:26:38'),
(11, 'appoin_0011', 'd1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-11-01', '12:53:00', '12:53:00', 'pending', '2024-11-01 07:30:18'),
(12, 'appoin_0012', 'd1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P125', 'Krishna ', 'shoulder ', 'uploads/1000136603.jpg', '2024-11-01', '01:45:00', '01:45:00', 'pending', '2024-11-01 08:15:19'),
(13, 'appoin_0013', 'd1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P44', 'Krishna ', 'Ccc', 'uploads/208b82c1-c748-4788-a19c-b35090ba13b9.jpeg', '2024-11-01', '02:06:00', '02:06:00', 'pending', '2024-11-01 08:36:21'),
(14, 'appoin_0014', 'd1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-11-01', '02:08:00', '02:08:00', 'rejected', '2024-11-01 08:38:59'),
(15, 'appoin_0015', 'd1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-11-01', '08:46:00', '08:46:00', 'accepted', '2024-11-01 15:16:49'),
(16, 'appoin_0016', 'D1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P44', 'Krishna ', 'Ccc', 'uploads/208b82c1-c748-4788-a19c-b35090ba13b9.jpeg', '2024-11-01', '09:36:00', '09:36:00', 'pending', '2024-11-01 16:06:01'),
(17, 'appoin_0017', 'd1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-11-02', '06:41:00', '06:41:00', 'accepted', '2024-11-02 13:11:10'),
(18, 'appoin_0018', 'd1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-11-02', '10:15:00', '10:15:00', 'accepted', '2024-11-02 16:45:41'),
(19, 'appoin_0019', 'D1', 'Hari Krishna  raj ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P356789', 'kush ', 'sha ', 'uploads/1000139386.jpg', '2024-11-04', '03:17:00', '03:17:00', 'pending', '2024-11-04 09:47:30'),
(20, 'appoin_0020', 'D1', 'Hari Krishna  ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P356789', 'kush ', 'sha ', 'uploads/1000139386.jpg', '2024-11-05', '02:13:00', '02:13:00', 'pending', '2024-11-05 08:45:14'),
(21, 'appoin_0021', 'D1', 'Hari Krishna  raj', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P356789', 'kush ', 'sha ', 'uploads/1000139386.jpg', '2024-11-05', '04:09:00', '04:09:00', 'pending', '2024-11-05 10:39:26');

-- --------------------------------------------------------

--
-- Table structure for table `doctorlogin`
--

CREATE TABLE `doctorlogin` (
  `id` int(11) NOT NULL,
  `doctorId` varchar(255) NOT NULL,
  `doctorname` varchar(255) NOT NULL,
  `phoneno` varchar(15) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `experience` int(11) DEFAULT NULL,
  `specialization` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `confirmpassword` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctorlogin`
--

INSERT INTO `doctorlogin` (`id`, `doctorId`, `doctorname`, `phoneno`, `gender`, `age`, `experience`, `specialization`, `password`, `confirmpassword`, `image`, `created_at`, `updated_at`) VALUES
(1, 'D1', 'Hari Krishna  raj', '7093849916', 'Male ', 21, 5, 'Shoulder specialist ', 'Krishna0505', 'Krishna0505', 'uploads/6729f57c44454_1000000311.png', '2024-08-28 11:39:49', '2024-11-05 10:37:48'),
(2, 'D12', 'Lavanya ', '9182681655', 'Fem6', 21, 6, 'Shoulder pain', 'Krishna05051', NULL, 'uploads/1e5ac4ba-ffc7-40f7-ac47-2eabd1c1d528.jpeg', '2024-08-28 11:43:30', '2024-11-04 10:39:57'),
(3, 'D123', 'Krishna ', '9821353696', 'Male ', 21, 6, 'Shoulder length ', 'Krishna12345', NULL, 'uploads/1832b875-409a-490e-9614-1c8f5c6e8331.jpeg', '2024-08-28 11:52:05', '2024-08-28 11:52:05'),
(4, 'D1234', 'Raji ', '8885215421', 'Female ', 22, 5, 'Shoulder length ', 'Hari12345', NULL, 'uploads/03119a69-cec2-40e0-9017-7efb4b6ec2c2.jpeg', '2024-09-11 01:03:44', '2024-09-11 01:03:44'),
(5, 'D34', 'Krishna ', '9182681655', 'Male', 21, 5, 'Sholoana ', 'Hari1234', NULL, 'uploads/18150050-004d-4766-b76d-76b6a226d575.jpeg', '2024-09-17 14:18:17', '2024-09-17 14:18:17'),
(6, 'D12345', 'Krishna ', '9182681655', 'Male ', 21, 0, 'Shoulder ', 'Hari12345', NULL, 'uploads/3a01ead6-b9e4-4fd0-8b67-e8ac2a304c75.png', '2024-09-17 16:00:01', '2024-09-17 16:00:01'),
(7, 'D244', 'Hari Krishna Hari', '9182681655', 'Male ', 21, 5, 'Shoulder ', '123Hari1', NULL, 'uploads/5a4c2bdc-41b5-45fe-850c-9b5661d43c5f.jpeg', '2024-09-23 15:18:58', '2024-09-23 15:18:58'),
(8, 'D1223', 'Krishna ', '7093849918', '21', 21, 5, 'shoulder ', 'Hari1234', NULL, 'uploads/1000136603.jpg', '2024-10-21 17:23:47', '2024-10-21 17:23:47');

-- --------------------------------------------------------

--
-- Table structure for table `medical_history`
--

CREATE TABLE `medical_history` (
  `id` int(11) NOT NULL,
  `questions` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `medical_history`
--

INSERT INTO `medical_history` (`id`, `questions`) VALUES
(1, 'Have you ever been diagnosed with a frozen shoulder (adhesive capsulitis) before? If yes, please provide details.'),
(2, 'Have you experienced any shoulder injuries or surgeries in the past? If yes, please provide details.'),
(3, 'Do you have any other ongoing medical conditions? Please list them.'),
(4, 'Are you currently taking any medications? If yes, please provide a list of medications along with their dosages.'),
(5, 'When did you first notice the symptoms of frozen shoulder?'),
(6, 'On a scale of 1 to 10, how severe is your pain (1 being no pain, 10 being the worst pain you\'ve ever experienced)?'),
(7, 'Have you experienced any stiffness or reduced range of motion in your affected shoulder? If yes, please describe.'),
(8, 'Do you have any difficulty performing daily activities due to your frozen shoulder? If yes, please specify.'),
(9, 'Have you noticed any swelling or redness in your affected shoulder?'),
(10, 'What is your primary occupation or daily activities?'),
(11, 'How often do you use your affected shoulder in your daily activities?'),
(12, 'Do you engage in any sports or physical activities that involve your shoulder? If yes, please specify.'),
(13, 'Have you noticed any changes in your sleep patterns due to your frozen shoulder?'),
(14, 'Have you consulted a healthcare professional regarding your frozen shoulder? If yes, please provide details.'),
(15, 'Have you undergone any treatments or therapies for your frozen shoulder? If yes, please provide details.'),
(16, 'Are you currently following any specific exercise or rehabilitation program for your frozen shoulder? If yes, please provide details.'),
(17, 'Have you tried any home remedies or over-the-counter medications for your frozen shoulder? If yes, please provide details.');

-- --------------------------------------------------------

--
-- Table structure for table `medical_history_answ`
--

CREATE TABLE `medical_history_answ` (
  `id` int(11) NOT NULL,
  `patientId` varchar(50) NOT NULL,
  `questions` text NOT NULL,
  `options` varchar(10) NOT NULL,
  `inp_data` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `medical_history_answ`
--

INSERT INTO `medical_history_answ` (`id`, `patientId`, `questions`, `options`, `inp_data`, `created_at`) VALUES
(1, 'p10', 'Have you ever been diagnosed with a frozen shoulder (adhesive capsulitis) before? If yes, please provide details.', 'yes', '', '2024-10-29 06:56:22'),
(2, 'p10', 'Have you experienced any shoulder injuries or surgeries in the past? If yes, please provide details.', 'No', '', '2024-10-29 06:56:22'),
(3, 'p10', 'Do you have any other ongoing medical conditions? Please list them.', 'No', '', '2024-10-29 06:56:22'),
(4, 'p10', 'Are you currently taking any medications? If yes, please provide a list of medications along with their dosages.', 'No', '', '2024-10-29 06:56:22'),
(5, 'p10', 'When did you first notice the symptoms of frozen shoulder?', 'No', '', '2024-10-29 06:56:22'),
(6, 'p10', 'On a scale of 1 to 10, how severe is your pain (1 being no pain, 10 being the worst pain you\\\'ve ever experienced)?', 'No', '', '2024-10-29 06:56:22'),
(7, 'p10', 'Have you experienced any stiffness or reduced range of motion in your affected shoulder? If yes, please describe.', 'No', '', '2024-10-29 06:56:22'),
(8, 'p10', 'Do you have any difficulty performing daily activities due to your frozen shoulder? If yes, please specify.', 'No', '', '2024-10-29 06:56:22'),
(9, 'p10', 'Have you noticed any swelling or redness in your affected shoulder?', 'No', '', '2024-10-29 06:56:22'),
(10, 'p10', 'What is your primary occupation or daily activities?', 'No', '', '2024-10-29 06:56:22'),
(11, 'p10', 'How often do you use your affected shoulder in your daily activities?', 'No', '', '2024-10-29 06:56:22'),
(12, 'p10', 'Do you engage in any sports or physical activities that involve your shoulder? If yes, please specify.', 'No', '', '2024-10-29 06:56:22'),
(13, 'p10', 'Have you noticed any changes in your sleep patterns due to your frozen shoulder?', 'No', '', '2024-10-29 06:56:22'),
(14, 'p10', 'Have you consulted a healthcare professional regarding your frozen shoulder? If yes, please provide details.', 'No', '', '2024-10-29 06:56:22'),
(15, 'p10', 'Have you undergone any treatments or therapies for your frozen shoulder? If yes, please provide details.', 'No', '', '2024-10-29 06:56:22'),
(16, 'p10', 'Are you currently following any specific exercise or rehabilitation program for your frozen shoulder? If yes, please provide details.', 'No', '', '2024-10-29 06:56:22'),
(17, 'p10', 'Have you tried any home remedies or over-the-counter medications for your frozen shoulder? If yes, please provide details.', 'No', '', '2024-10-29 06:56:22'),
(18, 'p1', 'Have you ever been diagnosed with a frozen shoulder (adhesive capsulitis) before? If yes, please provide details.', 'No', '', '2024-10-29 07:00:43'),
(19, 'p1', 'Have you experienced any shoulder injuries or surgeries in the past? If yes, please provide details.', 'No', '', '2024-10-29 07:00:43'),
(20, 'p1', 'Do you have any other ongoing medical conditions? Please list them.', 'No', '', '2024-10-29 07:00:43'),
(21, 'p1', 'Are you currently taking any medications? If yes, please provide a list of medications along with their dosages.', 'No', '', '2024-10-29 07:00:43'),
(22, 'p1', 'When did you first notice the symptoms of frozen shoulder?', 'No', '', '2024-10-29 07:00:43'),
(23, 'p1', 'On a scale of 1 to 10, how severe is your pain (1 being no pain, 10 being the worst pain you\\\'ve ever experienced)?', 'No', '', '2024-10-29 07:00:43'),
(24, 'p1', 'Have you experienced any stiffness or reduced range of motion in your affected shoulder? If yes, please describe.', 'No', '', '2024-10-29 07:00:43'),
(25, 'p1', 'Do you have any difficulty performing daily activities due to your frozen shoulder? If yes, please specify.', 'No', '', '2024-10-29 07:00:43'),
(26, 'p1', 'Have you noticed any swelling or redness in your affected shoulder?', 'No', '', '2024-10-29 07:00:43'),
(27, 'p1', 'What is your primary occupation or daily activities?', 'No', '', '2024-10-29 07:00:43'),
(28, 'p1', 'How often do you use your affected shoulder in your daily activities?', 'No', '', '2024-10-29 07:00:43'),
(29, 'p1', 'Do you engage in any sports or physical activities that involve your shoulder? If yes, please specify.', 'No', '', '2024-10-29 07:00:43'),
(30, 'p1', 'Have you noticed any changes in your sleep patterns due to your frozen shoulder?', 'No', '', '2024-10-29 07:00:43'),
(31, 'p1', 'Have you consulted a healthcare professional regarding your frozen shoulder? If yes, please provide details.', 'No', '', '2024-10-29 07:00:43'),
(32, 'p1', 'Have you undergone any treatments or therapies for your frozen shoulder? If yes, please provide details.', 'No', '', '2024-10-29 07:00:43'),
(33, 'p1', 'Are you currently following any specific exercise or rehabilitation program for your frozen shoulder? If yes, please provide details.', 'No', '', '2024-10-29 07:00:43'),
(34, 'p1', 'Have you tried any home remedies or over-the-counter medications for your frozen shoulder? If yes, please provide details.', 'No', '', '2024-10-29 07:00:43');

-- --------------------------------------------------------

--
-- Table structure for table `patientappointments`
--

CREATE TABLE `patientappointments` (
  `id` int(11) NOT NULL,
  `appointmentId` varchar(200) NOT NULL,
  `doctorId` varchar(200) NOT NULL,
  `doctorname` varchar(255) NOT NULL,
  `specialization` varchar(255) NOT NULL,
  `experience` int(11) NOT NULL,
  `doctorImage` varchar(255) DEFAULT NULL,
  `patientId` varchar(200) NOT NULL,
  `name` varchar(255) NOT NULL,
  `patientCase` text DEFAULT NULL,
  `patientImage` varchar(255) DEFAULT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `status` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `start_time` time NOT NULL,
  `end_time` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patientappointments`
--

INSERT INTO `patientappointments` (`id`, `appointmentId`, `doctorId`, `doctorname`, `specialization`, `experience`, `doctorImage`, `patientId`, `name`, `patientCase`, `patientImage`, `date`, `time`, `status`, `created_at`, `start_time`, `end_time`) VALUES
(1, 'appoin_0001', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-08-28', '17:54:14', 'rejected', '2024-08-28 12:24:11', '17:54:14', '17:54:14'),
(2, 'appoin_0002', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-08-28', '18:07:16', 'accepted', '2024-08-28 12:37:13', '18:07:16', '18:07:16'),
(3, 'appoin_0003', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-02', '12:51:16', 'pending', '2024-09-02 07:21:12', '12:51:16', '12:51:16'),
(4, 'appoin_0004', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-02', '12:51:16', 'rejected', '2024-09-02 07:21:13', '12:51:16', '12:51:16'),
(5, 'appoin_0005', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-02', '12:51:16', 'rejected', '2024-09-02 07:21:15', '12:51:16', '12:51:16'),
(6, 'appoin_0006', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-02', '12:51:16', 'accepted', '2024-09-02 07:21:16', '12:51:16', '12:51:16'),
(7, 'appoin_0007', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-02', '13:20:54', 'accepted', '2024-09-02 07:50:51', '13:20:54', '13:20:54'),
(8, 'appoin_0008', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P123', 'Raj ', 'Shoulder pain ', 'uploads/66e5086cd3280_photo.png', '2024-09-14', '09:21:58', 'accepted', '2024-09-14 03:51:59', '09:21:58', '09:21:58'),
(9, 'appoin_0009', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-16', '14:34:25', 'accepted', '2024-09-16 09:04:26', '14:34:25', '14:34:25'),
(10, 'appoin_0010', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-17', '16:14:49', 'accepted', '2024-09-17 10:44:49', '16:14:49', '16:14:49'),
(11, 'appoin_0011', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-17', '19:50:39', 'rejected', '2024-09-17 14:20:39', '19:50:39', '19:50:39'),
(12, 'appoin_0012', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-17', '19:57:47', 'rejected', '2024-09-17 14:27:44', '19:57:47', '19:57:47'),
(13, 'appoin_0013', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-17', '21:37:39', 'rejected', '2024-09-17 16:07:36', '21:37:39', '21:37:39'),
(14, 'appoin_0014', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-17', '22:18:09', 'rejected', '2024-09-17 16:48:07', '22:18:09', '22:18:09'),
(15, 'appoin_0015', 'D1', 'Hari Krishna ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-09-18', '10:22:04', 'accepted', '2024-09-18 04:52:01', '10:22:04', '10:22:04'),
(16, 'appoin_0016', 'D1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-10-31', '02:39:00', 'accepted', '2024-10-31 09:10:52', '02:39:00', '02:39:00'),
(17, 'appoin_0017', 'D1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-10-31', '02:39:00', 'accepted', '2024-10-31 09:11:45', '02:39:00', '02:39:00'),
(18, 'appoin_0018', 'D1', 'Hari Krishna  Reel ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj ', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-11-02', '10:17:00', 'accepted', '2024-11-02 16:47:14', '10:17:00', '10:17:00'),
(19, 'appoin_0019', 'D1', 'Hari Krishna  raj ', 'Shoulder specialist ', 5, 'uploads/6729f57c44454_1000000311.png', 'P1', 'Krishna raj', 'Shoulder pain ', 'uploads/6729f416c7454_1000000312.png', '2024-11-04', '03:19:00', 'rejected', '2024-11-04 09:49:23', '03:19:00', '03:19:00');

-- --------------------------------------------------------

--
-- Table structure for table `patientlogin`
--

CREATE TABLE `patientlogin` (
  `id` int(11) NOT NULL,
  `patientId` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `contactNo` varchar(15) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `height` float DEFAULT NULL,
  `weight` float DEFAULT NULL,
  `patientCase` text DEFAULT NULL,
  `painDuration` varchar(255) DEFAULT NULL,
  `admittedOn` date DEFAULT NULL,
  `rbs` int(11) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `confirmPassword` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `doctorId` varchar(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patientlogin`
--

INSERT INTO `patientlogin` (`id`, `patientId`, `name`, `contactNo`, `age`, `gender`, `height`, `weight`, `patientCase`, `painDuration`, `admittedOn`, `rbs`, `password`, `confirmPassword`, `image`, `doctorId`, `created_at`, `updated_at`) VALUES
(1, 'P1', 'Krishna raj', '7093849918', 26, 'Male', 170, 69, 'Shoulder pain ', '6months', '2024-08-28', 120, 'Krishna1234', 'Krishna1234', 'uploads/6729f416c7454_1000000312.png', 'D1', '2024-08-28 11:47:33', '2024-11-05 10:31:50'),
(2, 'P12', 'Sahi', '8555437052', 21, 'Female', 25, 45, 'Shoulder pain ', '5', '2024-08-28', 120, 'Sahi12345', 'Sahi12345', 'uploads/66f1866393e34_photo.png', 'D1', '2024-08-28 11:49:06', '2024-10-19 17:31:31'),
(3, 'P123', 'Raj ', '7093849918', 22, 'Male', 66, 77, 'Shoulder pain ', '65', '2024-08-28', 120, 'Hari12345', 'Hari12345', 'uploads/66e5086cd3280_photo.png', 'D1', '2024-08-28 12:18:22', '2024-10-19 17:31:36'),
(4, 'P44', 'Krishna ', '7093849918', 21, 'Male', 22, 55, 'Ccc', ' C', '2024-09-17', 120, 'Hari1234', 'Hari1234', 'uploads/208b82c1-c748-4788-a19c-b35090ba13b9.jpeg', 'D1', '2024-09-17 14:19:12', '2024-10-19 17:31:44'),
(5, 'P123456', 'Krishna ', '7093849918', 21, 'Male', 25, 58, 'Shoulder ', '21', '2024-09-17', 120, 'Krishna12345', 'Krishna12345', 'uploads/81cd3384-40d0-4ae6-b1d8-133ea9ade53a.jpeg', 'D123', '2024-09-17 16:02:11', '2024-10-19 16:20:50'),
(6, 'P1346', 'Hari Krishna Hari', '7093849918', 21, 'Male', 78, 33, 'Shoulder ', '7', '2024-09-17', 120, 'Hari1234', 'Hari1234', 'uploads/1ddc6966-2b6b-436b-8100-dbadcce24104.png', 'D1', '2024-09-17 16:05:32', '2024-10-20 06:09:47'),
(7, 'P56', 'Krishna  Reddy ', '7093849918', 21, 'Male', 22, 35, 'Shoulder ', '65', '2024-09-23', 120, 'Hari12345', 'Hari12345', 'uploads/20c783a4-3bf4-478a-a65d-a381120ad896.jpeg', 'D1', '2024-09-23 15:19:54', '2024-10-22 17:42:06'),
(8, 'P125', 'Krishna ', '7093849918', 21, 'Male', 52, 12, 'shoulder ', '5', '2024-10-21', 120, 'hari1234', 'hari1234', 'uploads/1000136603.jpg', 'D1', '2024-10-21 18:05:37', '2024-10-21 18:05:37'),
(9, 'P10', 'Krishna ', '7093849918', 21, 'Male', 21, 35, 'ccc', '8', '2024-10-21', 120, 'Hari1234', 'Hari1234', 'uploads/1000135566.jpg', 'D1', '2024-10-21 18:16:43', '2024-10-21 18:16:43'),
(10, 'P356', 'kush ', 'P356', 21, 'Male', 25, 25, 'sha ', '5', '2024-11-01', 120, 'Hari1234', 'Hari1234', 'uploads/1000139386.jpg', 'D1', '2024-11-01 16:59:05', '2024-11-01 16:59:05'),
(11, 'P3567', 'kush ', 'P3567', 21, 'Female', 25, 25, 'sha ', '5', '2024-11-01', 120, 'Hari1234', 'Hari1234', 'uploads/1000139386.jpg', 'D1', '2024-11-01 17:09:21', '2024-11-01 17:09:21'),
(12, 'P35678', 'kush ', 'P35678', 21, 'Female', 25, 25, 'sha ', '5', '2024-11-01', 120, 'Hari1234', 'Hari1234', 'uploads/1000139386.jpg', 'D1', '2024-11-01 17:15:02', '2024-11-01 17:15:02'),
(13, 'P356789', 'kush ', 'P356789', 21, 'Female', 25, 25, 'sha ', '5', '2024-11-01', 120, 'Hari1234', 'Hari1234', 'uploads/1000139386.jpg', 'D1', '2024-11-01 17:17:10', '2024-11-01 17:17:10');

-- --------------------------------------------------------

--
-- Table structure for table `patientscores`
--

CREATE TABLE `patientscores` (
  `id` int(11) NOT NULL,
  `patientId` varchar(50) NOT NULL,
  `numberOfAnsweredItems` int(11) NOT NULL,
  `sumOfScores` int(11) NOT NULL,
  `dashScore` float NOT NULL,
  `difficultyCategory` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patientscores`
--

INSERT INTO `patientscores` (`id`, `patientId`, `numberOfAnsweredItems`, `sumOfScores`, `dashScore`, `difficultyCategory`, `created_at`) VALUES
(5, 'p1', 30, 98, 56, 'Moderate difficulty: The individual faces moderate challenges and may need to adapt how they perform certain tasks.', '2024-10-24 15:18:14'),
(9, 'p1', 30, 113, 69, 'Severe difficulty: The individual has significant difficulty performing many activities and may need substantial assistance.', '2024-10-30 10:10:25'),
(16, 'p1', 30, 95, 54, 'Moderate difficulty: The individual faces moderate challenges and may need to adapt how they perform certain tasks.', '2024-11-08 14:46:49');

-- --------------------------------------------------------

--
-- Table structure for table `selected_videos`
--

CREATE TABLE `selected_videos` (
  `id` int(11) NOT NULL,
  `doctorId` varchar(200) NOT NULL,
  `patientId` varchar(200) NOT NULL,
  `video_path` varchar(255) NOT NULL,
  `introduction` text NOT NULL,
  `custom_file_name` varchar(255) NOT NULL,
  `selected_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `selected_videos`
--

INSERT INTO `selected_videos` (`id`, `doctorId`, `patientId`, `video_path`, `introduction`, `custom_file_name`, `selected_date`) VALUES
(3, 'D1', 'P1', 'uploads/Finger fist_4272235a-c2e9-4361-85fb-bc020780fff6.mp4', 'Finger fist', 'Finger fist', '2024-08-28 12:39:06'),
(4, 'D1', 'P1', 'uploads/Shoulder _450cd544-1645-404c-adac-ac3ee09bf770.mp4', 'Shoulder ', 'Shoulder ', '2024-09-17 16:03:41'),
(5, 'd1', 'P1', 'uploads/Finger fist_4272235a-c2e9-4361-85fb-bc020780fff6.mp4', 'Finger fist', 'Finger fist', '2024-11-02 13:07:37'),
(6, 'd1', 'P1', 'uploads/Biceps curl_4d3e3404-b3fb-4425-88cc-46c1d9b119ee.mp4', 'Biceps curl', 'Biceps curl', '2024-11-02 13:07:37'),
(7, 'd1', 'P44', 'uploads/Finger fist_4272235a-c2e9-4361-85fb-bc020780fff6.mp4', 'Finger fist', 'Finger fist', '2024-11-02 13:07:56'),
(8, 'd1', 'P44', 'uploads/Biceps curl_4d3e3404-b3fb-4425-88cc-46c1d9b119ee.mp4', 'Biceps curl', 'Biceps curl', '2024-11-02 13:07:56'),
(9, 'D1', 'P356789', 'uploads/Finger fist_4272235a-c2e9-4361-85fb-bc020780fff6.mp4', 'Finger fist', 'Finger fist', '2024-11-04 09:46:26');

-- --------------------------------------------------------

--
-- Table structure for table `weaklyquestions`
--

CREATE TABLE `weaklyquestions` (
  `id` int(11) NOT NULL,
  `question` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `weaklyquestions`
--

INSERT INTO `weaklyquestions` (`id`, `question`) VALUES
(1, 'Open a tight or new jar'),
(2, 'Write'),
(3, 'Turn a key'),
(4, 'Prepare a meal'),
(5, 'Push open a heavy door'),
(6, 'Place an object on a shelf above your head'),
(7, 'Do heavy household chores (e.g., wash walls, wash floors)'),
(8, 'Garden or do yard work'),
(9, 'Make a bed'),
(10, 'Carry a shopping bag or briefcase'),
(11, 'Carry a heavy object (over 10 lbs)'),
(12, 'Change a lightbulb overhead'),
(13, 'Wash or blow dry your hair'),
(14, 'Wash your back'),
(15, 'Put on a pullover sweater'),
(16, 'Use a knife to cut food'),
(17, 'Recreational activities which require little effort (e.g., cardplaying, knitting, etc)'),
(18, 'Recreational activities in which you take some force or impact through your arm, shoulder or hand (e.g., golf, hammering, tennis, etc)'),
(19, 'Recreational activities in which you move your arm freely (e.g., playing frisbee, badminton, etc)'),
(20, 'Manage transportation needs (getting from one place to another)'),
(21, 'Sexual activities'),
(22, 'During the past week, to what extent has your arm, shoulder or hand problem interfered with your normal social activities with family, friends, neighbours or groups?'),
(23, 'During the past week, were you limited in your work or other regular daily activities as a result of your arm, shoulder or hand problem?'),
(24, 'Arm, shoulder or hand pain'),
(25, 'Arm, shoulder or hand pain when you performed any specific activity'),
(26, 'Tingling (pins and needles) in your arm, shoulder or hand'),
(27, 'Weakness in your arm, shoulder or hand'),
(28, 'Stiffness in your arm, shoulder or hand'),
(29, 'During the past week, how much difficulty have you had sleeping because of the pain in your arm, shoulder or hand?'),
(30, 'I feel less capable, less confident or less useful because of my arm, shoulder or hand problem');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `adddoctorvideos`
--
ALTER TABLE `adddoctorvideos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `adminlogin`
--
ALTER TABLE `adminlogin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `daily_task`
--
ALTER TABLE `daily_task`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dash_score`
--
ALTER TABLE `dash_score`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `doctorappointments`
--
ALTER TABLE `doctorappointments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `appointmentId` (`appointmentId`);

--
-- Indexes for table `doctorlogin`
--
ALTER TABLE `doctorlogin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `medical_history`
--
ALTER TABLE `medical_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `medical_history_answ`
--
ALTER TABLE `medical_history_answ`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `patientappointments`
--
ALTER TABLE `patientappointments`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `patientlogin`
--
ALTER TABLE `patientlogin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `patientscores`
--
ALTER TABLE `patientscores`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `selected_videos`
--
ALTER TABLE `selected_videos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `weaklyquestions`
--
ALTER TABLE `weaklyquestions`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `adddoctorvideos`
--
ALTER TABLE `adddoctorvideos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `adminlogin`
--
ALTER TABLE `adminlogin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `daily_task`
--
ALTER TABLE `daily_task`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `dash_score`
--
ALTER TABLE `dash_score`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=361;

--
-- AUTO_INCREMENT for table `doctorappointments`
--
ALTER TABLE `doctorappointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `doctorlogin`
--
ALTER TABLE `doctorlogin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `medical_history`
--
ALTER TABLE `medical_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `medical_history_answ`
--
ALTER TABLE `medical_history_answ`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `patientappointments`
--
ALTER TABLE `patientappointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `patientlogin`
--
ALTER TABLE `patientlogin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `patientscores`
--
ALTER TABLE `patientscores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `selected_videos`
--
ALTER TABLE `selected_videos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `weaklyquestions`
--
ALTER TABLE `weaklyquestions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
