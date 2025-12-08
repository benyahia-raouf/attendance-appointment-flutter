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

<img src="docs/wireframes/scanner.png" width="300">
face recognition

<img src="docs/screenshots/attendance_List.png" width="300">
Attendance List

3. Project Structure (Clean Architecture)
lib/
  core/
  app.dart
  main.dart
  features/
    attendance/
      presentation/
        pages/
        cubit/
        widgets/
      domain/
        models/
        repositories/
        usecases/
      data/
        datasources/
        repositories/

4. Tech Stack
Frontend

Flutter

Hive (local DB) 

Dio (HTTP)

Flutter Cubit (State Management)

Camera plugin

FastAPI

InsightFace (buffalo_l model)