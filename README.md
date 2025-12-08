Attendance Appointmen Flutter + FastAPI (Face Recognition)

This project is a mobile attendance application built with Flutter and a FastAPI-based face recognition backend.
Employees can mark their attendance by scanning their face, and the system automatically verifies their identity using InsightFace embeddings.

1. Features
Mobile App (Flutter)

Face scanning for attendance

Automatic match detection (stop scanning when matched)

Attendance history per day

Status badges:

Present (before 08:00)

Late (after 08:00)

Absent (no scan for the day)

Filter attendance by date

Export list to CSV

Local storage of employee reference data using Hive


- Backend (FastAPI)

Face detection

Embedding extraction

Face similarity comparison

Store and query embeddings

Optimized for mobile usage

2. Wireframes

![face recognition](https://github.com/benyahia-raouf/attendance-appointment-flutter/blob/feda80318a24657313b6b990a82c3fc735022cd3/scanner.png)
face recognition

![Attendance List](https://github.com/benyahia-raouf/attendance-appointment-flutter/blob/feda80318a24657313b6b990a82c3fc735022cd3/attendance_List.png)
Attendance List

3. Project Structure (Clean Architecture)

![Project Structure (Clean Architecture)](https://github.com/benyahia-raouf/attendance-appointment-flutter/blob/65c4faf2ef5499ad30632a003e17bdee2e53fca6/Project%20Structure%20(Clean%20Architecture).png)


4. Tech Stack

Flutter

Hive (local DB) 

Dio (HTTP)

Flutter Cubit (State Management)

Camera plugin

FastAPI

InsightFace (buffalo_l model)
